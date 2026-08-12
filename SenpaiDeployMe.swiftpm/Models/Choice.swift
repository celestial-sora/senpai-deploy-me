import Foundation

struct Choice: Identifiable {
    let id = UUID()
    let text: String
    let skillEffect: [String: Int]   // key: "confidence" | "git" | "ai"
    let nextIndex: Int
}
