require '../solea/solea'
require './game'

game = Game.new

# initial setup:

Solea.example { game.board.length }
Solea.expect  { 8 }
Solea.example { game.board.map &:length }
Solea.expect  { [8, 8, 8, 8, 8, 8, 8, 8] }
Solea.example { game.white.pieces.count }
Solea.expect  { 16 }
Solea.example { game.black.pieces.count }
Solea.expect  { 16 }
Solea.example { game.white.pawns.count }
Solea.expect  { 8 }
Solea.example { game.black.pawns.count }
Solea.expect  { 8 }
Solea.example { game.white.rooks.count }
Solea.expect  { 2 }
Solea.example { game.black.rooks.count }
Solea.expect  { 2 }
Solea.example { game.white.knights.count }
Solea.expect  { 2 }
Solea.example { game.black.knights.count }
Solea.expect  { 2 }
Solea.example { game.white.bishops.count }
Solea.expect  { 2 }
Solea.example { game.black.bishops.count }
Solea.expect  { 2 }
Solea.assert  { game.white.queen }
Solea.assert  { game.black.queen }
Solea.assert  { game.white.king }
Solea.assert  { game.black.king }
Solea.example { game.whose_turn }
Solea.expect  { game.white }

# white pawn's first move:

Solea.attempt(true)  { game.white.pawns[4].legal_move? 2, 4 }
Solea.attempt(true)  { game.white.pawns[4].legal_move? 3, 4 }
Solea.attempt(false) { game.white.pawns[4].legal_move? 1, 4 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { NonMove }
Solea.attempt(false) { game.white.pawns[4].legal_move? 4, 4 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnOverstepFirstMove }
Solea.attempt(false) { game.white.pawns[4].legal_move? 2, 5 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnSidewaysMove }
Solea.attempt(true)  { game.move game.whose_turn.pawns[4], 3, 4 }

# after white pawn move:

Solea.example { game.white.pawns[4].file }
Solea.expect  { 4 }
Solea.example { game.white.pawns[4].rank }
Solea.expect  { 3 }
Solea.example { game.whose_turn }
Solea.expect  { game.black }

# move black pawn:

Solea.attempt(true) { game.move game.whose_turn.pawns[4], 3, 4 }
Solea.example { game.black.pawns[4].file }
Solea.expect  { 4 }
Solea.example { game.black.pawns[4].rank }
Solea.expect  { 3 }
Solea.example { game.whose_turn }
Solea.expect  { game.white }

# white pawn's legal moves after first move:

Solea.attempt(false) { game.white.pawns[4].legal_move? 4, 4 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnBlocked }
Solea.attempt(false) { game.white.pawns[4].legal_move? 2, 4 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnBackwardsMove }
Solea.attempt(false) { game.white.pawns[4].legal_move? 2, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnBackwardsMove }
Solea.attempt(false) { game.white.pawns[4].legal_move? 3, 2 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnSidewaysMove }

# white king's legal moves:

Solea.attempt(true)  { game.white.king.legal_move? 1, 4 }
Solea.attempt(false) { game.white.king.legal_move? 0, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }
Solea.attempt(false) { game.white.king.legal_move? 2, 4 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { KingIllegalMove }
Solea.attempt(false) { game.white.king.castle 0 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { KingCastleError::PieceInWay }

# white queen's legal moves:

Solea.attempt(true)  { game.white.queen.legal_move? 4, 7 }
Solea.attempt(false) { game.white.queen.legal_move? 3, 7 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { QueenIllegalMove }
Solea.attempt(false) { game.white.queen.legal_move? 1, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }
Solea.attempt(false) { game.white.queen.legal_move? 2, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PieceInWay }

# white knight 0 legal moves:

Solea.attempt(true)  { game.white.knights[0].legal_move? 2, 2 }
Solea.attempt(true)  { game.white.knights[0].legal_move? 2, 0 }
Solea.attempt(false) { game.white.knights[0].legal_move? 1, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }
Solea.attempt(false) { game.white.knights[0].legal_move? 2, 1 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { KnightIllegalMove }
Solea.attempt(true)  { game.move game.whose_turn.knights[0], 2, 2 }

# white knight 1 legal moves:

Solea.attempt(true)  { game.white.knights[1].legal_move? 1, 4 }
Solea.attempt(true)  { game.white.knights[1].legal_move? 2, 5 }
Solea.attempt(true)  { game.white.knights[1].legal_move? 2, 7 }
Solea.attempt(false) { game.white.knights[1].legal_move? 1, 8 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { OffBoard }

# black rook 0 legal moves:

Solea.attempt(false) { game.black.rooks[0].legal_move? 2, 0 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PieceInWay }
Solea.attempt(false) { game.black.rooks[0].legal_move? 1, 0 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }

# move black quuen:

Solea.attempt(true) { game.move game.black.queen, 4, 7 }

# move white pawn 6:

Solea.attempt(true) { game.move game.white.pawns[6], 2, 6 }

# black queen takes white pawn 6:

Solea.attempt(true) { game.move game.black.queen, 5, 6 }
Solea.example { game.white.pawns.count }
Solea.expect  { 8 }
Solea.example { game.white.pawns.compact.count }
Solea.expect  { 7 }

# white pawn 5 takes black queen:

Solea.attempt(true) { game.move game.white.pawns[5], 2, 6 }
Solea.assert!       { game.black.queen }

# move black pawn 1:

Solea.attempt(true) { game.move game.black.pawns[1], 3, 1 }

# move white knight 1:

Solea.attempt(true) { game.move game.white.knights[1], 2, 5 }

# black pawn 1 legal moves:

Solea.attempt(false) { game.black.pawns[1].legal_move? 5, 1 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnOverstepAfterFirstMove }
Solea.attempt(false) { game.black.pawns[1].legal_move? 4, 0 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { PawnSidewaysMove }
Solea.attempt(true)  { game.black.pawns[1].legal_move? 4, 1 }

# black king legal moves:

Solea.attempt(true)  { game.black.king.legal_move? 0, 3 }
Solea.attempt(true)  { game.black.king.legal_move? 1, 4 }
Solea.attempt(false) { game.black.king.legal_move? 1, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }

# black bishop 0 legal moves:

Solea.attempt(false) { game.black.bishops[0].legal_move? 0, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { BishopIllegalMove }
Solea.attempt(true)  { game.move game.black.bishops[0], 2, 0 }

# white knight 1 legal moves:

Solea.attempt(true)  { game.white.knights[1].legal_move? 0, 6 }
Solea.attempt(true)  { game.white.knights[1].legal_move? 3, 7 }
Solea.attempt(true)  { game.white.knights[1].legal_move? 4, 6 }
Solea.attempt(false) { game.white.knights[1].legal_move? 1, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }
Solea.attempt(false) { game.white.knights[1].legal_move? 0, 4 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }
Solea.attempt(false) { game.white.knights[1].legal_move? 3, 4 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { KnightIllegalMove }

# white knight 1 takes black pawn 1:

Solea.attempt(true) { game.move game.white.knights[1], 4, 4 }
Solea.example       { game.black.pawns.count }
Solea.expect        { 8 }
Solea.example       { game.black.pawns.compact.count }
Solea.expect        { 7 }

# black knight 0 legal moves:

Solea.attempt(false) { game.black.knights[0].legal_move? 2, 0 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }
Solea.attempt(false) { game.black.knights[0].legal_move? 1, 3 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { FriendlyOnSquare }
Solea.attempt(true)  { game.move game.black.knights[0], 2, 2 }

# white bishop 1 legal moves:

Solea.attempt(false) { game.white.bishops[1].legal_move? 1, 5 }
Solea.example        { Solea.last_exception.class }
Solea.expect         { BishopIllegalMove }
Solea.attempt(true)  { game.white.bishops[1].legal_move? 1, 6 }
Solea.attempt(true)  { game.move game.white.bishops[1], 1, 4 }

# castle white king queenside:

Solea.attempt(true)  { game.black.king.castle 0 }

puts game.board.to_s

Solea.run_tests
Solea.basic_report
