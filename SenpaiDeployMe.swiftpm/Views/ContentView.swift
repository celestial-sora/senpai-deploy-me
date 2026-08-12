import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            if gameState.isEnded {
                EndingView()
            } else {
                DialogueView()
            }
        }
        .animation(.default, value: gameState.isEnded)
    }
}
