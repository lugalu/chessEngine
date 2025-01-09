//Created by Lugalu on 09/01/25.

import SpriteKit

struct Constants {
    private init(){}
    
    static public let topBarSize: Double = 28
    static public var screenSize: CGSize? {
        NSApplication.shared.keyWindow?.frame.size
    }
    static public var adjustedScreenSize: CGSize? {
        var newSize = screenSize
        newSize?.height -= topBarSize
        return newSize
    }
}
