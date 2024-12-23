//Created by Lugalu on 23/12/24.

import Foundation

class Pawn: ChessPiece {
    override var moveDistance: Int { self.hadFirstMove ? 1 : 2 }
    override var moves: [MoveDirections] { [.up] }
    override var attackDirections: [MoveDirections] { [.diagonalUpRight, .diagonalUpLeft] }
}
