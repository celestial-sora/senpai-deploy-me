import SwiftUI

struct TerminalMiniGameView: View {
    @EnvironmentObject var gameState: GameState
    @State private var currentStep = 0
    @State private var shakeOffset: CGFloat = 0
    
    let isSecondTime: Bool
    
    struct TerminalCommand {
        let text: String
        let description: String
    }
    
    let allCommands: [TerminalCommand] = [
        TerminalCommand(text: "git init", description: "สร้างโปรเจกต์ git ในโฟลเดอร์นี้"),
        TerminalCommand(text: "git add .", description: "บอก git ว่าจะเซฟไฟล์ไหนบ้าง"),
        TerminalCommand(text: "git commit -m \"first commit\"", description: "เซฟจุดนี้ไว้ พร้อมคำอธิบาย"),
        TerminalCommand(text: "git remote add origin <github-url>", description: "เชื่อมกับ repo บน GitHub"),
        TerminalCommand(text: "git push origin main", description: "ส่งงานขึ้น GitHub")
    ]
    
    var commands: [TerminalCommand] {
        if isSecondTime {
            return [allCommands[1], allCommands[2], allCommands[4]]
        } else {
            return allCommands
        }
    }
    
    var body: some View {
        VStack {
            Text("Terminal - Git Commands")
                .font(.headline)
                .foregroundColor(.green)
                .padding()
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(0..<commands.count, id: \.self) { index in
                        Button(action: {
                            if index == currentStep {
                                currentStep += 1
                                if !isSecondTime {
                                    gameState.skills["git", default: 0] += 20
                                }
                                if currentStep == commands.count {
                                    gameState.currentIndex += 1
                                }
                            } else {
                                triggerShake()
                            }
                        }) {
                            VStack(alignment: .leading) {
                                Text(commands[index].text)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(index < currentStep ? .gray : .white)
                                Text(commands[index].description)
                                    .font(.caption)
                                    .foregroundColor(index < currentStep ? .gray : .gray.opacity(0.8))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black.opacity(0.8))
                            .border(index == currentStep ? Color.green : Color.clear, width: 2)
                        }
                        .disabled(index < currentStep)
                    }
                }
                .padding()
                .offset(x: shakeOffset)
            }
        }
        .background(Color(white: 0.1).ignoresSafeArea())
    }
    
    func triggerShake() {
        withAnimation(.default) { shakeOffset = 10 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.default) { shakeOffset = -10 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.default) { shakeOffset = 0 }
        }
    }
}
