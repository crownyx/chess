module MoveTypes
  class << self
    def all_diagonal piece, limit: 7
      (1..limit).flat_map do |n|
        [[piece.rank + n, piece.file + n], [piece.rank - n, piece.file - n],
         [piece.rank - n, piece.file + n], [piece.rank + n, piece.file - n]]
      end.select do |rank, file|
        file >= 0 && file < 8 && rank >= 0 && rank < 8
      end
    end

    def all_straight piece, limit: 7
      [*[*((piece.file - limit)...piece.file).to_a, *((piece.file + 1)..(piece.file + limit)).to_a].map { |file| [piece.rank, file] },
       *[*((piece.rank + 1)..(piece.rank + limit)).to_a, *((piece.rank - limit)...piece.rank).to_a].map { |rank| [rank, piece.file] }].select do |rank, file|
        file >= 0 && file < 8 && rank >= 0 && rank < 8
      end
    end

    def diagonal? piece, rank, file, limit: 7
      rank_diff, file_diff = (rank - piece.rank).abs, (file - piece.file).abs

      rank < 8 && file < 8 &&
      rank != piece.rank && file != piece.file &&
      rank_diff == file_diff &&
      rank_diff <= limit && file_diff <= limit
    end

    def straight? piece, rank, file, limit: 7
      rank_diff, file_diff = (rank - piece.rank).abs, (file - piece.file).abs

      rank < 8 && file < 8 &&
      (rank == piece.rank && file != piece.file && file_diff <= limit) ||
      (rank != piece.rank && file == piece.file && rank_diff <= limit)
    end
  end
end
