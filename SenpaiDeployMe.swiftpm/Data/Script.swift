import Foundation

let script: [DialogueLine] = [
    // 0: ฉาก 1 — วันแรกเข้าคณะ
    DialogueLine(speaker: "Narrator", text: "วันแรกของการเป็นนักศึกษาคณะ Web Fullstack...", sprite: nil, background: "bg_faculty", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 1
    DialogueLine(speaker: "Senpai", text: "ว่าไงน้อง ตื่นเต้นมั้ย? เดี๋ยวพี่พาไปทำเว็บส่วนตัวของตัวเองกันเลย จบวันนี้ต้องได้เว็บ live จริงๆ", sprite: "senpai_smile", background: nil, choices: [
        Choice(text: "ตื่นเต้นมาก! ไปกันเลย", skillEffect: ["confidence": 5], nextIndex: 2),
        Choice(text: "แต่หนูโค้ดไม่เป็นเลยนะ...", skillEffect: ["confidence": 5], nextIndex: 3)
    ], isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 2 (Choice A)
    DialogueLine(speaker: "Senpai", text: "เยี่ยม! ความมั่นใจคือจุดเริ่มต้นที่ดี!", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: 4, autoSkillEffect: nil),
    
    // 3 (Choice B)
    DialogueLine(speaker: "Senpai", text: "ไม่เป็นไร ไม่ต้องมีพื้นฐานก็ทำได้ พี่จะสอนทีละสเต็ป", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: 4, autoSkillEffect: nil),
    
    // 4: ฉาก 2 — สอน Git พื้นฐาน
    DialogueLine(speaker: "Senpai", text: "ก่อนจะเริ่ม เราต้องรู้จัก Git ก่อน มันคือตัวช่วยเซฟงานของเราแบบมี 'ประวัติ' ย้อนดูได้", sprite: "senpai_normal", background: "bg_workspace", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 5
    DialogueLine(speaker: "Senpai", text: "ลองพิมพ์ตามพี่นะ", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 6: Terminal Minigame 1
    DialogueLine(speaker: "", text: "", sprite: nil, background: nil, choices: nil, isTerminalStep: true, jumpIndex: nil, autoSkillEffect: nil),
    
    // 7
    DialogueLine(speaker: "Senpai", text: "เท่านี้แหละ! ครบสูตร 5 คำสั่งที่ใช้บ่อยที่สุด", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 8: ฉาก 3 — สอน AI Vibecoding
    DialogueLine(speaker: "Senpai", text: "ทีนี้มาสร้างเว็บกัน ไม่ต้องเขียนโค้ดเองทั้งหมดหรอก ใช้ AI ช่วยได้", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 9
    DialogueLine(speaker: "Senpai", text: "ลองพิมพ์สั่ง AI ว่า 'สร้างเว็บพอร์ตโฟลิโอ มีชื่อ รูป และลิงก์โซเชียล'", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 10: Mock chat UI (we'll just use dialogue for this as requested flavor text)
    DialogueLine(speaker: "AI", text: "กำลังสร้างโค้ด...\n```html\n<h1>My Portfolio</h1>\n<p>Welcome to my page!</p>\n```", sprite: nil, background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 11
    DialogueLine(speaker: "Senpai", text: "เห็นมั้ย AI เขียนโค้ด HTML/CSS ให้เราแล้ว งานเราคือ 'สั่งให้ถูก' กับ 'เข้าใจว่ามันทำอะไร'", sprite: "senpai_smile", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: ["ai": 30]),
    
    // 12: ฉาก 4 — Push ขึ้น GitHub + Deploy บน Vercel
    DialogueLine(speaker: "Senpai", text: "โค้ดพร้อมแล้ว ทวนกันอีกที: add → commit → push", sprite: "senpai_normal", background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 13: Terminal Minigame 2
    DialogueLine(speaker: "", text: "", sprite: nil, background: nil, choices: nil, isTerminalStep: true, jumpIndex: nil, autoSkillEffect: nil),
    
    // 14
    DialogueLine(speaker: "Senpai", text: "ต่อไปเอาไฟล์นี้ไป deploy ที่ Vercel\nเข้า vercel.com → Login ด้วย GitHub → Import repo → กด Deploy", sprite: "senpai_smile", background: "bg_browser", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 15
    DialogueLine(speaker: "System", text: "Deploying... ✅ Deployed Successfully!", sprite: nil, background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 16: ฉาก 5 — Ending
    DialogueLine(speaker: "Senpai", text: "ยินดีด้วย! นี่คือเว็บของน้องเองแล้ว live อยู่บน internet จริงๆ\n(your-name.vercel.app)", sprite: "senpai_smile", background: "bg_ending", choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil),
    
    // 17
    DialogueLine(speaker: "Narrator", text: "และนี่คือจุดเริ่มต้นของ Web Developer คนใหม่...", sprite: nil, background: nil, choices: nil, isTerminalStep: false, jumpIndex: nil, autoSkillEffect: nil)
]
