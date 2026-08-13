import Foundation

// Git lesson: 3 intro lines → 6 command detail slides → minigame → 3 wrap-up lines
let script: [DialogueLine] = [

    // ── Intro (0–2) ──────────────────────────────────────────────────────────
    // 0
    DialogueLine(
        speaker: "Senpai",
        text: "Git คือระบบเซฟงานที่นักพัฒนาทั่วโลกใช้กัน มันเก็บ \"ประวัติ\" ของโค้ดทุกเวอร์ชันที่น้องเคยเซฟไว้",
        sprite: "senpai_smile", background: "bg_workspace",
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 1
    DialogueLine(
        speaker: "Senpai",
        text: "ลองนึกภาพว่า Git คือสมุดบันทึกเวทย์มนตร์ — ทุกครั้งที่น้องทำงานเสร็จแล้วกด \"เซฟ\" Git จะจำสถานะนั้นไว้ตลอดไป",
        sprite: "senpai_normal", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 2
    DialogueLine(
        speaker: "Senpai",
        text: "มีคำสั่งหลักๆ แค่ 6 ตัวที่ต้องรู้จัก พี่จะอธิบายทีละตัวเลยนะ",
        sprite: "senpai_smile", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Command 1: git init (3) ───────────────────────────────────────────────
    // 3
    DialogueLine(
        speaker: "Senpai",
        text: "① git init\n\nคำสั่งแรกเลย! ใช้ตอนเริ่มโปรเจกต์ใหม่ มันสร้างโฟลเดอร์ซ่อน .git ขึ้นมา ซึ่งเป็น \"สมุดบันทึก\" ของ Git\n\n📁 ทำครั้งเดียวต่อโปรเจกต์ก็พอ",
        sprite: "senpai_normal", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Command 2: git status (4) ─────────────────────────────────────────────
    // 4
    DialogueLine(
        speaker: "Senpai",
        text: "② git status\n\nใช้เช็คสถานะโปรเจกต์ว่าตอนนี้มีไฟล์ไหนเปลี่ยนแปลงบ้าง\n\n🔍 ดีแบบว่า... Git จะบอกว่าไฟล์ไหน \"ยังไม่ได้เซฟ\" หรือ \"รอเซฟ\" อยู่",
        sprite: "senpai_normal", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Command 3: git add (5) ────────────────────────────────────────────────
    // 5
    DialogueLine(
        speaker: "Senpai",
        text: "③ git add .\n\nบอก Git ว่าจะเซฟไฟล์ไหนบ้าง จุด (.) หมายถึง \"ทุกไฟล์\"\n\n📦 เหมือนหยิบของใส่กล่องก่อนส่ง — ยังไม่ได้ส่งจริง แค่เตรียมไว้ก่อน",
        sprite: "senpai_normal", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Command 4: git commit (6) ─────────────────────────────────────────────
    // 6
    DialogueLine(
        speaker: "Senpai",
        text: "④ git commit -m \"message\"\n\nนี่คือการ \"เซฟจริงๆ\" ใส่ข้อความอธิบายว่าเซฟอะไรไว้\n\n💾 เหมือนกด Save แล้วใส่โน้ตว่า \"แก้บัก login\" หรือ \"เพิ่มหน้า about\" — ย้อนกลับมาดูทีหลังได้ตลอด",
        sprite: "senpai_smile", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Command 5: git remote add (7) ─────────────────────────────────────────
    // 7
    DialogueLine(
        speaker: "Senpai",
        text: "⑤ git remote add origin <url>\n\nบอก Git ว่าจะส่งงานขึ้นที่ไหน — URL คือที่อยู่ของ Repo บน GitHub\n\n🔗 ทำครั้งเดียวต่อโปรเจกต์ก็พอ หลังจากนี้ Git รู้แล้วว่า \"origin\" คือที่ไหน",
        sprite: "senpai_normal", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Command 6: git push (8) ───────────────────────────────────────────────
    // 8
    DialogueLine(
        speaker: "Senpai",
        text: "⑥ git push origin main\n\nส่งงานที่ commit ไว้ขึ้น GitHub จริงๆ!\n\n🚀 ตอนนี้คนอื่นทั่วโลกก็เห็นโค้ดน้องได้แล้ว — นี่แหละคือ \"deploy\" เบื้องต้นสุด",
        sprite: "senpai_admire", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Pre-minigame prompt (9) ───────────────────────────────────────────────
    // 9
    DialogueLine(
        speaker: "Senpai",
        text: "ทีนี้มาลองทบทวนดูนะ! เรียงลำดับ 6 คำสั่งนี้ให้ถูกต้อง\nลากสลับตำแหน่งได้เลย แล้วกดตรวจคำตอบ 💪",
        sprite: "senpai_smile", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // ── Minigame (10) ─────────────────────────────────────────────────────────
    // 10
    DialogueLine(
        speaker: "", text: "", sprite: nil, background: nil,
        choices: nil, isTerminalStep: true, jumpIndex: nil, autoSkillEffect: nil),

    // ── Wrap-up (11–13) ───────────────────────────────────────────────────────
    // 11
    DialogueLine(
        speaker: "Senpai",
        text: "เก่งมาก! จำแค่ init → status → add → commit → remote → push ก็เอาตัวรอดได้แล้ว",
        sprite: "senpai_admire", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 12
    DialogueLine(
        speaker: "Senpai",
        text: "ต่อให้พลาดตรงไหน ประวัติที่ commit ไว้ก็ย้อนกลับมาดูได้เสมอ — Git ไม่มีทางทำให้งานหายถาวรหรอก",
        sprite: "senpai_normal", background: nil,
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),

    // 13
    DialogueLine(
        speaker: "Senpai",
        text: "พ...พี่เห็นน้องเรียนรู้ไวขนาดนี้แล้ว... รู้สึกภูมิใจจัง!\nครั้งหน้าเอาไปใช้ push เว็บขึ้น GitHub แล้วก็ deploy ได้เลยนะ!",
        sprite: "senpai_blush", background: "bg_ending",
        choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: ["git": 0])
]
