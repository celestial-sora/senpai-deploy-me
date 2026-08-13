import Foundation

// A short, tap-through lesson designed to be completed in roughly three minutes.
let script: [DialogueLine] = [
    // 0: Opening — the problem Git solves
    DialogueLine(speaker: "Narrator", text: "งานกลุ่มใกล้ส่ง แต่ไฟล์ชื่อ final_v7_แก้จริงล่าสุด อยู่เต็มโฟลเดอร์…", sprite: nil, background: "bg_faculty", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 1
    DialogueLine(speaker: "Senpai", text: "ไม่ต้องตกใจนะ! ใน 3 นาที พี่จะพาใช้ Git กับ GitHub ให้เป็นภาพเดียวกัน", sprite: "senpai_smile", background: nil, choices: [
        Choice(text: "เริ่มเลย — Git กับ GitHub ต่างกันยังไง?", skillEffect: ["git": 5], nextIndex: 2),
        Choice(text: "ขอแบบสั้นและใช้ได้จริง", skillEffect: ["git": 5], nextIndex: 3)
    ], isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 2 (Choice A)
    DialogueLine(speaker: "Senpai", text: "Git คือสมุดบันทึกประวัติของโปรเจกต์ในเครื่องเรา ส่วน GitHub คือที่เก็บและแชร์โปรเจกต์นั้นบนออนไลน์", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: 4, autoSkillEffect: nil),

    // 3 (Choice B)
    DialogueLine(speaker: "Senpai", text: "จำง่าย ๆ: Git บันทึกงานในเครื่อง, GitHub เก็บสำเนาไว้บนออนไลน์และให้ทีมเห็นร่วมกัน", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: 4, autoSkillEffect: nil),

    // 4: Git basics
    DialogueLine(speaker: "Senpai", text: "เริ่มในโฟลเดอร์โปรเจกต์ด้วย git init — เท่านี้ Git ก็เริ่มติดตามงานของเราแล้ว", sprite: "senpai_normal", background: "bg_workspace", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 5
    DialogueLine(speaker: "Senpai", text: "แก้ไฟล์เสร็จ ให้ใช้ git status ดูก่อนว่ามีอะไรเปลี่ยนบ้าง เหมือนเช็กลิสต์ก่อนเซฟ", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 6
    DialogueLine(speaker: "Senpai", text: "git add . เลือกไฟล์ที่จะบันทึก แล้ว git commit -m \"อธิบายสิ่งที่เปลี่ยน\" เพื่อสร้างจุดย้อนกลับได้", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 7: Hands-on practice
    DialogueLine(speaker: "Senpai", text: "ลองเรียงลำดับคำสั่งด้วยตัวเองนะ: เริ่มติดตาม → ตรวจงาน → เตรียมบันทึก → commit → ส่งขึ้น GitHub", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 8: Terminal mini-game
    DialogueLine(speaker: "", text: "", sprite: nil, background: nil, choices: nil, isTerminalStep: true, jumpIndex: nil, autoSkillEffect: nil),

    // 9: GitHub connection
    DialogueLine(speaker: "Senpai", text: "เยี่ยม! ก่อน push ครั้งแรก ให้สร้าง repository ใหม่บน GitHub แล้วคัดลอก URL มาเชื่อมด้วย git remote add origin <github-url>", sprite: "senpai_smile", background: "bg_browser", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 10
    DialogueLine(speaker: "Senpai", text: "จากนั้น git push origin main จะส่ง commits ในเครื่องขึ้น GitHub ทุกครั้งที่ทำงานเสร็จ: status → add → commit → push", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: ["github": 50]),

    // 11
    DialogueLine(speaker: "Senpai", text: "ถ้าพลาด ก็เปิดประวัติ commit เพื่อดูว่าอะไรเปลี่ยนไปได้ และ GitHub ทำให้เพื่อนร่วมทีมเห็นงานชุดเดียวกัน", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 12: Closing
    DialogueLine(speaker: "Narrator", text: "จบแล้ว! น้องรู้เส้นทางของงานหนึ่งรอบแล้ว: Git เก็บประวัติในเครื่อง และ GitHub เก็บงานไว้ให้ทีมเข้าถึง", sprite: nil, background: "bg_ending", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: ["git": 50])
]
