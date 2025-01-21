//Created by Lugalu on 05/01/25.

import SpriteKit

protocol ChessSceneInterface: SKScene {
    func updateSize(_ size: CGSize)
    func configure(whitePlayerName: String, blackPlayerName: String)
    func addGhost(ghost: Ghost)
}

class ChessScene: SKScene, ChessSceneInterface  {
    let leftMenu: SKSpriteNode =  {
        let node = SKSpriteNode(color: .red,
                                size: CGSize(width: 250, height: 0)
        )
        node.anchorPoint = CGPoint(x: 0, y: 0)
        
        return node
    }()
    
    let chessBoard: SKSpriteNode = {
        let node = SKSpriteNode(color: .clear, size: .zero)
        node.anchorPoint = CGPoint(x: 0, y: 0)
        return node
    }()
    
    let nodeGrid: [[SKSpriteNode]] = NodeFactory.makeMatrix()
    var chessMatrix: [[ChessPiece?]] = PieceFactory.makeMatrix()
    
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
    

    
    func addGhost(ghost: Ghost) {
        let pos = ghost.position
        chessMatrix[pos.y][pos.x] = ghost
        
        let size = ResizeMath.divideSizeForGrid(
            squareSize: chessBoard.size
        )
        
        
        updatePieceSizeAndPosition(
            piece: ghost,
            newSize: size,
            newPosition: (pos.x, ResizeMath.offset(y: pos.y))
        )
        
        chessBoard.addChild(ghost.piece)
    }
    

    

}

//Chess User Interaction
extension ChessScene {
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
              !(piece is Ghost),
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
                square.type = .move
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
                square.type = .attack
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
        
        if node.type == .attack, let oldNode = chessMatrix[newPos.y][newPos.x] {
            oldNode.piece.removeFromParent()
            
            if let ghost = oldNode as? Ghost {
                let reference = ghost.reference
                let pos = reference.position
                reference.piece.removeFromParent()
                chessMatrix[pos.y][pos.x] = nil
                
            }
        }

        
        chessMatrix[oldPos.y][oldPos.x] = nil
        chessMatrix[newPos.y][newPos.x] = selectedPiece
        
        selectedPiece?.onMove(newPosition: node.boardPosition, delegate: self)
        selectedPiece?.piece.position = node.position
        
        changeTurn()
    }
    
    func removeSpares() {
        for _ in 0..<inUseSquares.count {
            let square = inUseSquares.removeFirst()
            square.color = .clear
            square.position = CGPoint(x: 0, y: -500)
            squarePool.append(square)
        }
    }
    
    func changeTurn() {
        currentTurn = currentTurn == .white ? .black : .white
        removeTurnGhosts()
        //TODO: Analyze for Check and Checkmate
    }
    
    func removeTurnGhosts() {
        chessMatrix.forEach { row in
            row
                .filter({
                    guard let node = $0 else { return false }
                    return node is Ghost && node.color == currentTurn
                })
                .compactMap( { $0 as? Ghost})
                .forEach { node in
                    let pos = node.position
                    chessMatrix[pos.y][pos.x] = nil
                    node.piece.removeFromParent()
                }
            
        }
    }
}
