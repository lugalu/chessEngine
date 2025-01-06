//Created by Lugalu on 06/01/25.

import SwiftUI

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
    static let shared: WindowDelegate = WindowDelegate()
    var notified: ChessSceneInterface? = nil
    
    override private init() { super.init() }
    
    func windowDidResize(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            let newSize = window.frame.size
            notified?.updateSize(newSize)
        }
    }
}
