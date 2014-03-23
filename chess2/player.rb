require "./pieces"

class Player
  attr_reader :pieces, :color, :color_code

  def initialize color
    @color  = color
    @color_code = @color == "White" ? ["\e[1;37m", "\e[0m"] : ["", ""]
    @pieces   = [*(0..7).map { |n| Pawn.new   self, n },
                 *(0..1).map { |n| Rook.new   self, n },
                 *(0..1).map { |n| Knight.new self, n },
                 *(0..1).map { |n| Bishop.new self, n },
                  Queen.new(self),
                  King.new(self)]
  end

  def pawns
    (0..7).map do |n|
      @pieces.find do |piece|
        piece.is_a?(Pawn) && piece.number == n
      end
    end
  end

  [:rooks, :knights, :bishops].each do |symbol|
    define_method symbol do
      (0..1).map do |n|
        @pieces.find do |piece|
          piece.is_a?(Kernel.const_get(symbol[0..-2].capitalize)) && piece.number == n
        end
      end
    end
  end

  [:king, :queen].each do |symbol|
    define_method symbol do
      @pieces.find do |piece|
        piece.class.to_s.downcase == symbol.to_s
      end
    end
  end
end
