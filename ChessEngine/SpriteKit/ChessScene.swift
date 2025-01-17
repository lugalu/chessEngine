//Created by Lugalu on 05/01/25.

import SpriteKit

protocol ChessSceneInterface: SKScene {
    func updateSize(_ size: CGSize)
    func configure(whitePlayerName: String, blackPlayerName: String)
}

class ChessScene: SKScene, ChessSceneInterface  {
    
    private let leftMenu: SKSpriteNode =  {
        let node = SKSpriteNode(color: .red,
                                size: CGSize(width: 250, height: 0)
        )
        node.anchorPoint = CGPoint(x: 0, y: 0)
        
        return node
    }()
    
    private let chessBaseNode: SKSpriteNode = {
        let node = SKSpriteNode(color: .clear, size: .zero)
        node.anchorPoint = CGPoint(x: 0, y: 0)
        return node
    }()
    
    private let nodeGrid: [[SKSpriteNode]] = NodeFactory.makeMatrix()
    private let chessMatrix: [[ChessPiece?]] = PieceFactory.makeMatrix()
    
    
    
    override init() {
        super.init(size: .zero)
        addChild(leftMenu)
        addChild(chessBaseNode)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addChild(leftMenu)
        addChild(chessBaseNode)
    }
    
    func configure(whitePlayerName: String = "White", blackPlayerName: String = "Black") {
        guard let size = Constants.adjustedScreenSize else {
            fatalError("NScreen not available")
        }
        
        chessBaseNode.position = CGPoint(x: leftMenu.size.width, y: 0)
        if nodeGrid.first!.first!.parent == nil {
            nodeGrid.forEach { row in
                row.forEach { column in
                    chessBaseNode.addChild(column)
                }
            }
            
        }
        
        chessMatrix.forEach { row in
            for item in row {
                guard let item, item.piece.parent == nil else { continue }
                chessBaseNode.addChild(item.piece)
            }
        }
        updateSize(size)
    }
    
    func updateSize(_ size: CGSize) {
        self.size = size
        leftMenu.size.height = size.height
        
        let squareSize = ResizeMath.getSquare(from: size)
        chessBaseNode.size = squareSize
        
        moveChessTableNode(squareSize, size)
        updateGrid()
        updateChessGrid()
    }
    
    override func touchesBegan(with event: NSEvent) {
        nodes(at: event.locationInWindow)
    }
    
}


//Sizing calculations
extension ChessScene {
    func moveChessTableNode(_ squareSize: CGSize, _ size: CGSize) {
        chessBaseNode.position = ResizeMath
            .getCenteredPositionForSquare(
                square: squareSize,
                screenSize: size,
                widthOffset: leftMenu.size.width
            )
    }
    
    func updateGrid() {
        let newSize = ResizeMath.divideSizeForGrid(
            squareSize: chessBaseNode.size
        )
        
        nodeGrid.enumerated().forEach { y, row in
            row.enumerated().forEach { x, item in
                item.size = newSize
                item.position.x = CGFloat(x) * item.size.width
                item.position.y = CGFloat(y) * item.size.height
            }
        }
        
        
    }
    
    func updateChessGrid() {
        let newSize = ResizeMath.divideSizeForGrid(
            squareSize: chessBaseNode.size
        )
        
        chessMatrix.enumerated().forEach { y, row in
            for (x, item) in row.enumerated() {
                guard let item else { continue }
                let yOffset = Int(Constants.chessRowsColumns) - 1 - y
                item.piece.size = newSize
                item.piece.position.x = CGFloat(x) * item.piece.size.width
                item.piece.position.y = CGFloat(yOffset) * item.piece.size.height
            }
        }
    }

}

struct NodeFactory {
    private init() {}
    
    static func makeMatrix() -> [[SKSpriteNode]] {
        var arr: [SKSpriteNode] = []
        
        for i in 1...Int(Constants.chessRowsColumns) {
            let color: NSColor = i.isMultiple(of: 2) ? .black : .white
            let node = SKSpriteNode(color: color, size: .zero)
            node.anchorPoint = CGPoint(x: 0, y: 0)
            arr.append(node)
        }
        
        var result: [[SKSpriteNode]] = []
        for i in 1...Int(Constants.chessRowsColumns) {
            var arr = arr.map { $0.copy() as! SKSpriteNode }
            arr = i.isMultiple(of: 2) ? arr : arr.reversed()
            result.append(arr)
        }
        
        return result
    }
}
