class IllegalPieceMove < StandardError
end

class NonMove < IllegalPieceMove
  def message; "Piece must change position"; end
end

class PawnSidewaysMove < IllegalPieceMove
  def message; "Pawn can only move forward"; end
end

class PawnBackwardsMove < IllegalPieceMove
  def message; "Pawn can only move forward"; end
end

class PawnOverstepAfterFirstMove < IllegalPieceMove
  def message; "Pawn can only move one step forward after first move"; end
end

class PawnOverstepFirstMove < IllegalPieceMove
  def message; "Pawn can only move one or two steps forward on the first move"; end
end

class PawnBlocked < IllegalPieceMove
  def message; "Pawn cannot attack piece ahead of it"; end
end

class KnightIllegalMove < IllegalPieceMove
  def message; "Knight can only move by one file and two ranks or two files and one rank"; end
end

class BishopIllegalMove < IllegalPieceMove
  def message; "Bishop can only move diagonally"; end
end

class QueenIllegalMove < IllegalPieceMove
  def message; "Queen can only move diagonally, vertically or horizontally"; end
end

class KingIllegalMove < IllegalPieceMove
  def message; "King can only move one square straight or diagonally"; end
end

class KingCastleError < IllegalPieceMove
  class PieceInWay < KingCastleError
    def message; "Cannot castle when piece between king and rook"; end
  end
end
