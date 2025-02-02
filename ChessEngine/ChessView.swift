//Created by Lugalu on 09/01/25.
import SwiftUI
import SpriteKit



struct ChessView: View, ChessView.Delegate {
	protocol Delegate {
		func openMenu(withColor: ChessColor)
		func declareWinner(color: ChessColor)
		func declareDraw()
	}
	@Environment(\.dismiss) var dismiss
	@State var showUpgradeMenu: Bool = false
	@State var color: ChessColor? = nil
	@State var pieceIndex: Int = -1
	@State var winner: String? = nil
	
	var selectedArray: [String] {
		return color == .white ? whitePieces : blackPieces
	}
	
	let whitePieces: [String] = [
		"Rook_white",
		"Queen_white",
		"Bishop_white",
		"Knight_white"
	]
	
	let blackPieces: [String] = [
		"Rook_black",
		"Queen_black",
		"Bishop_black",
		"Knight_black"
	]
	
	let scene: ChessSceneInterface = ChessScene()
	
	var body: some View {
		ZStack {
			
			SpriteView(scene: scene)
				.navigationTitle("")
				.navigationBarBackButtonHidden()
			
			if showUpgradeMenu {
				makeMenu()
			}
			
			if let winner {
				makeWinScreen(winner)
			}
		}
		.background{
			WindowAccessor { window in
				if let window = window {
					let delegate = WindowDelegate.shared
					delegate.notified = scene
					window.delegate = delegate
				}
			}
		}
		.onAppear {
			scene.isPaused = false
			scene.configure(delegate: self)
			
		}
		.onDisappear {
			scene.reset()
			winner = nil
			showUpgradeMenu = false
		}
	}
	
	@ViewBuilder
	func makeMenu() -> some View {
		VStack(spacing: 4) {
			HStack{
				ForEach(Array(selectedArray.enumerated()), id: \.1) {
					index,
					imageName in
					Button {
						pieceIndex = index
					} label: {
						Image(imageName)
							.resizable()
							.frame(width: 100, height: 100)
							.scaledToFit()
							
					}
					.controlSize(.large)
					.buttonBorderShape(.roundedRectangle(radius: 15))
					.overlay(
						RoundedRectangle(cornerRadius: 15)
							.stroke(.green, lineWidth: pieceIndex == index ? 4 : 0)
					)
					
					
				}
			}
			.padding(16)
			
			
			Button {
				selectedPiece()
			} label: {
				Text("Confirm Promotion")
			}
			.disabled(pieceIndex == -1)
			.buttonStyle(.borderedProminent)
			.padding(.bottom, 16)
			.controlSize(.extraLarge)
			
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 16)
		.background{
			RoundedRectangle(cornerRadius: 15)
				.fill(Color.init(white: 0.3))
		}
	}
	
	@ViewBuilder
	func makeWinScreen(_ winner: String) -> some View {
		VStack{
			let winner = winner == "Draw" ? winner : "\(winner) won!"
			Text(winner)
				.font(.system(size: 72))
				.bold()
			
			Button(action: {
				dismiss()
			}){
				Text("OK!")
			}
			.buttonStyle(.bordered)
			.controlSize(.extraLarge)
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 16)
		.background{
			RoundedRectangle(cornerRadius: 15)
				.fill(Color.init(white: 0.3))
		}
	}
	
	func openMenu(withColor color: ChessColor) {
		showUpgradeMenu = true
		self.color = color
	}
	
	func declareWinner(color: ChessColor) {
		winner = color.rawValue
	}
	
	func declareDraw() {
		winner = "Draw"
	}
	
	func selectedPiece() {
		scene.upgradePawn(with: selectedArray[pieceIndex])
		showUpgradeMenu = false
		self.color = nil
		pieceIndex = -1
	}
}
