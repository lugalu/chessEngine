//Created by Lugalu on 23/12/24.

import Foundation

class Pawn: ChessPiece {
    override var name: String { "Pawn" }
    override var moveDistance: Int { self.hadFirstMove ? 1 : 2 }
    override var moves: [MoveDirections] { [.up] }
    override var attackDirections: [MoveDirections] { [.diagonalUpRight,
                                                       .diagonalUpLeft] }
}

class Rook: ChessPiece {
    override var name: String { "Rook" }
    override var moves: [MoveDirections] { [.up,
                                            .down,
                                            .left,
                                            .right] }
}

class Bishop: ChessPiece {
    override var name: String { "Bishop" }
    override var moves: [MoveDirections] { [.diagonalUpLeft,
                                            .diagonalUpRight,
                                            .diagonalDownLeft,
                                            .diagonalDownRight] }
}

class Queen: ChessPiece {
    override var name: String { "Queen" }
    override var moves: [MoveDirections] { [.up,
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
    override var moves: [MoveDirections] { [.up,
                                            .down,
                                            .left,
                                            .right,
                                            .diagonalUpLeft,
                                            .diagonalUpRight,
                                            .diagonalDownLeft,
                                            .diagonalDownRight] }
}

class Knight: ChessPiece {
    override var name: String { "Knight" }
    override var moveDistance: Int { 1 }
    override var moves: [MoveDirections] { [.knightUpRightOne,
                                            .knightUpRightTwo,
                                            .knightUpLeftOne,
                                            .knightUpLeftTwo,
                                            .knightDownRightOne,
                                            .knightDownRightTwo,
                                            .knightDownLeftOne,
                                            .knightDownLeftTwo] }
}
