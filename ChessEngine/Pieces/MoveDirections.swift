//Created by Lugalu on 23/12/24.

import Foundation

enum MoveDirections: CaseIterable {
    case up
    case down
    case left
    case right
    case diagonalUpRight
    case diagonalUpLeft
    case diagonalDownRight
    case diagonalDownLeft
    
    
    func getMoveTuple() -> (x: Int, y: Int) {
        return switch self {
        case .up:
            (0, -1)
        case .down:
            (0, 1)
        case .left:
            (-1,0)
        case .right:
            (1,0)
        case .diagonalUpRight:
            (1,1)
        case .diagonalUpLeft:
            (-1,1)
        case .diagonalDownRight:
            (1,1)
        case .diagonalDownLeft:
            (1,-1)
        }
    }
}
