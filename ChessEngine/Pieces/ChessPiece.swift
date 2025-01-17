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
            resultCondition: condition
        )
    }
    
    
    private func iterateAndCheck(
        currentBoard board: [[ChessPiece?]],
        resultCondition condition: MoveAttackCondition) -> [BoardCoords] {
        var result: [BoardCoords] = []
        
        guard let position = getPosition(from: board) else {
            fatalError("Selected piece that doesn't exist")
        }
        
        for attack in attackDirections {
            var currX = position.x
            var currY = position.y
            let (moveY,moveX) = attack.getMoveTuple()
            
            for i in 0..<moveDistance {
                if i >= board.count { break }
                currX += moveX
                currY += moveY
                
                if !condition(board, (currX,currY)) { break }
                
                result.append((currX,currY))
            }
        }
        
        return result
    }
    
    private func getPosition(from board: [[ChessPiece?]]) -> BoardCoords? {
        for (y, row) in board.enumerated() {
            guard let x = row.firstIndex(where: { $0 === self }) else {
                continue
            }
            return (x,y)
        }
        return nil
    }
}

