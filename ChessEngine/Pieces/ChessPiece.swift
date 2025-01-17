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
    
    func getMoves(currentBoard board: [[ChessPiece?]]) -> [BoardCoords] {
        let condition: MoveAttackCondition = { board, pos in
            board[pos.y][pos.x] == nil
        }
        
        return iterateAndCheck(
            currentBoard: board,
            toCheck: self.moves,
            resultCondition: condition
        )
    }
    
    func getAttack(currentBoard board: [[ChessPiece?]], currentPos position: BoardCoords) -> [BoardCoords] {
        let condition: MoveAttackCondition = { board, pos in
            guard let otherPiece = board[pos.y][pos.x] else{
                return false
            }
            
            return otherPiece.color != self.color
        }
        
        return iterateAndCheck(
            currentBoard: board,
            toCheck: self.attackDirections,
            resultCondition: condition
        )
    }
    
    
    private func iterateAndCheck(
        currentBoard board: [[ChessPiece?]],
        toCheck moves: [MoveDirections],
        resultCondition condition: MoveAttackCondition) -> [BoardCoords] {
        var result: [BoardCoords] = []
        
        guard let position = getPosition(on: board) else {
            fatalError("Selected piece that doesn't exist")
        }
        
        for move in moves {
            var currX = position.x
            var currY = position.y
            let (moveX,moveY) = move.getMoveOffset()
            
            for _ in 0..<moveDistance {
                currX += moveX
                currY += moveY

                let xCanContinue = (0..<board.count).contains(currX)
                let yCanContinue = (0..<board.count).contains(currY)
                
                if !xCanContinue || !yCanContinue,
                   !condition(board, (currX,currY)) {
                    break
                }
                
                result.append((currX,currY))
            }
        }
        
        return result
    }
    
    private func getPosition(on board: [[ChessPiece?]]) -> BoardCoords? {
        for (y, row) in board.enumerated() {
            guard let x = row.firstIndex(where: { $0 === self }) else {
                continue
            }
            return (x,y)
        }
        return nil
    }
}

