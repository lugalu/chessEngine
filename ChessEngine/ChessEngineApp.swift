//Created by Lugalu on 22/12/24.

import SwiftUI

@main
struct ChessEngineApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainMenu()
            }
            .frame(minWidth: 1000, minHeight: 750)
        }
    }
}
