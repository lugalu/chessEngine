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
    
    private let nodeGrid: [[SKSpriteNode]] = {
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
    }()
    
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
        updateSize(size)
    }
    
    func updateSize(_ size: CGSize) {
        self.size = size
        leftMenu.size.height = size.height
        
        let squareSize = getSquare(from: size)
        chessBaseNode.size = squareSize
        
        moveChessTableNode(squareSize, size)
        updateGrid()
    }
    
    private func getSquare(from size: CGSize) -> CGSize {
        let shortest = min(size.width - leftMenu.size.width, size.height)
        return CGSize(width: shortest, height: shortest)
    }
    
    private func moveChessTableNode(_ squareSize: CGSize, _ size: CGSize) {
        var newXPos = (squareSize.width - leftMenu.size.width) / 2
        newXPos += leftMenu.size.width
        
        if newXPos + squareSize.width > size.width {
            newXPos = leftMenu.size.width
        }
        
        let newYPos = size.height - squareSize.height
        
        chessBaseNode.position.x = newXPos
        chessBaseNode.position.y = newYPos
    }
    
    private func updateGrid() {
        let newX = chessBaseNode.size.width / Constants.chessRowsColumns
        let newY = chessBaseNode.size.height / Constants.chessRowsColumns
        
        let newSize = CGSize(width: newX, height: newY)
        
        nodeGrid.enumerated().forEach { y, row in
            row.enumerated().forEach { x, item in
                item.size = newSize
                item.position.x = CGFloat(x) * item.size.width
                item.position.y = CGFloat(y) * item.size.height
            }
        }
    }
    
}
