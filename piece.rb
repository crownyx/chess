require './illegal_piece_move'

class Piece
  attr_reader :player, :number
  attr_accessor :has_moved, :rank, :file

  def initialize player, number = nil
    @player = player
    @number = number
    @file = self.start_file number
    @rank = self.is_a?(Pawn) ? 1 : 0
    @has_moved = false
  end

  def board
    self.player.game.board
  end

  def move rank, file
    @rank, @file = rank, file
    @has_moved = true
  end

  def legal_move? rank, file
    raise NonMove if rank == self.rank && file == self.file
    self.player.game.board.legal_move? self, rank, file
  end

  def to_s
    self.player.color_code.join "#{self.abbrev}#{self.number}".center(4)
  end
end

class Pawn < Piece
  def start_file number; number; end
  def abbrev; "P"; end

  def legal_move? rank, file
    raise PawnBackwardsMove if rank < self.rank
    raise PawnSidewaysMove if file != self.file && !self.capture(rank, file)
    raise PawnOverstepAfterFirstMove if @has_moved && rank - self.rank > 1
    raise PawnOverstepFirstMove if rank - self.rank > 2
    super rank, file
    raise PawnBlocked if self.board[rank][file] && !self.capture(rank, file)
  end

  def capture rank, file
    (file - self.file).abs == 1 && rank - self.rank == 1 &&
    self.board[rank][file] && self.board[rank][file].player != self.player
  end
end

class Rook < Piece
  def start_file number; 0 + (7 * number); end
  def abbrev; "R"; end

  def legal_move? rank, file
    super rank, file
  end
end

class Knight < Piece
  def start_file number; 1 + (5 * number); end
  def abbrev; "N"; end

  def legal_move? rank, file
    raise KnightIllegalMove unless begin
      ((file - self.file).abs == 1 && (rank - self.rank).abs == 2) ||
      ((file - self.file).abs == 2 && (rank - self.rank).abs == 1)
    end
    super rank, file
  end
end

class Bishop < Piece
  def start_file number; 2 + (3 * number); end
  def abbrev; "B"; end

  def legal_move? rank, file
    raise BishopIllegalMove unless ((file - self.file).abs == (rank - self.rank).abs)
    super rank, file
  end
end

class Queen < Piece
  def start_file number; 3; end
  def abbrev; "Q"; end

  def legal_move? rank, file
    raise QueenIllegalMove unless begin
      ((rank - self.rank).abs == (file - self.file).abs) ||
      (file == self.file) || (rank == self.rank)
    end
    super rank, file
  end
end

class King < Piece
  def start_file number; 4; end
  def abbrev; "K"; end

  def legal_move? rank, file
    raise KingIllegalMove unless begin
      ((file - self.file).abs == 1 && (rank - self.rank).abs == 1) ||
      ((rank - self.rank).abs == 1 && file == self.file) ||
      ((file - self.file).abs == 1 && rank == self.rank)
    end
    super rank, file
  end

  def castle rook_number
    rook = self.player.rooks[rook_number]
    raise KingCastleError::PieceInWay if self.board.piece_in_way? self, 0, rook.file
  end
end
