//Created by Lugalu on 22/12/24.

import Foundation

class ChessPiece {
    private(set) var hadFirstMove: Bool = false
    var moveDistance: Int { 1 }
    var moves: [MoveDirections] { MoveDirections.allCases }
    var attackDirections: [MoveDirections] { moves }
    
    init(){}
    
    func onMove() {
        hadFirstMove = true
    }
    
}

class Queen: ChessPiece {
    override var moveDistance: Int { 64 }
}
