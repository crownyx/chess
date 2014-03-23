require '../extensions/extensions'
require './illegal_board_move'

class Board < Array
  def initialize game
    super 8.map { 8.map { nil } }
    @game = game
    @game.white.pieces.each { |piece| self[piece.rank][piece.file] = piece }
    @game.black.pieces.each { |piece| self[7 - piece.rank][piece.file] = piece }
  end

  def move piece, rank, file
    self[piece.rank][piece.file] = nil
    self[rank][file].player.pieces.delete(self[rank][file]) if self[rank][file]
    self[rank][file] = piece
    self.reverse!
  end

  def legal_move? piece, rank, file
    raise OffBoard if rank < 0 || rank > 7 || file < 0 || file > 7
    raise PieceInWay if self.piece_in_way?(piece, rank, file) && !piece.is_a?(Knight)
    raise FriendlyOnSquare if self.friendly_on_square? piece, rank, file
  end

  def piece_in_way? piece, rank, file
    if (rank - piece.rank).abs == (file - piece.file).abs
      ranks = [piece.rank + 1, rank + 1].min...[piece.rank, rank].max
      files = [piece.file + 1, file + 1].min...[piece.file, file].max
      ranks.zip(files).find do |rank_between, file_between|
        self[rank_between][file_between]
      end
    elsif rank != piece.rank
      ([piece.rank + 1, rank + 1].min...[piece.rank, rank].max).find do |rank_between|
        self[rank_between][file]
      end
    else
      ([piece.file + 1, file + 1].min...[piece.file, file].max).find do |file_between|
        self[rank][file_between]
      end
    end
  end

  def friendly_on_square? piece, rank, file
    self[rank][file] && self[rank][file].player == piece.player
  end

  def to_s with_fill: false
    joined_ranks = self.map.with_index do |rank, rank_index|
      back_fill = with_fill ? ["\e[47m", "\e[0m"] : ["", ""]
      if rank_index.odd?
        rank.map.with_index do |square, square_index|
          if square_index.odd?
            back_fill.join square.to_s.center 4
          else
            square.to_s.center 4
          end
        end.inclujoin("|")
      else
        rank.map.with_index do |square, square_index|
          if square_index.even?
            back_fill.join square.to_s.center 4
          else
            square.to_s.center 4
          end
        end.inclujoin("|")
      end
    end
    numed_rows = 8.to_a.zip(joined_ranks).map{ |rank| rank.join(" ") }
    bordered   = numed_rows.incluzip(8.map { "  " + 8.map { "----" }.inclujoin("+") }).flatten
    bordered.reverse.unshift("  " + 8.map { |n| n.to_s.center 4 }.inclujoin(" ")).join("\n")
  end
end
