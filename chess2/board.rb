require "../extensions/extensions"

class Board < Array
  def initialize near_player, far_player
    @near_player, @far_player = near_player, far_player
    super 8.map { 8.map { nil } }
    [@near_player, @far_player].each_with_index do |player, i|
      player.pieces.each do |piece|
        if piece
          rank = i == 0 ? 7 - piece.rank : piece.rank
          self[rank][piece.file] = piece
        end
      end
    end
  end

  def piece_in_way piece, rank, file
    if MoveTypes.straight?(piece, rank, file)
      if piece.rank != rank
        ([piece.rank + 1, rank + 1].min..[piece.rank - 1, rank - 1].max).find do |y|
          y = piece.player == @near_player ? 7 - y : y
          self[y][file]
        end
      else
        rank = piece.player == @near_player ? 7 - rank : rank
        ([piece.file + 1, file + 1].min..[piece.file - 1, file - 1].max).find do |x|
          self[rank][x]
        end
      end
    else
      (rank > piece.rank ? (piece.rank + 1).upto(rank - 1) : (piece.rank - 1).downto(rank + 1).to_a).to_a.zip(
      (file > piece.file ? (piece.file + 1).upto(file - 1) : (piece.file - 1).downto(file + 1))).find do |y, x|
        y = piece.player == @near_player ? 7 - y : y
        self[y][x]
      end
    end
  end

  def friendly_on_square player, rank, file
    rank = player == @near_player ? 7 - rank : rank
    self[rank][file] && self[rank][file].player == player
  end

  def opposing_on_square player, rank, file
    rank = player == @near_player ? 7 - rank : rank
    self[rank][file] if self[rank][file] && self[rank][file].player != player
  end

  def to_s
    joined_rows = self.map do |row|
      row.map { |square| square.to_s.center 4 }.inclujoin("|")
    end
    numed_rows = 8.to_a.reverse.zip(joined_rows).map{ |r| r.join(" ") }
    bordered   = numed_rows.incluzip(8.map { "  " + 8.map { "----" }.inclujoin("+") })
    bordered.unshift("  " + 8.map { |n| n.to_s.center 4 }.inclujoin(" ")).join("\n")
  end
end
