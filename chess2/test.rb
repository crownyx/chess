require "../solea/solea"
require "./player"
require "./board"

white, black = Player.new("White"), Player.new("Black")
board = Board.new(white, black)

[*white.pawns, *black.pawns].each do |pawn|
  Solea.example { pawn.can_move board }
  Solea.expect  { [[pawn.rank + 1, pawn.file], [pawn.rank + 2, pawn.file]] }
end
[*white.knights, *black.knights].each do |knight|
  Solea.example { knight.can_move board }
  Solea.expect  { [[knight.rank + 2, knight.file + 1], [knight.rank + 2, knight.file - 1]] }
end
[*white.rooks, *white.bishops, white.queen, white.king, *black.rooks, *black.bishops, black.queen, black.king].each do |piece|
  Solea.example { piece.can_move board }
  Solea.expect  { [] }
end
Solea.example { [*white.pieces, *black.pieces].flat_map { |p| p ? p.attacking(board) : []} }
Solea.expect  { [] }

white.pawns[0].move_to 3, 0, board
board = Board.new(black, white)

Solea.example { white.pawns[0].can_move board }
Solea.expect  { [[4, 0]] }
Solea.example { white.rooks[0].can_move board }
Solea.expect  { [[1, 0], [2, 0]] }
Solea.example { [*white.pieces, *black.pieces].flat_map { |p| p ? p.attacking(board) : []} }
Solea.expect  { [] }

black.pawns[2].move_to 2, 2, board
board = Board.new(white, black)

Solea.example { black.pawns[2].can_move board }
Solea.expect  { [[3, 2]] }
Solea.example { black.knights[0].can_move board }
Solea.expect  { [[2, 0]] }
Solea.example { black.knights[1].can_move board }
Solea.expect  { [[2, 7], [2, 5]] }
Solea.example { black.queen.can_move board }
Solea.expect  { [[1, 2], [2, 1], [3, 0]] }
Solea.example { black.bishops[0].can_move board }
Solea.expect  { [] }
Solea.example { [*white.pieces, *black.pieces].flat_map { |p| p ? p.attacking(board) : []} }
Solea.expect  { [] }

white.pawns[3].move_to 3, 3, board
board = Board.new(black, white)

Solea.example { white.pawns[3].can_move board }
Solea.expect  { [[4, 3]] }
Solea.example { white.bishops[0].can_move board }
Solea.expect  { [[1, 3], [2, 4], [3, 5], [4, 6], [5, 7]] }
Solea.example { white.queen.can_move board }
Solea.expect  { [[1, 3], [2, 3]] }
Solea.example { white.knights[0].can_move(board).sort }
Solea.expect  { [[1, 3], [2, 0], [2, 2]] }
Solea.example { [*white.pieces, *black.pieces].flat_map { |p| p ? p.attacking(board) : []} }
Solea.expect  { [] }

black.pawns[2].move_to 3, 2, board
board = Board.new(white, black)

Solea.example { black.pawns[2].attacking board }
Solea.expect  { [[4, 3]] }
Solea.example { black.pawns[2].can_move board }
Solea.expect  { [[4, 2]] }
Solea.example { white.pawns[3].attacking board }
Solea.expect  { [[4, 2]] }
Solea.example { white.pawns[3].can_move board }
Solea.expect  { [[4, 3]] }
Solea.example { [*white.pieces, *black.pieces].flat_map { |p| p ? p.attacking(board) : []} }
Solea.expect  { [[4, 2], [4, 3]] }

white.pawns[3].move_to 4, 2, board
board = Board.new(black, white)

Solea.example { black.pawns.count }
Solea.expect  { 8 }
Solea.example { black.pawns.compact.count }
Solea.expect  { 7 }
Solea.example { white.queen.can_move board }
Solea.expect  { (1..6).map { |n| [n, 3] } }
Solea.example { white.queen.attacking board }
Solea.expect  { [[6, 3]] }
Solea.example { white.king.can_move board }
Solea.expect  { [[1, 3]] }
Solea.example { [*white.pieces, *black.pieces].flat_map { |p| p ? p.attacking(board) : [] } }
Solea.expect  { [[6, 3]] }

black.queen.move_to 3, 0, board
board = Board.new(white, black)

Solea.example { black.queen.can_move(board).count }
Solea.expect  { 11 }
Solea.example { black.queen.attacking(board).sort }
Solea.expect  { [[3, 2], [4, 0], [7, 4]] }

white.pawns[2].move_to 2, 2, board
board = Board.new black, white

Solea.example { black.queen.can_move(board).sort }
Solea.expect  { [[0, 3], [1, 2], [2, 0], [2, 1], [3, 1], [3, 2], [4, 0], [4, 1], [5, 2]] }
Solea.example { black.queen.attacking(board).sort }
Solea.expect  { [[3, 2], [4, 0], [5, 2]] }
Solea.example { white.pieces.flat_map { |p| p ? p.attacking(board) : [] } }
Solea.expect  { white.queen.attacking(board) }
Solea.example { black.pieces.flat_map { |p| p ? p.attacking(board) : [] } }
Solea.expect  { black.queen.attacking(board) }

black.knights[0].move_to 2, 2, board
board = Board.new white, black

Solea.example { black.knights[0].can_move(board).sort }
Solea.expect  { [[0, 1], [0, 3], [3, 4], [4, 1], [4, 3]] }

white.rooks[0].move_to 2, 0, board
board = Board.new black, white

Solea.example { white.rooks[0].can_move(board).sort }
Solea.expect  { [[0, 0], [1, 0], [2, 1]] }
Solea.example { white.knights[0].can_move(board) }
Solea.expect  { [[1, 3]] }

black.queen.move_to 5, 2, board
board = Board.new white, black

Solea.example { white.pawns.count }
Solea.expect  { 8 }
Solea.example { white.pawns.compact.count }
Solea.expect  { 7 }
Solea.example { black.queen.can_move(board).count }
Solea.expect  { 19 }
Solea.example { black.queen.attacking(board).count }
Solea.expect  { 5 }
Solea.example { black.knights[0].can_move(board).count }
Solea.expect  { 6 }

white.rooks[0].move_to 2, 2, board
board = Board.new black, white

Solea.assert! { black.queen }
Solea.example { white.rooks[0].can_move(board).count }
Solea.expect  { 9 }

black.pawns[4].move_to 2, 4, board
board = Board.new white, black

Solea.example { black.pawns[4].can_move(board) }
Solea.expect  { [[3, 4]] }
Solea.example { black.bishops[1].can_move(board).sort }
Solea.expect  { [[1, 4], [2, 3], [3, 2]] }
Solea.example { black.bishops[1].attacking(board) }
Solea.expect  { [[3, 2]] }
Solea.example { black.king.can_move(board).sort }
Solea.expect  { [[0, 3], [1, 4]] }

white.pawns[6].move_to 2, 6, board
board = Board.new black, white

black.pawns[3].move_to 2, 3, board
board = Board.new white, black

Solea.example { black.king.can_move(board).sort }
Solea.expect  { [[0, 3], [1, 3], [1, 4]] }

white.bishops[1].move_to 2, 7, board
board = Board.new black, white

Solea.example { white.bishops[1].can_move(board).sort }
Solea.expect  { [[0, 5], [1, 6], [3, 6], [4, 5], [5, 4]] }
Solea.example { white.bishops[1].attacking(board) }
Solea.expect  { [[5, 4]] }
Solea.example { white.knights[1].can_move(board) }
Solea.expect  { [[2, 5]] }

black.pawns[3].move_to 3, 2, board
board = Board.new white, black

Solea.example { white.pawns.compact.count }
Solea.expect  { 6 }
Solea.example { white.rooks[0].can_move(board).count }
Solea.expect  { 8 }
Solea.example { white.rooks[0].attacking(board) }
Solea.expect  { [[4, 2]] }
Solea.attempt(false) { white.king.castle board, rook: 1 }

white.knights[1].move_to 2, 5, board
board = Board.new black, white

Solea.example { white.knights[1].can_move(board).count }
Solea.expect  { 6 }
Solea.attempt(true) { white.king.castle board, rook: 1 }

board = Board.new white, black

puts board.to_s

Solea.run_tests
Solea.basic_report
