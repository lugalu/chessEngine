//Created by Lugalu on 09/01/25.
import SwiftUI
import SpriteKit



struct ChessView: View, ChessView.Delegate {
	protocol Delegate {
		func openMenu(withColor: ChessColor)
	}
	@State var showUpgradeMenu: Bool = false
	@State var color: ChessColor? = nil
	@State var pieceIndex: Int = -1
	
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
	
	var scene: ChessSceneInterface = ChessScene()
	
	var body: some View {
		ZStack {
			
			SpriteView(scene: scene, preferredFramesPerSecond: 60)
				.onAppear {
					scene
						.configure(
							whitePlayerName: "White",
							blackPlayerName: "Black",
							delegate: self
						)
				}
				.background {
					WindowAccessor { window in
						if let window = window {
							let delegate = WindowDelegate.shared
							delegate.notified = scene
							window.delegate = delegate
						}
					}
				}
				.navigationTitle("")
				.navigationBarBackButtonHidden()
			
			if showUpgradeMenu {
				makeMenu()
			}
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
			.tint(.gray)
			.padding(.bottom, 16)
			.controlSize(.extraLarge)
			
		}
		.background{
			RoundedRectangle(cornerRadius: 15)
				.fill(Color.gray)
		}
	}
	
	func openMenu(withColor color: ChessColor) {
		showUpgradeMenu = true
		self.color = color
	}
	
	func selectedPiece() {
		scene.upgradePawn(with: selectedArray[pieceIndex])
		showUpgradeMenu = false
		self.color = nil
		pieceIndex = -1
	}
}
