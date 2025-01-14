//Created by Lugalu on 22/12/24.

import SpriteKit

enum ChessColor: String {
    case black
    case white
}


class ChessPiece {
    var name: String { "Empty" }
    private(set) var hadFirstMove: Bool = false
    var moveDistance: Int { 64 }
    var moves: [MoveDirections] { [] }
    var attackDirections: [MoveDirections] { moves }
    var color: ChessColor
    var piece: SKSpriteNode
    
    init(color: ChessColor){
        self.color = color
        piece = SKSpriteNode()
        piece = ChessSprite(pieceName: self.name, chessColor: self.color)
    }
    
    func onMove() {
        hadFirstMove = true
    }
    
}

