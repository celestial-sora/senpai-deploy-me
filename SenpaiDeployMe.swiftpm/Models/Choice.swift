import Foundation

struct Choice: Identifiable {
    let id = UUID()
    let text: String
    let skillEffect: [String: Int]   // key: "git" | "github"
    let nextIndex: Int
}
