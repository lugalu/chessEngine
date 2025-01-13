//Created by Lugalu on 22/12/24.

import Foundation

class ChessPiece {
    var name: String { "Empty" }
    private(set) var hadFirstMove: Bool = false
    var moveDistance: Int { 64 }
    var moves: [MoveDirections] { [] }
    var attackDirections: [MoveDirections] { moves }

    
    init(){}
    
    func onMove() {
        hadFirstMove = true
    }
    
}

