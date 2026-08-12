import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ResourceImage: View {
    let name: String
    let folder: String?

    var body: some View {
        if let path = imagePath() {
            #if canImport(UIKit)
            if let image = UIImage(contentsOfFile: path) {
                Image(uiImage: image).resizable()
            } else {
                Color.clear
            }
            #else
            Image(name, bundle: Bundle.main).resizable()
            #endif
        } else {
            Color.clear
        }
    }

    private func imagePath() -> String? {
        let bundle = Bundle.main
        let baseName = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension.isEmpty ? "jpg" : (name as NSString).pathExtension
        if let folder, let path = bundle.path(forResource: baseName, ofType: ext, inDirectory: folder) {
            return path
        }
        return bundle.path(forResource: baseName, ofType: ext)
    }
}

struct ContentView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            if gameState.playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                StartView()
            } else if gameState.isEnded {
                EndingView()
            } else {
                DialogueView()
            }
        }
        .animation(.default, value: gameState.isEnded)
    }
}
