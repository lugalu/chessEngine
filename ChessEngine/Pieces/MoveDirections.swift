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
    
    case knightUpRightOne
    case knightUpRightTwo
    case knightUpLeftOne
    case knightUpLeftTwo
    
    case knightDownRightOne
    case knightDownRightTwo
    case knightDownLeftOne
    case knightDownLeftTwo
    
    
    func getMoveOffset() -> BoardCoords {
        return switch self {
        case .up: (0, -1)
        case .down: (0, 1)
        case .left: (-1,0)
        case .right: (1, 0)
            
        case .diagonalUpRight: (1, -1)
        case .diagonalUpLeft: (-1, -1)
        case .diagonalDownRight: (1, 1)
        case .diagonalDownLeft: (-1, 1)
            
        case .knightUpRightOne: (1, -2)
        case .knightUpRightTwo: (2, -1)
        case .knightUpLeftOne: (-1, -2)
        case .knightUpLeftTwo: (-2, -1)
            
        case .knightDownRightOne: (1, 2)
        case .knightDownRightTwo: (2, 1)
        case .knightDownLeftOne: (-1, 2)
        case .knightDownLeftTwo: (-2, 1)
        }
    }
}
