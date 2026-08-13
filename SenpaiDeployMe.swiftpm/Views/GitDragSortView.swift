import SwiftUI

struct GitCommand: Identifiable, Equatable {
    let id = UUID()
    let command: String
    let hint: String
    let correctOrder: Int
}

struct GitDragSortView: View {
    @EnvironmentObject var gameState: GameState
    @State private var commands = GitDragSortView.commandBank.shuffled()
    @State private var showOnboarding = true
    @State private var checkState: CheckState = .idle
    @State private var incorrectIDs: Set<UUID> = []

    private enum CheckState { case idle, incorrect, solved }

    private static let commandBank = [
        GitCommand(command: "git init", hint: "เริ่มต้นสมุดบันทึกของโปรเจกต์", correctOrder: 1),
        GitCommand(command: "git status", hint: "เช็คว่าตอนนี้มีอะไรเปลี่ยนไปบ้าง", correctOrder: 2),
        GitCommand(command: "git add .", hint: "เลือกไฟล์ที่จะเซฟ", correctOrder: 3),
        GitCommand(command: "git commit -m \"...\"", hint: "เซฟจุดนี้ พร้อมโน้ต", correctOrder: 4),
        GitCommand(command: "git remote add origin <url>", hint: "ผูกกับที่เก็บบน GitHub", correctOrder: 5),
        GitCommand(command: "git push origin main", hint: "ส่งของที่เซฟไว้ขึ้นไปเก็บจริง", correctOrder: 6)
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Label("GIT DRAG-SORT", systemImage: "arrow.up.arrow.down")
                        .font(.caption.weight(.bold)).tracking(1.3)
                        .foregroundStyle(.white.opacity(0.85))
                    Spacer()
                    Text("6 คำสั่ง")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(SenpaiTheme.mint)
                }
                .padding(.horizontal, 24).padding(.top, 22)

                Text("เรียงลำดับการทำงานของ Git")
                    .font(.title2.weight(.bold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24).padding(.top, 8)

                Text("ลากการ์ดสลับตำแหน่ง แล้วกดตรวจคำตอบเมื่อพร้อม")
                    .font(.subheadline).foregroundStyle(.white.opacity(0.62))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24).padding(.top, 4)

                List {
                    ForEach(Array(commands.enumerated()), id: \.element.id) { index, command in
                        commandCard(command, position: index + 1)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                    }
                    .onMove(perform: move)
                }
                .listStyle(.plain)
                #if os(iOS)
                .environment(\.editMode, .constant(.active))
                #endif
                .scrollContentBackground(.hidden)

                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: checkState == .solved ? "checkmark.seal.fill" : "info.circle")
                            .foregroundStyle(checkState == .solved ? SenpaiTheme.mint : SenpaiTheme.accent)
                        Text(feedbackText).font(.caption)
                            .foregroundStyle(checkState == .incorrect ? .red.opacity(0.9) : .white.opacity(0.72))
                        Spacer()
                    }
                    Button(action: checkAnswer) {
                        Text(checkState == .solved ? "เรียบร้อยแล้ว" : "ตรวจคำตอบ")
                            .font(.headline.weight(.bold)).frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(checkState == .solved ? SenpaiTheme.mint : SenpaiTheme.accent, in: RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(SenpaiTheme.ink)
                    }
                    .disabled(checkState == .solved)
                }
                .padding(.horizontal, 24).padding(.vertical, 14)
            }
            .background(Color(red: 0.045, green: 0.06, blue: 0.10), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.18), lineWidth: 1))
            .shadow(color: .black.opacity(0.4), radius: 32, y: 18)
            .padding(12)

            if showOnboarding { onboardingBanner }
        }
        .frame(maxWidth: 680, maxHeight: .infinity)
    }

    private func commandCard(_ command: GitCommand, position: Int) -> some View {
        let isWrong = incorrectIDs.contains(command.id)
        return HStack(spacing: 12) {
            Text("\(position)").font(.caption.weight(.bold))
                .foregroundStyle(.white).frame(width: 28, height: 28)
                .background(isWrong ? Color.red.opacity(0.8) : SenpaiTheme.accent.opacity(0.8), in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(command.command).font(.system(.body, design: .monospaced).weight(.semibold))
                    .foregroundStyle(.white).lineLimit(1).minimumScaleFactor(0.65)
                Text(command.hint).font(.caption).foregroundStyle(.white.opacity(0.62))
            }
            Spacer()
            Image(systemName: "line.3.horizontal").foregroundStyle(.white.opacity(0.5))
        }
        .padding(.horizontal, 14).padding(.vertical, 13)
        .background(isWrong ? Color.red.opacity(0.18) : Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(isWrong ? Color.red.opacity(0.8) : Color.white.opacity(0.12), lineWidth: 1))
    }

    private var feedbackText: String {
        switch checkState {
        case .idle: return "ลากการ์ดจากปุ่มสามขีดเพื่อสลับตำแหน่ง"
        case .incorrect: return "ยังมีบางอันผิดตำแหน่งอยู่นะ ลองลากใหม่ได้เลย"
        case .solved: return "ถูกต้อง! ลำดับ Git ครบแล้ว"
        }
    }

    private var onboardingBanner: some View {
        VStack(spacing: 14) {
            Image(systemName: "hand.draw.fill").font(.system(size: 34)).foregroundStyle(SenpaiTheme.accent)
            Text("วิธีเล่น").font(.title3.weight(.bold)).foregroundStyle(.white)
            Text("ลากการ์ดคำสั่งสลับตำแหน่งกัน ให้เรียงตามลำดับที่ Senpai อธิบาย\nกด “ตรวจคำตอบ” เมื่อคิดว่าเรียงถูกแล้ว ผิดแล้วลองใหม่ได้เรื่อยๆ")
                .font(.body).multilineTextAlignment(.center).foregroundStyle(.white.opacity(0.78))
            Button("เข้าใจแล้ว") { showOnboarding = false }
                .font(.headline.weight(.bold)).padding(.horizontal, 24).padding(.vertical, 11)
                .background(SenpaiTheme.accent, in: Capsule()).foregroundStyle(SenpaiTheme.ink)
        }
        .padding(24).frame(maxWidth: 440).background(Color(red: 0.08, green: 0.10, blue: 0.16).opacity(0.98), in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.2), lineWidth: 1))
        .shadow(color: .black.opacity(0.5), radius: 24, y: 12).padding(28)
    }

    private func move(from source: IndexSet, to destination: Int) {
        guard checkState != .solved else { return }
        commands.move(fromOffsets: source, toOffset: destination)
        incorrectIDs = []
        checkState = .idle
    }

    private func checkAnswer() {
        incorrectIDs = Set(commands.enumerated().compactMap { index, command in
            command.correctOrder == index + 1 ? nil : command.id
        })
        if incorrectIDs.isEmpty {
            checkState = .solved
            gameState.skills["git", default: 0] = 100
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { gameState.currentIndex += 1 }
        } else {
            checkState = .incorrect
        }
    }
}
