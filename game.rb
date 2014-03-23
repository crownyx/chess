require './board'
require './player'

class Game
  attr_reader :board, :white, :black, :whose_turn

  def initialize
    @white = Player.new "White", self
    @black = Player.new "Black", self
    @board = Board.new self
    @whose_turn = @white
  end

  def move piece, rank, file
    piece.legal_move? rank, file
    self.board.move piece, rank, file
    piece.move rank, file
    @whose_turn = @whose_turn == self.white ? self.black : self.white
  end

  def self.begin
    self.new.get_move
  end

  def get_move
    puts self.board.to_s
    print "[piece] [rank][file]: "
    piece, move_to = gets.chomp.split(" ")
    rank, file = move_to.split("")
    abbrev, number = piece.split("")
    piece = @whose_turn.pieces.find do |piece|
      piece.abbrev == abbrev.upcase &&
      (piece.number == number.to_i || (!number && !piece.number))
    end
    self.move piece, rank.to_i, file.to_i
    self.get_move
  end
end

if $0 == __FILE__
  Game.begin
end
