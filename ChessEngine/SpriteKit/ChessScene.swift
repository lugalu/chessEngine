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
    
    private let chessBoard: SKSpriteNode = {
        let node = SKSpriteNode(color: .clear, size: .zero)
        node.anchorPoint = CGPoint(x: 0, y: 0)
        return node
    }()
    
    private let nodeGrid: [[SKSpriteNode]] = NodeFactory.makeMatrix()
    private let chessMatrix: [[ChessPiece?]] = PieceFactory.makeMatrix()
    private var squarePool: [SKSpriteNode] = NodeFactory.makeSpareSquares()
    private var inUseSquares: [SKSpriteNode] = []
    
    private var currentTurn: ChessColor = .white
    private var didSelectPiece = false
    
    override init() {
        super.init(size: .zero)
        addChild(leftMenu)
        addChild(chessBoard)
        self.isUserInteractionEnabled = true
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
        
        chessBoard.position = CGPoint(x: leftMenu.size.width, y: 0)
        if nodeGrid.first!.first!.parent == nil {
            nodeGrid.forEach { row in
                row.forEach { column in
                    chessBoard.addChild(column)
                }
            }
            
        }
        
        chessMatrix.forEach { row in
            for item in row {
                guard let item, item.piece.parent == nil else { continue }
                chessBoard.addChild(item.piece)
            }
        }
        updateSize(size)
    }
    
    func updateSize(_ size: CGSize) {
        self.size = size
        leftMenu.size.height = size.height
        
        let squareSize = ResizeMath.getSquare(from: size)
        chessBoard.size = squareSize
        
        moveChessTableNode(squareSize, size)
        updateGrid()
        updateChessGrid()
    }
    

    override func mouseDown(with event: NSEvent) {
        if didSelectPiece {
            onSelectedClick(event)
            return
        }
        onNonSelectedClick(event)
    }
    
    func onNonSelectedClick(_ event: NSEvent) {
        
        guard let node = nodes(at: event.locationInWindow).first as? SKSpriteNode , node.texture != nil else { return }
        let(x,y) = getIndexOfTouch(node: node)
        
        guard (0...7).contains(x) && (0...7).contains(y),
              let piece = chessMatrix[y][x],
              piece.color == currentTurn else {
            return
        }
        didSelectPiece = true

        let moves = piece.getMoves(currentBoard: chessMatrix)
        let attacks = piece.getAttack(currentBoard: chessMatrix)
        
        let boardSize = chessBoard.size
        let gridSize = ResizeMath.divideSizeForGrid(squareSize: boardSize)
        
        for move in moves {
            let square = squarePool.removeFirst()
            inUseSquares.append(square)
            let x = CGFloat(move.x) * gridSize.width
            let y = CGFloat(ResizeMath.offset(y: move.y)) * gridSize.height
            
            square.position = CGPoint(x: x, y: y)
            square.size = gridSize
            square.color = .green
        }
        
        for attack in attacks {
            let x = CGFloat(attack.x) * gridSize.width
            let y = CGFloat(attack.y) * gridSize.height
            var square: SKSpriteNode
            if let t = inUseSquares.filter({ $0.position.x == x && $0.position.y == y }).first {
                square = t
            } else {
                square = squarePool.removeFirst()
                square.position = CGPoint(x: x, y: y)
                square.size = gridSize
                inUseSquares.append(square)
            }
            
            square.color = .red
        }
        
        inUseSquares.forEach{
            if $0.parent == nil {
                chessBoard.addChild($0)
            }
        }
    }
    
    func getIndexOfTouch(node: SKSpriteNode)-> BoardCoords {
        let boardSize = chessBoard.size
        let gridSize = ResizeMath.divideSizeForGrid(squareSize: boardSize)
        let x = Int(node.position.x / gridSize.width)
        //invert the Y axis since the matrix 0,0 is on the top and on the screen is on the bottom
        let y = Int((boardSize.height - node.position.y) / gridSize.height) - 1
        
        return (x,y)
    }
    
    
    func onSelectedClick(_ event: NSEvent) {
        didSelectPiece = false
        
        let nodes = nodes(at: event.locationInWindow)
            .filter({ $0 is SKSpriteNode })
            .map({ $0 as! SKSpriteNode})
            .filter ({ $0.name == Constants.spareNodeName })
        
        guard let node = nodes.first else {
            removeSpares()
            return
        }
        
    }

    func removeSpares() {
        for _ in 0..<inUseSquares.count {
            let square = inUseSquares.removeFirst()
            square.removeFromParent()
            square.color = .clear
            squarePool.append(square)
            
            
        }
    }
    

}


//Sizing calculations
extension ChessScene {
    func moveChessTableNode(_ squareSize: CGSize, _ size: CGSize) {
        chessBoard.position = ResizeMath
            .getCenteredPositionForSquare(
                square: squareSize,
                screenSize: size,
                widthOffset: leftMenu.size.width
            )
    }
    
    func updateGrid() {
        let newSize = ResizeMath.divideSizeForGrid(
            squareSize: chessBoard.size
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
            squareSize: chessBoard.size
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
    
    
    static func makeSpareSquares() -> [SKSpriteNode] {
        var arr: [SKSpriteNode] = []
        for _ in 0..<30 {
            let node = SKSpriteNode(color: .clear, size: .zero)
            node.anchorPoint = CGPoint(x: 0, y: 0)
            node.name = Constants.spareNodeName
            arr.append(node)
        }
        
        return arr
    }
}
