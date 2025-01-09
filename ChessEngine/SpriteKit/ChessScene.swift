//Created by Lugalu on 05/01/25.

import SpriteKit

protocol ChessSceneInterface: SKScene {
    func updateSize(_ size: CGSize)
    func configure()
}

class ChessScene: SKScene, ChessSceneInterface  {
    private let leftMenu: SKSpriteNode =  {
        let node = SKSpriteNode(color: .red, size: CGSize(width: 250, height: 200))
        node.anchorPoint = CGPoint(x: 0, y: 0)
        return node
    }()
    private let chessBaseNode: SKSpriteNode = {
        let node = SKSpriteNode(
            color: .blue,
            size: CGSize(width: 100, height: 100)
        )
        node.anchorPoint = CGPoint(x: 0, y: 0)
        return node
    }()
    override init() {
        super.init(size: .init(width: 100, height: 100))
        addChild(leftMenu)
        addChild(chessBaseNode)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addChild(leftMenu)
        addChild(chessBaseNode)
    }
    
    func configure() {
        guard let size = Constants.adjustedScreenSize else {
            fatalError("NScreen not available")
        }
        chessBaseNode.position = CGPoint(x: leftMenu.size.width, y: 0)
        
        updateSize(size)
    }
    
    func updateSize(_ size: CGSize) {
        self.size = size
        leftMenu.size = CGSize(
            width: leftMenu.size.width,
            height: size.height
        )
        
        let newSize = getCorrectSize(from: size)
        chessBaseNode.size = newSize
        var newXPos = (newSize.width - leftMenu.size.width) / 2 + leftMenu.size.width
        newXPos = newXPos + newSize.width > size.width ? leftMenu.size.width : newXPos
        chessBaseNode.position = CGPoint(
            x: newXPos,
            y: size.height - newSize.height
        )
    }
    
    
    private func getCorrectSize(from size: CGSize) -> CGSize {
        let shortest = min(size.width - leftMenu.size.width, size.height)
        print(
            shortest,
            size.width,
            leftMenu.size.width,
            size.width - leftMenu.size.width,
            size.height
        )
        return CGSize(width: shortest, height: shortest)
    }
}
