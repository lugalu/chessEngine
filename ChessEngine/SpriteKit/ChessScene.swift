//Created by Lugalu on 05/01/25.

import SpriteKit
import SwiftUI

protocol ChessSceneInterface: SKScene {
	func updateSize(_ size: CGSize)
	func configure(whitePlayerName: String, blackPlayerName: String, delegate: ChessView.Delegate?)
	func upgradePawn(with: String)
}
protocol ChessCommunication {
	func displaySelectionMenu()
	func declareWinner(color: ChessColor)
	func declareDraw()
}
class ChessScene: SKScene, ChessSceneInterface, ChessCommunication  {
	
	let leftMenu: InformationMenu = InformationMenu()
	lazy var chessBoard: ChessBoard = ChessBoard(delegate: self)
	var viewDelegate: ChessView.Delegate? = nil
	//    lazy var upgradeMenu: SKSpriteNode = SKSpriteNode()
	
	override init() {
		super.init(size: .zero)
		addChild(leftMenu)
		addChild(chessBoard)
	}
	
	required init?(coder: NSCoder) {
		fatalError("Init with Coder not implemented")
	}
	
	func configure(
		whitePlayerName: String,
		blackPlayerName: String,
		delegate: ChessView
			.Delegate?) {
				viewDelegate = delegate
				guard let size = Constants.adjustedScreenSize else {
					fatalError("NScreen not available")
				}
				updateSize(size)
			}
	
	func updateSize(_ size: CGSize) {
		self.size = size
		leftMenu.size.height = size.height
		
		let squareSize = ResizeMath.getSquare(from: size)
		chessBoard.size = squareSize
		
		moveChessTableNode(squareSize, size)
		chessBoard.updateGrid()
	}
	
	func moveChessTableNode(_ squareSize: CGSize, _ size: CGSize) {
		chessBoard.position = ResizeMath
			.getCenteredPositionForSquare(
				square: squareSize,
				screenSize: size,
				widthOffset: leftMenu.size.width
			)
	}
	
	
	func displaySelectionMenu() {
		self.isPaused = true
		viewDelegate?.openMenu(withColor: chessBoard.currentTurn)
	}
	
	func declareWinner(color: ChessColor){
		viewDelegate?.declareWinner(color: color)
		self.isPaused = true
	}
	
	func declareDraw(){
		viewDelegate?.declareDraw()
		self.isPaused = true
	}
	
	func upgradePawn(with name: String) {
		self.isPaused = false
		let color = chessBoard.currentTurn
		var piece: ChessPiece
		if name.contains("Queen") {
			piece = Queen(color: color)
		} else if name.contains("Bishop") {
			piece = Bishop(color: color)
		}else if name.contains("Knight") {
			piece = Knight(color: color)
		}else {
			piece = Rook(color: color)
		}
		
		chessBoard.upgradePawn(with: piece)
		
	}
}
