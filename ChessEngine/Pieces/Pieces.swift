//Created by Lugalu on 23/12/24.

import Foundation

class Pawn: ChessPiece {
    override var name: String { "Pawn" }
    override var moveDistance: Int { self.hadFirstMove ? 1 : 2 }
    override var attackDistance: Int { 1 }
    override var moveDirections: [MoveDirections] {
        self.color == .white ? [.up] : [.down]
    }
    
    override var attackDirections: [MoveDirections] {
        self.color == .white ? [.diagonalUpRight, .diagonalUpLeft] :
                               [.diagonalDownRight,.diagonalDownLeft]
    }
    
    override func onMove(newPosition pos: BoardCoords, delegate: any ChessSceneInterface) {
        if !hadFirstMove && abs(pos.y - self.position.y) > 1 {
            let y = pos.y - (color == .white ? -1 : 1)
            let ghost = Ghost(color: color, pawn: self, position: (pos.x, y))
            delegate.addGhost(ghost: ghost)
        }
        super.onMove(newPosition: pos, delegate: delegate)
    }
}

class Rook: ChessPiece {
    override var name: String { "Rook" }
    override var moveDirections: [MoveDirections] { [.up,
                                            .down,
                                            .left,
                                            .right] }
}

class Bishop: ChessPiece {
    override var name: String { "Bishop" }
    override var moveDirections: [MoveDirections] { [.diagonalUpLeft,
                                            .diagonalUpRight,
                                            .diagonalDownLeft,
                                            .diagonalDownRight] }
}

class Queen: ChessPiece {
    override var name: String { "Queen" }
    override var moveDirections: [MoveDirections] { [.up,
                                            .down,
                                            .left,
                                            .right,
                                            .diagonalUpLeft,
                                            .diagonalUpRight,
                                            .diagonalDownLeft,
                                            .diagonalDownRight] }
}

class King: ChessPiece {
    override var name: String { "King" }
    override var moveDistance: Int { 1 }

    override var moveDirections: [MoveDirections] { [.up,
                                            .down,
                                            .left,
                                            .right,
                                            .diagonalUpLeft,
                                            .diagonalUpRight,
                                            .diagonalDownLeft,
                                            .diagonalDownRight] }
    
    override var attackDistance: Int { 0 }
    override var attackDirections: [MoveDirections] { [] }
}

class Knight: ChessPiece {
    override var name: String { "Knight" }
    override var moveDistance: Int { 1 }
    override var moveDirections: [MoveDirections] { [.knightUpRightOne,
                                            .knightUpRightTwo,
                                            .knightUpLeftOne,
                                            .knightUpLeftTwo,
                                            .knightDownRightOne,
                                            .knightDownRightTwo,
                                            .knightDownLeftOne,
                                            .knightDownLeftTwo] }
}

class Ghost: Pawn {
    override var attackDirections: [MoveDirections] { [] }
    override var moveDistance: Int { 0 }
    override var moveDirections: [MoveDirections] { [] }
    override var attackDistance: Int { 0 }
    
    var reference: Pawn
    
    init(color: ChessColor, pawn: Pawn, position: BoardCoords) {
        self.reference = pawn
        super.init(color: color)
        self.position = position
        self.piece.alpha = 0.5
    }
}
