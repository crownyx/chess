require "./movetypes"

class IllegalMoveError < StandardError
end

class Piece
  attr_accessor :player, :number, :rank, :file, :has_moved

  def initialize player, number = nil
    @player = player
    @number = number
    @has_moved = false
    self.rank = self.start_rank
    self.file = self.start_file
  end

  def to_s
    self.player.color_code.join "#{self.abbrev}#{self.number}".center(4)
  end

  def start_file
    self.number
  end

  def start_rank
    0
  end

  def containing_array
    "#{self.class.to_s.downcase}s"
  end

  def move_to rank, file, board
    if self.can_move(board).include?([rank, file]) || self.attacking(board).include?([rank, file])
      @rank, @file = rank, file
      @has_moved = true
      if opposing_piece = board.opposing_on_square(self.player, rank, file)
        opposing_piece.player.pieces.nullify(opposing_piece)
      end
    end
  end

  def blocked_move rank, file, board
    board.piece_in_way(self, rank, file) || 
    board.friendly_on_square(self.player, rank, file)
  end

  def attacking board
    self.can_move(board).select do |rank, file|
      board.opposing_on_square(self.player, rank, file)
    end
  end
end

class Pawn < Piece
  def start_rank
    1
  end

  def abbrev
    "P"
  end

  def can_move board
    (1..(@has_moved ? 1 : 2)).map do |steps|
      [self.rank + steps, self.file]
    end.select do |rank, file|
      !self.blocked_move(rank, file, board)
    end
  end

  def attacking board
    [[self.rank + 1, self.file + 1], [self.rank + 1, self.file - 1]].select do |rank, file|
      !board.friendly_on_square(self.player, rank, file) && board.opposing_on_square(self.player, rank, file)
    end
  end
end

class Rook < Piece
  def start_file
    self.number.zero? ? 0 : 7
  end

  def abbrev
    "R"
  end

  def can_move board
    MoveTypes.all_straight(self).select do |rank, file|
      !self.blocked_move(rank, file, board)
    end
  end
end

class Knight < Piece
  def start_file
    self.number.zero? ? 1 : 6
  end

  def abbrev
    "N"
  end

  def can_move board
    [[self.rank + 1, self.file + 2], [self.rank + 1, self.file - 2],
     [self.rank + 2, self.file + 1], [self.rank - 2, self.file + 1],
     [self.rank - 1, self.file + 2], [self.rank - 1, self.file - 2],
     [self.rank + 2, self.file - 1], [self.rank - 2, self.file - 1]].select do |rank, file|
      rank >= 0 && rank < 8 && file >= 0 && file < 8 &&
      !board.friendly_on_square(self.player, rank, file)
    end
  end
end

class Bishop < Piece
  def abbrev
    "B"
  end

  def start_file
    self.number.zero? ? 2 : 5
  end

  def can_move board
    MoveTypes.all_diagonal(self).select do |rank, file|
      !self.blocked_move(rank, file, board)
    end
  end
end

class Queen < Piece
  def abbrev
    "Q"
  end

  def start_file
    3
  end

  def can_move board
    [*MoveTypes.all_diagonal(self), *MoveTypes.all_straight(self)].select do |rank, file|
      !self.blocked_move(rank, file, board)
    end
  end

  def containing_array
    super[0...-1]
  end
end

class King < Piece
  def abbrev
    "K"
  end

  def start_file
    4
  end

  def containing_array
    super[0...-1]
  end

  def can_move board
    [*MoveTypes.all_diagonal(self, limit: 1), *MoveTypes.all_straight(self, limit: 1)].select do |rank, file|
      !self.blocked_move(rank, file, board)
    end
  end

  def castle board, rook: 1
    rook = self.player.rooks[rook]
    raise IllegalMoveError.new("Can't castle if king or rook has moved") if self.has_moved || rook.has_moved
    raise IllegalMoveError.new("Can't castle if piece between king and rook") if board.piece_in_way(self, 0, rook.file) # not in check or would be in check
    if rook.file == 7
      self.file = 6
      rook.file = 5
    else
      self.file = 2
      rook.file = 3
    end
  end
end
