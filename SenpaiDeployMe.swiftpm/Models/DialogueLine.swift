import Foundation

struct DialogueLine: Identifiable {
    let id = UUID()
    let speaker: String
    let text: String
    let sprite: String?       // ชื่อ asset, nil = ไม่มีตัวละครโชว์
    let background: String?   // nil = ใช้ background ฉากก่อนหน้าต่อ
    let choices: [Choice]?    // nil = ไปบรรทัดถัดไปอัตโนมัติ
    let isTerminalStep: Bool  // true = แสดง GitDragSortView แทน dialogue ปกติ
    let jumpIndex: Int?       // optional jump for branching
    let autoSkillEffect: [String: Int]? // automatic skill increase when this line is read
}
