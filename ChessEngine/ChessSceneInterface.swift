//Created by Lugalu on 05/01/25.

import SpriteKit

protocol ChessSceneInterface: SKScene {
    func updateSize(_ size: CGSize)
    func configure()
}

class ChessScene: SKScene, ChessSceneInterface  {
    
    private let chessBaseNode: SKSpriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 100))
    
    override init() {
        super.init(size: .init(width: 100, height: 100))
        addChild(chessBaseNode)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addChild(chessBaseNode)
    }
    
    func configure() {
        guard let size =  NSApplication.shared.keyWindow?.frame.size else {
            fatalError("NScreen not available")
        }
        chessBaseNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        updateSize(size)
    }
    
    func updateSize(_ size: CGSize) {
        self.size = size
        let newSize = getCorrectSize(from: size)
        chessBaseNode.size = newSize
        chessBaseNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    
    private func getCorrectSize(from size: CGSize) -> CGSize {
        let shortest = min(size.width, size.height)
        return CGSize(width: shortest, height: shortest)
    }
}
