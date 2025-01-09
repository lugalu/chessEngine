//Created by Lugalu on 09/01/25.
import SwiftUI
import SpriteKit

struct ChessView: View {
    var scene: ChessSceneInterface = ChessScene()
    var body: some View {
        SpriteView(scene: scene, preferredFramesPerSecond: 60)
            .onAppear {
                scene.configure()
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
            
    }
}
