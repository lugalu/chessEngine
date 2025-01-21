//Created by Lugalu on 20/01/25.

import SpriteKit

struct NodeFactory {
    private init() {}
    
    static func makeMatrix() -> [[SKSpriteNode]] {
        var arr: [SKSpriteNode] = []
        
        for i in 1...Int(Constants.chessRowsColumns) {
            let color: NSColor = i.isMultiple(of: 2) ? .black : .white
            let node = SKSpriteNode(color: color, size: .zero)
            node.anchorPoint = CGPoint(x: 0, y: 0)
            arr.append(node)
        }
        
        var result: [[SKSpriteNode]] = []
        for i in 1...Int(Constants.chessRowsColumns) {
            var arr = arr.map { $0.copy() as! SKSpriteNode }
            arr = i.isMultiple(of: 2) ? arr : arr.reversed()
            result.append(arr)
        }
        
        return result
    }
    
    
    static func makeSpareSquares() -> [InteractiveTile] {
        var arr: [InteractiveTile] = []
        for _ in 0..<30 {
            let node = InteractiveTile(color: .clear, size: .zero)
            node.anchorPoint = CGPoint(x: 0, y: 0)
            node.position = CGPoint(x: 0, y: -500)
            node.alpha = 0.5
            arr.append(node)
        }
        
        return arr
    }
}
