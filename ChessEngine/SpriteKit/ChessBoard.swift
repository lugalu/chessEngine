//Created by Lugalu on 23/01/25.

import SpriteKit


class ChessBoard: SKSpriteNode{
	protocol Interface {
		func addGhost(ghost: Ghost)
	}
	
	var currentTurn: ChessColor = .white
	var selectedPiece: ChessPiece? = nil
	var delegate: ChessCommunication?
	var upgradePos: BoardCoords? = nil
	
	let nodeGrid: [[SKSpriteNode]] = NodeFactory.makeMatrix()
	var chessMatrix: [[ChessPiece?]] = PieceFactory.makeMatrix()
	
	var squarePool: [InteractiveTile] = NodeFactory.makeSpareSquares()
	var inUseSquares: [InteractiveTile] = []
	
	init(delegate: ChessCommunication?) {
		self.delegate = delegate
		super.init(texture: nil, color: .clear, size: .zero)
		self.isUserInteractionEnabled = true
		self.anchorPoint = CGPoint(x: 0, y: 0)
		
		configure()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func configure() {
		let rowColumn = Int(Constants.chessRowsColumns)
		for y in 0..<rowColumn{
			for x in 0..<rowColumn {
				if nodeGrid[y][x].parent == nil {
					self.addChild(nodeGrid[y][x])
				}
				
				guard let piece = chessMatrix[y][x],
					  piece.sprite.parent == nil else {
					continue
				}
				self.addChild(piece.sprite)
			}
		}
		
		squarePool.forEach { item in
			if item.parent == nil {
				self.addChild(item)
			}
		}
	}
	
	func updateGrid() {
		let newSize = ResizeMath.divideSizeForGrid(
			squareSize: self.size
		)
		
		nodeGrid.enumerated().forEach { y, row in
			row.enumerated().forEach {x, item in
				updateSpriteSizeAndPosition(
					piece: item,
					newSize: newSize,
					newPosition: (x,y)
				)
			}
		}
		
		chessMatrix.enumerated().forEach { y, row in
			for (x, item) in row.enumerated() {
				guard let item else { continue }
				updatePieceSizeAndPosition(
					piece: item,
					newSize: newSize,
					newPosition: (x, ResizeMath.offset(y: y))
				)
			}
		}
	}
	
	func reset() {
		chessMatrix
			.flatMap({ $0 })
			.compactMap({ $0 })
			.forEach({
				$0.sprite.removeFromParent()
			})
		chessMatrix = PieceFactory.makeMatrix()
		configure()
		updateGrid()
		currentTurn = .white
		upgradePos = nil
		selectedPiece = nil
		
		removeSpares()
	}
	
	
	
}

//Mouse
extension ChessBoard {
	override func mouseDown(with event: NSEvent) {
		if selectedPiece != nil {
			onSelectedClick(event)
			return
		}
		
		onNonSelectedClick(event)
	}
	
	func onNonSelectedClick(_ event: NSEvent) {
		let normalizedCoords = event.location(in: self)
		guard let node = nodes(at:normalizedCoords).first as? ChessSprite,
			  let piece = node.piece,
			  !(piece is Ghost),
			  piece.color == currentTurn else {
			return
		}
		
		selectedPiece = piece
		
		var moves = getValidMoves(for: piece)
		var attacks = getValidAttacks(for: piece).filter({ (x,y) in
			!(chessMatrix[y][x] is King)
		})
		
		if selectedPiece is King {
			let enemies = getPieces(withColor: selectedPiece!.color.inverted())
			moves = filterKing(moves: moves, enemies)
			attacks = filterKing(attacks: attacks, enemies)
		}
		
		makeSquares(positions: moves, type: .move)
		makeSquares(positions: attacks, type: .attack)
		
	}
	
	func getValidMoves(for piece: ChessPiece) -> [BoardCoords] {
		var moves = piece.currentMoves
		for (rowIdx, row) in moves.enumerated() {
			for (idx, (x, y)) in row.enumerated() {
				guard chessMatrix[y][x] == nil else {
					moves[rowIdx].removeLast(moves[rowIdx].count - idx)
					break
				}
			}
		}
		
		return moves.flatMap({ $0 })
	}
	
	func getValidAttacks( for piece: ChessPiece) -> [BoardCoords] {
		let attacks = piece.currentAttacks
		var result: [BoardCoords] = []
		for row in attacks {
			for (x, y) in row {
				guard let otherPiece = chessMatrix[y][x] else {
					continue
				}
				guard otherPiece.color != piece.color else {
					break
				}
				result.append((x,y))
				break
			}
		}
		
		return result
	}
	
	func makeSquares(positions: [BoardCoords], type: TileType) {
		let gridSize = ResizeMath.divideSizeForGrid(squareSize: size)
		
		for position in positions {
			let x = CGFloat(position.x) * gridSize.width
			let y = CGFloat(ResizeMath.offset(y: position.y)) * gridSize.height
			var square: InteractiveTile
			if let t = inUseSquares.filter({ $0.position.x == x && $0.position.y == y }).first {
				square = t
			} else {
				square = squarePool.removeFirst()
				square.position = CGPoint(x: x, y: y)
				square.size = gridSize
				square.boardPosition = position
				inUseSquares.append(square)
			}
			square.type = type
			square.color = type.getColor()
		}
	}
	
	
	func onSelectedClick(_ event: NSEvent) {
		defer {
			selectedPiece = nil
			removeSpares()
		}
		
		let normalizedCoords = event.location(in: self)
		let nodes = nodes(at: normalizedCoords)
			.filter({ $0 is InteractiveTile })
			.map({ $0 as! InteractiveTile})
		
		guard let node = nodes.first, let selectedPiece else {
			return
		}
		
		let oldPos = selectedPiece.position
		let newPos = node.boardPosition
		
		if node.type == .attack, let oldNode = chessMatrix[newPos.y][newPos.x] {
			attackPiece(oldNode)
		}
		
		chessMatrix[oldPos.y][oldPos.x] = nil
		chessMatrix[newPos.y][newPos.x] = selectedPiece
		
		selectedPiece.onMove(newPosition: node.boardPosition, delegate: self)
		selectedPiece.sprite.position = node.position
		
		if selectedPiece.canUpgrade() {
			upgradePos = newPos
			delegate?.displaySelectionMenu()
			return
		}
		
		changeTurn()
		
	}
	
	func removeSpares() {
		for _ in 0..<inUseSquares.count {
			let square = inUseSquares.removeFirst()
			square.color = .clear
			square.position = CGPoint(x: 0, y: -500)
			squarePool.append(square)
		}
	}
	
	func attackPiece(_ oldNode: ChessPiece) {
		oldNode.sprite.removeFromParent()
		
		if let ghost = oldNode as? Ghost {
			let reference = ghost.reference
			let pos = reference.position
			reference.sprite.removeFromParent()
			chessMatrix[pos.y][pos.x] = nil
			
		}
	}
	
	func changeTurn() {
		let kings = chessMatrix.flatMap {
			
			$0.filter({
				guard let piece = $0 else { return false }
				return piece is King
			}).compactMap({ $0 })
		}
		
		guard let whiteKing = kings.filter({ $0.color == .white }).first,
			  let blackKing = kings.filter({ $0.color == .black }).first else {
			fatalError()
		}
		
		let whiteKingStatus = analyse(king: whiteKing)
		let blackKingStatus = analyse(king: blackKing)
		print(whiteKingStatus, blackKingStatus)
		
		if whiteKingStatus == blackKingStatus && whiteKingStatus == .checkMate {
			delegate?.declareDraw()
			return
		}
		
		if whiteKingStatus == .checkMate {
			delegate?.declareWinner(color: .black)
			return
		}
		
		if blackKingStatus == .checkMate {
			delegate?.declareWinner(color: .white)
			return
		}
		
		
		currentTurn = currentTurn.inverted()
		removeTurnGhosts()
		delegate?.onTurnChange(newTurn: currentTurn)
	}
	
	func removeTurnGhosts() {
		chessMatrix.forEach { row in
			row
				.filter({
					guard let node = $0 else { return false }
					return node is Ghost && node.color == currentTurn
				})
				.compactMap( { $0 as? Ghost})
				.forEach { node in
					let pos = node.position
					chessMatrix[pos.y][pos.x] = nil
					node.sprite.removeFromParent()
				}
			
		}
	}
	
	func upgradePawn(with piece: ChessPiece) {
		guard let upgradePos,
			  let oldNode = chessMatrix[upgradePos.y][upgradePos.x]
		else { return }
		addChild(piece.sprite)
		chessMatrix[upgradePos.y][upgradePos.x] = piece
		
		piece.sprite.position = oldNode.sprite.position
		piece.sprite.size = oldNode.sprite.size
		piece.sprite.anchorPoint = oldNode.sprite.anchorPoint
		piece.sprite.zPosition = oldNode.sprite.zPosition
		
		piece.onMove(newPosition: upgradePos, delegate: self)
		oldNode.sprite.removeFromParent()
		self.upgradePos = nil
	}
	
	enum KingFlag {
		case safe
		case onCheck
		case checkMate
	}
	

	
	func analyse(king: ChessPiece) -> KingFlag {
		guard king is King else {
			fatalError("Supplied Piece is not a King, developer error")
		}
		
		let enemies = getPieces(withColor: king.color.inverted())
		var (underAttack, directAttacks) = isUnderAttack(
			piece: king,
			enemies: enemies
		)
		
		guard underAttack else { return .safe }
		
		directAttacks = filterDirectAttacks(king, directAttacks)
		
		guard !directAttacks.isEmpty else { return .safe }
		
		let kingAttacks = filterKing(attacks: getValidAttacks(for: king), enemies)
		let kingMoves = filterKing(moves: getValidMoves(for: king), enemies)
		
		return kingAttacks.isEmpty && kingMoves.isEmpty ? .checkMate : .onCheck
	}
	
	
	
	func getPieces(withColor color: ChessColor) -> [ChessPiece] {
		return chessMatrix.flatMap({
			$0.filter {
				guard let piece = $0 else { return false }
				return piece.color == color
			}
			.compactMap{ $0 }
		})
	}
	
	func isUnderAttack(piece: ChessPiece,
					   enemies: [ChessPiece]) -> (Bool, [ChessPiece]) {
		let directAttacks = enemies.filter { enemy in
			return canAttackReach(position: piece.position,
								  withPiece: enemy)
		}
		return (!directAttacks.isEmpty, directAttacks)
	}
	
	func filterDirectAttacks(_ king: ChessPiece, _ directAttacks: [ChessPiece]) -> [ChessPiece] {
		var removed = 0
		var directAttacks = directAttacks
		let allies = getPieces(withColor: king.color).filter({ !($0 is King) })
		for (enemyIdx, enemy) in directAttacks.enumerated() {
			for ally in allies {
				guard canAttackReach(position: enemy.position,
									 withPiece: ally) else {
					continue
				}
				
				directAttacks.remove(at: enemyIdx - removed)
				removed += 1
			}
		}
		return directAttacks
	}
	
	
	func filterKing(attacks: [BoardCoords], _ enemies: [ChessPiece]) -> [BoardCoords] {
		var removedAttacks = 0
		var kingAttacks = attacks
		attackLoop:for (attackIdx, attack) in kingAttacks.enumerated() {
			guard let piece = chessMatrix[attack.y][attack.x] else {
				fatalError("error in validAttacks logic")
			}
			
			let filteredEnemies = enemies.filter({ $0 !== piece })
			for enemy in filteredEnemies {
				guard canAttackReach(position: attack, withPiece: enemy) else {
					continue
				}
				
				kingAttacks.remove(at: attackIdx - removedAttacks)
				removedAttacks += 1
				continue attackLoop
			}
		}
		return kingAttacks
	}
	
	func filterKing(moves: [BoardCoords],_ enemies: [ChessPiece]) -> [BoardCoords] {
		var kingMoves = moves
		var removedMoves = 0
		moveLoop: for (moveIdx, move) in kingMoves.enumerated() {
			for enemy in enemies {
				guard canAttackReach(position: move, withPiece: enemy) else {
					continue
				}
				
				kingMoves.remove(at: moveIdx - removedMoves)
				removedMoves += 1
				continue moveLoop
			}
		}
		return kingMoves
	}
	
	func canAttackReach(position: BoardCoords, withPiece piece: ChessPiece ) -> Bool {
		for attack in piece.currentAttacks {
			guard attack
				.contains(where: {
					$0 == position
				}) else { continue }
			
			for (x,y) in attack {
				guard let other = chessMatrix[y][x] else {
					if chessMatrix[position.y][position.x] == nil && position == (x,y) {
						return true
					}
					continue
				}
				
				if other.position == position {
					return true
				}
				
				return false
			}
		}
		
		return false
	}
}

//Interface
extension ChessBoard: ChessBoard.Interface {
	func addGhost(ghost: Ghost) {
		let pos = ghost.position
		chessMatrix[pos.y][pos.x] = ghost
		
		let size = ResizeMath.divideSizeForGrid(
			squareSize: self.size
		)
		
		
		updatePieceSizeAndPosition(
			piece: ghost,
			newSize: size,
			newPosition: (pos.x, ResizeMath.offset(y: pos.y))
		)
		
		self.addChild(ghost.sprite)
	}
	
	func updatePieceSizeAndPosition(
		piece: ChessPiece,
		newSize: CGSize,
		newPosition pos: BoardCoords
	) {
		updateSpriteSizeAndPosition(
			piece: piece.sprite,
			newSize: newSize,
			newPosition: pos
		)
	}
	
	func updateSpriteSizeAndPosition(
		piece: SKSpriteNode,
		newSize: CGSize,
		newPosition pos: BoardCoords
	) {
		piece.size = newSize
		piece.position.x = CGFloat(pos.x) * piece.size.width
		piece.position.y = CGFloat(pos.y) * piece.size.height
	}
}
