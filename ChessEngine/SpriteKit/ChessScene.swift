//Created by Lugalu on 05/01/25.

import SpriteKit

protocol ChessSceneInterface: SKScene {
    func updateSize(_ size: CGSize)
    func configure(whitePlayerName: String, blackPlayerName: String)
}
protocol ChessCommunication {
    
}
class ChessScene: SKScene, ChessSceneInterface, ChessCommunication  {
    
    
    let leftMenu: SKSpriteNode =  {
        let node = SKSpriteNode(color: .red,
                                size: CGSize(width: 250, height: 0)
        )
        node.anchorPoint = CGPoint(x: 0, y: 0)
        
        return node
    }()
    
    lazy var chessBoard: ChessBoard = ChessBoard(delegate: self)

    
    override init() {
        super.init(size: .zero)
        addChild(leftMenu)
        addChild(chessBoard)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addChild(leftMenu)
        addChild(chessBoard)
    }
    
    func configure(whitePlayerName: String = "White", blackPlayerName: String = "Black") {
        guard let size = Constants.adjustedScreenSize else {
            fatalError("NScreen not available")
        }
        updateSize(size)
    }
    
    func updateSize(_ size: CGSize) {
        self.size = size
        leftMenu.size.height = size.height
        
        let squareSize = ResizeMath.getSquare(from: size)
        chessBoard.size = squareSize
        
        moveChessTableNode(squareSize, size)
        chessBoard.updateGrid()
    }
    
    func moveChessTableNode(_ squareSize: CGSize, _ size: CGSize) {
        chessBoard.position = ResizeMath
            .getCenteredPositionForSquare(
                square: squareSize,
                screenSize: size,
                widthOffset: leftMenu.size.width
            )
    }
}
