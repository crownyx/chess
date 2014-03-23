require './piece'

class Player
  attr_reader :color_code, :pieces, :game

  def initialize color, game
    @color_code = color == "White" ? ["\e[1;37m", "\e[0m"] : ["", ""]
    @pieces   = [*(0..7).map { |n| Pawn.new   self, n },
                 *(0..1).map { |n| Rook.new   self, n },
                 *(0..1).map { |n| Knight.new self, n },
                 *(0..1).map { |n| Bishop.new self, n },
                  Queen.new(self),
                  King.new(self)]
    @game = game
  end

  def pawns
    8.map do |n|
      self.pieces.find do |piece|
        piece.is_a?(Pawn) && piece.number == n
      end
    end
  end

  [:rooks, :knights, :bishops].each do |symbol|
    piece_class = Object.const_get symbol[0...-1].capitalize
    define_method symbol do
      2.map do |n|
        self.pieces.find do |piece|
          piece.is_a?(piece_class) && piece.number == n
        end
      end
    end
  end

  [:queen, :king].each do |symbol|
    piece_class = Object.const_get symbol.capitalize
    define_method symbol do
      self.pieces.find do |piece|
        piece.is_a? piece_class
      end
    end
  end
end
