class IllegalBoardMove < StandardError
end

class OffBoard < IllegalBoardMove
  def message; "Move exceeds board"; end
end

class FriendlyOnSquare < IllegalBoardMove
  def message; "Piece cannot be moved to a square occupied by a friendly piece"; end
end

class PieceInWay < IllegalBoardMove
  def message; "Piece cannot move over other piece"; end
end
