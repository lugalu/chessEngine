//Created by Lugalu on 24/01/25.

import SpriteKit

class InformationMenu: SKSpriteNode {
    
    init(){
        super.init(texture: nil, color: .red, size: CGSize(width: 250, height: 0))
        self.anchorPoint = .zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
