//Created by Lugalu on 05/01/25.

import SpriteKit

protocol ChessSceneInterface: SKScene {
    func updateSize(_ size: CGSize)
    func configure(whitePlayerName: String, blackPlayerName: String)
    func addGhost(color: ChessColor, position: BoardCoords)
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
    private var chessMatrix: [[ChessPiece?]] = PieceFactory.makeMatrix()
    
    private lazy var squarePool: [InteractiveTile] = {
        let nodes = NodeFactory.makeSpareSquares()
        nodes.forEach{ chessBoard.addChild($0) }
        return nodes
    }()
    
    private var inUseSquares: [InteractiveTile] = []
    
    private var currentTurn: ChessColor = .white
    private var selectedPiece: ChessPiece? = nil
    
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
        if selectedPiece != nil {
            onSelectedClick(event)
            return
        }
        onNonSelectedClick(event)
    }
    
    func onNonSelectedClick(_ event: NSEvent) {
        
        guard let node = nodes(at: event.locationInWindow).first as? ChessSprite,
              let piece = node.piece,
              piece.color == currentTurn else {
            return
        }
        
        selectedPiece = piece

        let moves = piece.currentMoves
        let attacks = piece.currentAttack
        
        let boardSize = chessBoard.size
        let gridSize = ResizeMath.divideSizeForGrid(squareSize: boardSize)
        
        for row in moves {
            for move in row {
                guard chessMatrix[move.y][move.x] == nil else { break }
                let square = squarePool.removeFirst()
                inUseSquares.append(square)
                let x = CGFloat(move.x) * gridSize.width
                let y = CGFloat(ResizeMath.offset(y: move.y)) * gridSize.height
                
                square.position = CGPoint(x: x, y: y)
                square.size = gridSize
                square.color = .green
                square.boardPosition = move
            }
        }
        
        for row in attacks {
            for attack in row {
                guard let otherPiece = chessMatrix[attack.y][attack.x] else {
                    continue
                }
                guard otherPiece.color != currentTurn else { break }
                let x = CGFloat(attack.x) * gridSize.width
                let y = CGFloat(ResizeMath.offset(y: attack.y)) * gridSize.height
                var square: InteractiveTile
                if let t = inUseSquares.filter({ $0.position.x == x && $0.position.y == y }).first {
                    square = t
                } else {
                    square = squarePool.removeFirst()
                    square.position = CGPoint(x: x, y: y)
                    square.size = gridSize
                    square.boardPosition = attack
                    inUseSquares.append(square)
                }
                
                square.color = .red
                break
            }
        }
        
    }
    

    
    func onSelectedClick(_ event: NSEvent) {
        defer {
            selectedPiece = nil
            removeSpares()
        }
        let nodes = nodes(at: event.locationInWindow)
            .filter({ $0 is InteractiveTile })
            .map({ $0 as! InteractiveTile})
        
        guard let node = nodes.first else {
            return
        }
        let oldPos = selectedPiece!.position
        let newPos = node.boardPosition
        chessMatrix[oldPos.y][oldPos.x] = nil
        chessMatrix[newPos.y][newPos.x] = selectedPiece
        
        selectedPiece?.onMove(newPosition: node.boardPosition, delegate: self)
        selectedPiece?.piece.position = node.position
        
        currentTurn = currentTurn == .white ? .black : .white
    }

    func removeSpares() {
        for _ in 0..<inUseSquares.count {
            let square = inUseSquares.removeFirst()
            square.color = .clear
            square.position = CGPoint(x: 0, y: -500)
            squarePool.append(square)
            
            
        }
    }
    
    func addGhost(color: ChessColor, position: BoardCoords) {
        print("blebleble!")
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


