//Created by Lugalu on 24/01/25.

import SpriteKit

class InformationMenu: SKSpriteNode {
	let turnLabel: SKLabelNode = SKLabelNode(text: "White")
	let delegate: ChessCommunication?
	
	lazy var giveUpButton = GenericButton(labelText: "Give Up", action: { [weak self] in
		self?.delegate?.wantToResign()
	})
	
	lazy var deadPositionButton = GenericButton(labelText: "Dead Position", action: { [weak self] in
		self?.delegate?.declareDraw()
	})
	
	init(delegate: ChessCommunication?){
		self.delegate = delegate
        super.init(texture: nil, color: .red, size: CGSize(width: 250, height: 0))
        self.anchorPoint = .zero
		
		self.addChild(turnLabel)
		self.addChild(giveUpButton)
		self.addChild(deadPositionButton)
		
		giveUpButton.size = .init(width: 150, height: 100)
		deadPositionButton.size = .init(width: 150, height: 100)
    }

	func updateSize(newHeight: CGFloat) {
		turnLabel.position.y = 0.9 * newHeight
		giveUpButton.position.y = 0.2 * newHeight
		deadPositionButton.position.y = 0.35 * newHeight
		
		turnLabel.position.x = self.size.width / 2
		giveUpButton.position.x = self.size.width / 2
		deadPositionButton.position.x = self.size.width / 2
	}
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GenericButton: SKSpriteNode {
	let label: SKLabelNode = SKLabelNode()
	var onClick: ()->Void
	
	init(labelText: String, action: @escaping ()->Void) {
		onClick = action
		super.init(texture: nil, color: .darkGray, size: .zero)
		self.label.text = labelText
		self.label.fontSize = 32
		self.isUserInteractionEnabled = true
		self.addChild(label)
		label.position = CGPoint(x: self.size.width / 2,
								 y: self.size.height / 2)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	override func mouseDown(with event: NSEvent) {
		onClick()
	}
	
}
