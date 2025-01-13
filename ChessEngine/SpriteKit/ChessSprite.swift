//Created by Lugalu on 13/01/25.

import SpriteKit

enum chessTurn: String {
    case black
    case white
}

class ChessSprite: SKSpriteNode {
    private(set) var piece: ChessPiece?
    private(set) var chessColor: chessTurn
    
    init(piece: ChessPiece?, chessColor: chessTurn) {
        let textureName: String = piece?.name ?? "empty" + "_" + chessColor.rawValue
        let texture = textureName.contains("empty") ? nil : SKTexture(imageNamed: textureName)
        self.piece = piece
        self.chessColor = chessColor
        super.init(texture: texture, color: .clear, size: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
