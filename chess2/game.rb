require "./board"
require "./player"

module Game
  class << self
    attr_accessor :computer_player, :human_player, :board
    def begin
      @players = (@white_player, @black_player = [Player.new("White"), Player.new("Black")])

      self.next_turn
    end

    def next_turn
      puts Board.new(*@players).to_s
      self.get_piece_and_move
    end

    def get_piece_and_move
      print "Move [piece] to [rank][file]: "

      piece, move_to = gets.chomp.split(" ")
      piece          = @players[0].pieces.find do |p|
                         p.abbrev == piece[0].upcase &&
                         p.number == piece[1].to_i
                       end

      if piece.move_to *move_to.split('').map(&:to_i), @board
        @players.reverse!
        self.next_turn
      else
        puts "Illegal move. Try again."
        self.get_piece_and_move
      end
    end
  end
end

Game.begin
