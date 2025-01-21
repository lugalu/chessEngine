//Created by Lugalu on 21/01/25.

import SpriteKit

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
            row.enumerated().forEach {x, item in
                updateSpriteSizeAndPosition(
                    piece: item,
                    newSize: newSize,
                    newPosition: (x,y)
                )
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
                updatePieceSizeAndPosition(
                    piece: item,
                    newSize: newSize,
                    newPosition: (x, yOffset)
                )
            }
        }
    }
    
    func updatePieceSizeAndPosition(
        piece: ChessPiece,
        newSize: CGSize,
        newPosition pos: BoardCoords
    ) {
        updateSpriteSizeAndPosition(
            piece: piece.piece,
            newSize: newSize,
            newPosition: pos
        )
    }
    
    func updateSpriteSizeAndPosition(
        piece: SKSpriteNode,
        newSize: CGSize,
        newPosition pos: BoardCoords
    ) {
        piece.size = newSize
        piece.position.x = CGFloat(pos.x) * piece.size.width
        piece.position.y = CGFloat(pos.y) * piece.size.height
    }

}
