//Created by Lugalu on 13/01/25.

import SpriteKit

class ChessSprite: SKSpriteNode {
    private(set) var chessColor: ChessColor
    private(set) var piece: ChessPiece?
    
    init(pieceName: String, chessColor: ChessColor, piece: ChessPiece?) {
        let textureName: String = pieceName + "_" + chessColor.rawValue
        let texture = SKTexture(imageNamed: textureName)
        self.chessColor = chessColor
        self.piece = piece
        super.init(texture: texture, color: .clear, size: .zero)
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
