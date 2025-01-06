//Created by Lugalu on 22/12/24.

import SwiftUI
import SpriteKit

struct MainMenu: View {
    
    var scene: ChessSceneInterface = ChessSchene()
    @State var presentScene = false
    
    var body: some View {

        NavigationLink(destination: SpriteView(scene: scene), label: {
                Text("StartNewGame")
            })
//        .background(WindowAccessor { window in
//                            if let window = window {
//                                window.delegate = WindowDelegate.shared
//                            }
//                        })
        
        
        
    }
}

#Preview {
    MainMenu()
}


// View to access the NSWindow
struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow?) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let nsView = NSView()
        DispatchQueue.main.async {
            if let window = nsView.window {
                callback(window)
            }
        }
        return nsView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

// NSWindowDelegate Implementation
class WindowDelegate: NSObject, NSWindowDelegate {
    static let shared = WindowDelegate()
    
    func windowDidResize(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            let newSize = window.frame.size
            print("Window resized to: \(newSize)")
        }
    }
}
