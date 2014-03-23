class IllegalPieceMove < StandardError
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
