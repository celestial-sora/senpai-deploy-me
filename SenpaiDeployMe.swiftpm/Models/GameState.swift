import Foundation
import Combine

final class GameState: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var skills: [String: Int] = ["confidence": 0, "git": 0, "ai": 0]
    @Published var isEnded: Bool = false
    @Published var playerName: String = ""
    
    func reset() {
        currentIndex = 0
        skills = ["confidence": 0, "git": 0, "ai": 0]
        isEnded = false
        playerName = ""
    }
}
