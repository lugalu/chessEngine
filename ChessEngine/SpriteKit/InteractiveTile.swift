//Created by Lugalu on 20/01/25.

import SpriteKit

enum TileType {
    case attack
    case move
	
	func getColor() -> NSColor {
		return self == .move ? .green : .red
	}
}

class InteractiveTile: SKSpriteNode {
    var boardPosition: BoardCoords = (0,0)
    var type: TileType = .move
    
	
}
