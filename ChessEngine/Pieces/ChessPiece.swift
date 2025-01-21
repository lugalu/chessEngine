//Created by Lugalu on 22/12/24.

import SpriteKit

enum ChessColor: String {
    case black
    case white
}

typealias BoardCoords = (x: Int, y: Int)
typealias MoveAttackCondition = ([[ChessPiece?]], BoardCoords) -> Bool

class ChessPiece {
    var name: String { "Empty" }
    private(set) var hadFirstMove: Bool = false
    var moveDistance: Int { 64 }
    var attackDistance: Int { moveDistance }
    var moveDirections: [MoveDirections] { [] }
    var attackDirections: [MoveDirections] { moveDirections }
    var color: ChessColor
    var piece: SKSpriteNode
    
    var position: BoardCoords = (0,0)
    private(set) var currentMoves: [[BoardCoords]] = []
    private(set) var currentAttack: [[BoardCoords]] = []

    init(color: ChessColor){
        self.color = color
        piece = SKSpriteNode()
        
        piece = ChessSprite(
            pieceName: self.name,
            chessColor: self.color,
            piece: self
        )
        
        

    }
    
    func calculatePosition(forNewPosition: BoardCoords) {
        self.position = forNewPosition
        self.currentMoves = calculatePositions(
            check: moveDirections,
            distance: moveDistance
        )
        self.currentAttack = calculatePositions(
            check: attackDirections,
            distance: attackDistance
        )
    }
    
    private func calculatePositions(check moves: [MoveDirections],
                                 distance: Int) -> [[BoardCoords]] {
        var result: [[BoardCoords]] = []
        let boardSize = Int(Constants.chessRowsColumns)
        
        for move in moves {
            var currentMoves: [BoardCoords] = []
            var currX = position.x
            var currY = position.y
            let (moveX,moveY) = move.getMoveOffset()
            
            for _ in 0..<distance {
                currX += moveX
                currY += moveY

                let xCanContinue = (0..<boardSize).contains(currX)
                let yCanContinue = (0..<boardSize).contains(currY)
                
                if !xCanContinue || !yCanContinue {
                    break
                }
                
                currentMoves.append((currX,currY))
            }
            
            guard !currentMoves.isEmpty else { continue }
            result.append(currentMoves)
        }
        
        return result
    }
    
    func onMove(newPosition pos: BoardCoords, delegate: ChessSceneInterface ) {
        hadFirstMove = true
        calculatePosition(forNewPosition: pos)
        
    }
    
    

}

