//Created by Lugalu on 05/01/25.

import SpriteKit

protocol ChessSceneInterface: SKScene {
    func updateSize(_ size: CGSize)
}

class ChessSchene: SKScene, ChessSceneInterface  {
    override init() {
        super.init(size: .zero)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateSize(_ size: CGSize) {
        let shortest = min(size.width, size.height)
        
        
    }
}
