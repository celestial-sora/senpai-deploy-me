import Foundation

// A focused Git lesson designed to fit in roughly 90–120 seconds.
let script: [DialogueLine] = [
    DialogueLine(speaker: "Senpai", text: "ก่อนอื่นรู้มั้ยว่า Git คืออะไร? เดี๋ยวพี่เล่าให้ฟังสั้นๆ", sprite: "senpai_smile", background: "bg_workspace", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    DialogueLine(speaker: "Senpai", text: "Git คือตัวที่เซฟทุกจุดที่น้องเคยทำไว้ ถ้าพังก็ย้อนกลับมาดูประวัติได้เสมอ", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    DialogueLine(speaker: "Senpai", text: "ลองจัดลำดับคำสั่งพวกนี้ให้ถูกต้องดูนะ ลากสลับตำแหน่งได้เลย แล้วกดตรวจคำตอบ", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    DialogueLine(speaker: "", text: "", sprite: nil, background: nil, choices: nil, isTerminalStep: true, jumpIndex: nil, autoSkillEffect: nil),
    DialogueLine(speaker: "Senpai", text: "เก่งมาก! จำแค่ init → status → add → commit → remote → push ก็เอาตัวรอดได้แล้ว", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    DialogueLine(speaker: "Senpai", text: "ต่อให้พลาดตรงไหน ประวัติที่ commit ไว้ก็ย้อนกลับมาดูได้เสมอ", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    DialogueLine(speaker: "Senpai", text: "ครั้งหน้าเอาไปใช้ push เว็บของตัวเองขึ้น GitHub แล้วก็ deploy ได้เลย โชคดีนะ!", sprite: "senpai_smile", background: "bg_ending", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: ["git": 0])
]
