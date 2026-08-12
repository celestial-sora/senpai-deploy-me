import SwiftUI

struct TerminalMiniGameView: View {
    @EnvironmentObject var gameState: GameState
    @State private var commands: [TerminalCommand]
    @State private var selectedIndex: Int?
    @State private var failedAttempts = 0
    @State private var feedback = "แตะคำสั่ง 2 อันเพื่อสลับตำแหน่ง แล้วเรียงให้ถูก"
    @State private var isSolved = false

    let isSecondTime: Bool

    struct TerminalCommand: Identifiable {
        let id = UUID()
        let text: String
        let description: String
    }

    private static let allCommands: [TerminalCommand] = [
        TerminalCommand(text: "git init", description: "สร้างโปรเจกต์ git ในโฟลเดอร์นี้"),
        TerminalCommand(text: "git status", description: "เช็กสถานะไฟล์ก่อนเริ่มบันทึกงาน"),
        TerminalCommand(text: "git add .", description: "บอก git ว่าจะเซฟไฟล์ไหนบ้าง"),
        TerminalCommand(text: "git diff --cached", description: "ตรวจไฟล์ที่จะถูก commit อีกครั้ง"),
        TerminalCommand(text: "git commit -m \"first commit\"", description: "เซฟจุดนี้ไว้ พร้อมคำอธิบาย"),
        TerminalCommand(text: "git remote add origin <github-url>", description: "เชื่อมกับ repo บน GitHub"),
        TerminalCommand(text: "git push origin main", description: "ส่งงานขึ้น GitHub")
    ]

    init(isSecondTime: Bool) {
        self.isSecondTime = isSecondTime
        let target = isSecondTime
            ? [Self.allCommands[2], Self.allCommands[4], Self.allCommands[5], Self.allCommands[6]]
            : Self.allCommands
        _commands = State(initialValue: target.shuffled())
    }

    private var targetCommands: [TerminalCommand] {
        isSecondTime
            ? [Self.allCommands[2], Self.allCommands[4], Self.allCommands[5], Self.allCommands[6]]
            : Self.allCommands
    }

    private var correctCount: Int {
        zip(commands, targetCommands).filter { $0.id == $1.id }.count
    }

    @State private var inputCommand = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 8) {
                    StatusDot(color: isSolved ? SenpaiTheme.mint : SenpaiTheme.accent)
                    Text("TERMINAL PUZZLE")
                        .font(.caption.weight(.bold))
                        .tracking(1.4)
                        .foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
                Text("\(correctCount) / \(commands.count) ถูกตำแหน่ง")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(SenpaiTheme.mint)
            }
            .padding(.horizontal, 24)
            .padding(.top, 22)

            Text(isSecondTime ? "เรียงคำสั่งก่อน deploy" : "จัดลำดับการทำงานของ Git")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 8)

            Text("แตะ 2 ใบเพื่อสลับตำแหน่ง หรือพิมพ์คำสั่งลง Terminal")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.62))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 4)

            ProgressView(value: Double(correctCount), total: Double(commands.count))
                .tint(SenpaiTheme.mint)
                .padding(.horizontal, 24)
                .padding(.top, 12)

            // Interactive Terminal Keyboard Prompt (iPad/iOS focusable)
            TerminalInputRow(
                inputCommand: $inputCommand,
                isInputFocused: $isInputFocused,
                onSubmit: submitTypedCommand
            )
            .padding(.horizontal, 24)
            .padding(.top, 12)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(commands.enumerated()), id: \.element.id) { index, command in
                        Button {
                            selectCommand(at: index)
                        } label: {
                            HStack(spacing: 14) {
                                Text("\(index + 1)")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(selectedIndex == index ? SenpaiTheme.ink : SenpaiTheme.accent)
                                    .frame(width: 25, height: 25)
                                    .background(selectedIndex == index ? SenpaiTheme.accent : Color.white.opacity(0.10), in: Circle())

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(command.text)
                                        .font(.system(.body, design: .monospaced).weight(.semibold))
                                        .foregroundStyle(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                    Text(command.description)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.62))
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                Image(systemName: index < correctCount && command.id == targetCommands[index].id ? "checkmark.circle.fill" : "line.3.horizontal")
                                    .foregroundStyle(index < correctCount && command.id == targetCommands[index].id ? SenpaiTheme.mint : .white.opacity(0.35))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(selectedIndex == index ? SenpaiTheme.accent.opacity(0.22) : Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(selectedIndex == index ? SenpaiTheme.accent : Color.white.opacity(0.10), lineWidth: selectedIndex == index ? 1.5 : 1))
                        }
                        .buttonStyle(.plain)
                        .disabled(isSolved)
                    }

                    HStack(spacing: 10) {
                        Image(systemName: isSolved ? "checkmark.seal.fill" : "arrow.left.arrow.right")
                            .foregroundStyle(isSolved ? SenpaiTheme.mint : SenpaiTheme.accent)
                        Text(feedback)
                            .font(.caption)
                            .foregroundStyle(isSolved ? SenpaiTheme.mint : .white.opacity(0.65))
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.black.opacity(0.28), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
        }
        .frame(maxWidth: 680)
        .frame(maxHeight: .infinity)
        .background(Color(red: 0.045, green: 0.06, blue: 0.10), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.18), lineWidth: 1))
        .shadow(color: .black.opacity(0.4), radius: 32, y: 18)
        .padding(12)
    }

    private func submitTypedCommand() {
        let trimmed = inputCommand.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return }
        
        if let idx = commands.firstIndex(where: { $0.text.lowercased().starts(with: trimmed) }) {
            selectCommand(at: idx)
            inputCommand = ""
        } else {
            feedback = "ไม่พบคำสั่ง '\(inputCommand)' ลองดูคำสั่งในรายการ"
            inputCommand = ""
        }
    }

    private func selectCommand(at index: Int) {
        guard !isSolved else { return }

        if let firstIndex = selectedIndex {
            guard firstIndex != index else {
                selectedIndex = nil
                feedback = "เลือกคำสั่ง 2 อันเพื่อสลับตำแหน่ง"
                return
            }

            commands.swapAt(firstIndex, index)
            selectedIndex = nil

            if commands.map(\.id) == targetCommands.map(\.id) {
                isSolved = true
                feedback = "ถูกต้อง — ลำดับคำสั่งครบแล้ว!"
                gameState.skills["git", default: 0] += isSecondTime ? 10 : 25
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    gameState.currentIndex += 1
                }
            } else if correctCount == commands.count {
                feedback = "เกือบแล้ว ตรวจตำแหน่งอีกครั้ง"
            } else {
                failedAttempts += 1
                feedback = failedAttempts > 2 ? "ยังไม่ถูก ลองคิดว่า command ไหนต้องทำก่อน" : "ยังไม่ตรง ลองสลับคู่ถัดไป"
            }
        } else {
            selectedIndex = index
            feedback = "เลือกคำสั่งอีก 1 ใบเพื่อสลับกับใบนี้"
        }
    }
}

struct TerminalInputRow: View {
    @Binding var inputCommand: String
    @FocusState.Binding var isInputFocused: Bool
    let onSubmit: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Text("$")
                .font(.system(.body, design: .monospaced).weight(.bold))
                .foregroundStyle(SenpaiTheme.mint)

            TextField("พิมพ์คำสั่ง git...", text: $inputCommand)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.white)
                .focused($isInputFocused)
                .onSubmit(onSubmit)

            if !inputCommand.isEmpty {
                Button(action: onSubmit) {
                    Text("RUN")
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(SenpaiTheme.mint, in: Capsule())
                        .foregroundStyle(SenpaiTheme.ink)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.4), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isInputFocused ? SenpaiTheme.mint : Color.white.opacity(0.15), lineWidth: 1))
    }
}
