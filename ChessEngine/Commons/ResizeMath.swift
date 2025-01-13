//Created by Lugalu on 13/01/25.

import Foundation

struct ResizeMath {
    private init(){}
    
    static func getSquare(from size: CGSize, widthOffset offset: CGFloat = 0) -> CGSize {
        let shortest = min(size.width - offset, size.height)
        return CGSize(width: shortest, height: shortest)
    }
    
    static func getCenteredPositionForSquare(square: CGSize, screenSize size: CGSize, widthOffset offset: CGFloat = 0 ) -> CGPoint {
        var newXPos = (square.width - offset) / 2
        newXPos += offset
        
        if newXPos + square.width > size.width {
            newXPos = offset
        }
        
        let newYPos = size.height - square.height
        
        return CGPoint(x: newXPos, y: newYPos)
    }
    
    static func divideSizeForGrid(squareSize size: CGSize) -> CGSize {
        let width = size.width / Constants.chessRowsColumns
        let height = size.height / Constants.chessRowsColumns
        
        return CGSize(width: width, height: height)
    }
}
