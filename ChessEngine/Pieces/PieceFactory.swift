//Created by Lugalu on 16/01/25.

import SpriteKit

struct PieceFactory {
    private init(){}
    
	static func getSingles(withColor color: ChessColor) -> [ChessPiece] {
		var arr: [ChessPiece] = []
		
		arr.append(Rook(color: color))
		arr.append(Knight(color: color))
		arr.append(Bishop(color: color))
		arr.append(Queen(color: color))
		
		return arr
	}
	
    static func getBlackRows() -> [[ChessPiece]] {
        return genericPieces(color: .black)
    }
    
    static func getWhiteRows() -> [[ChessPiece]] {
        return genericPieces(color: .white).reversed()
    }
    
    private static func genericPieces(color: ChessColor) -> [[ChessPiece]] {
        var arr: [[ChessPiece]] = [
            [],
            []
        ]

        arr[0].append(Rook(color: color))
        arr[0].append(Knight(color: color))
        arr[0].append(Bishop(color: color))
        arr[0].append(Queen(color: color))
        arr[0].append(King(color: color))
        arr[0].append(Bishop(color: color))
        arr[0].append(Knight(color: color))
        arr[0].append(Rook(color: color))
        
        for _ in 0..<Int(Constants.chessRowsColumns) {
            arr[1].append(Pawn(color: color))
        }
        
        return arr
    }
    
    static func makeBlanks() -> [[ChessPiece?]] {
        let blank = Array<ChessPiece?>(
            repeating: nil,
            count: Int(Constants.chessRowsColumns)
        )
        return Array<[ChessPiece?]>(
            repeating: blank,
            count: Int(Constants.chessRowsColumns) / 2
        )
    }
    
    static func makeMatrix() -> [[ChessPiece?]] {
        let result = getBlackRows() + makeBlanks() + getWhiteRows()
        
        for (y, row) in result.enumerated() {
            for (x, item) in row.enumerated(){
                item?.sprite.zPosition = 1
                item?.calculatePosition(forNewPosition: (x,y))
            }
        }
        
        return result
    }
    
    
    
}
