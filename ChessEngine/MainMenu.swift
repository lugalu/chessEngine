//Created by Lugalu on 22/12/24.

import SwiftUI
import SpriteKit

struct MainMenu: View {
    
    @State var presentScene = false
    
    var body: some View {
        //TODO: make something nice
        NavigationLink(destination: ChessView() , label: {
            Text("StartNewGame")
        })
        
    }
}

#Preview {
    MainMenu()
}
