import Foundation
import Combine

final class GameState: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var skills: [String: Int] = ["git": 0, "github": 0]
    @Published var isEnded: Bool = false
    @Published var playerName: String = ""
    
    func reset() {
        currentIndex = 0
        skills = ["git": 0, "github": 0]
        isEnded = false
        playerName = ""
    }
}
