//Created by Lugalu on 22/12/24.

import Foundation

class ChessPiece {
    private(set) var hadFirstMove: Bool = false
    var moveDistance: Int { 1 }
    
    init(){}
    
    func onMove() {
        hadFirstMove = true
    }
    
}

class Pawn: ChessPiece {
    override var moveDistance: Int { self.hadFirstMove ? 1 : 2 }
    
    override init() {
        super.init()
    }
    
}
