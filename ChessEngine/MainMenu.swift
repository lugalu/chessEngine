//Created by Lugalu on 22/12/24.

import SwiftUI
import SpriteKit

struct MainMenu: View {
    
    @State var presentScene = false
    
    var body: some View {
        
        NavigationLink(destination: Test() , label: {
            Text("StartNewGame")
        })
        
    }
}

#Preview {
    MainMenu()
}


struct Test: View {
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
    }
}
