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
    @State private var checkState: CheckState = .idle
    @State private var incorrectIDs: Set<UUID> = []

    // Custom drag state
    @State private var draggingID: UUID? = nil
    @State private var dragTranslation: CGFloat = 0
    @State private var originalDragIndex: Int = 0
    @State private var currentDragIndex: Int = 0

    private enum CheckState { case idle, incorrect, solved }

    private let cardHeight: CGFloat = 76
    private let cardSpacing: CGFloat = 10
    private var slotHeight: CGFloat { cardHeight + cardSpacing }

    private static let commandBank = [
        GitCommand(command: "git init",                hint: "เริ่มต้นสมุดบันทึกของโปรเจกต์",    correctOrder: 1),
        GitCommand(command: "git status",              hint: "เช็คว่าตอนนี้มีอะไรเปลี่ยนไปบ้าง",  correctOrder: 2),
        GitCommand(command: "git add .",               hint: "เลือกไฟล์ที่จะเซฟ",                correctOrder: 3),
        GitCommand(command: "git commit -m \"...\"",   hint: "เซฟจุดนี้ พร้อมโน้ต",              correctOrder: 4),
        GitCommand(command: "git remote add origin <url>", hint: "ผูกกับที่เก็บบน GitHub",      correctOrder: 5),
        GitCommand(command: "git push origin main",    hint: "ส่งของที่เซฟไว้ขึ้นไปเก็บจริง",   correctOrder: 6)
    ]

    private var correctCount: Int {
        commands.enumerated().filter { $0.element.correctOrder == $0.offset + 1 }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.horizontal, 24)
                .padding(.top, 22)

            progressView
                .padding(.horizontal, 24)
                .padding(.top, 14)

            dragSortArea
                .padding(.horizontal, 16)
                .padding(.top, 12)

            footerView
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
        }
        .background(
            Color(red: 0.045, green: 0.06, blue: 0.10),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.18), lineWidth: 1))
        .shadow(color: .black.opacity(0.4), radius: 32, y: 18)
        .padding(12)
        .frame(maxWidth: 680, maxHeight: .infinity)
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("GIT DRAG-SORT", systemImage: "arrow.up.arrow.down")
                    .font(.caption.weight(.bold)).tracking(1.3)
                    .foregroundStyle(.white.opacity(0.85))
                Spacer()
                Text("6 คำสั่ง")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(SenpaiTheme.mint)
            }
            Text("เรียงลำดับการทำงานของ Git")
                .font(.title2.weight(.bold)).foregroundStyle(.white)
            Text("กดค้างที่การ์ดแล้วลากสลับตำแหน่ง กด ‘ตรวจคำตอบ’ เมื่อพร้อม")
                .font(.subheadline).foregroundStyle(.white.opacity(0.55))
        }
    }

    // MARK: - Progress Bar

    private var progressView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("ตำแหน่งถูกต้อง")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.55))
                Spacer()
                Text("\(correctCount) / 6")
                    .font(.caption.weight(.bold).monospacedDigit())
                    .foregroundStyle(correctCount == 6 ? SenpaiTheme.mint : SenpaiTheme.accent)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: correctCount)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.09))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: correctCount == 6
                                    ? [SenpaiTheme.mint, SenpaiTheme.mint.opacity(0.7)]
                                    : [SenpaiTheme.accent, SenpaiTheme.accent.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: correctCount == 0
                               ? 0
                               : max(20, geo.size.width * CGFloat(correctCount) / 6))
                        .animation(.spring(response: 0.45, dampingFraction: 0.75), value: correctCount)
                }
            }
            .frame(height: 7)

            // Step dots
            HStack(spacing: 0) {
                ForEach(0..<6, id: \.self) { i in
                    let isCorrect = i < commands.count && commands[i].correctOrder == i + 1
                    Circle()
                        .fill(isCorrect ? SenpaiTheme.mint : Color.white.opacity(0.18))
                        .frame(width: 6, height: 6)
                        .scaleEffect(isCorrect ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isCorrect)
                    if i < 5 {
                        Spacer()
                    }
                }
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Custom Drag Sort Area

    private var dragSortArea: some View {
        ZStack(alignment: .top) {
            // Static slots
            VStack(spacing: cardSpacing) {
                ForEach(Array(commands.enumerated()), id: \.element.id) { index, command in
                    let isDraggingThis = draggingID == command.id
                    commandCard(command, position: index + 1, state: cardState(for: command, at: index))
                        .opacity(isDraggingThis ? 0 : 1)
                        .gesture(makeDragGesture(for: command, at: index))
                }
            }

            // Floating card that follows the finger
            if let dragID = draggingID,
               let _ = commands.firstIndex(where: { $0.id == dragID }) {
                let command = commands[currentDragIndex]
                let floatY = CGFloat(originalDragIndex) * slotHeight + dragTranslation

                commandCard(command, position: currentDragIndex + 1, state: .dragging)
                    .scaleEffect(1.04)
                    .shadow(color: SenpaiTheme.accent.opacity(0.5), radius: 20, y: 12)
                    .shadow(color: .black.opacity(0.45), radius: 10, y: 6)
                    .offset(y: floatY)
                    .zIndex(99)
                    .allowsHitTesting(false)
                    .transition(.identity)
            }
        }
    }

    // MARK: - Card State

    private enum CardDisplayState { case normal, wrong, correct, dragging }

    private func cardState(for command: GitCommand, at index: Int) -> CardDisplayState {
        if incorrectIDs.contains(command.id) { return .wrong }
        if checkState == .solved && command.correctOrder == index + 1 { return .correct }
        return .normal
    }

    private func commandCard(_ command: GitCommand, position: Int, state: CardDisplayState) -> some View {
        HStack(spacing: 12) {
            // Position badge
            ZStack {
                Circle()
                    .fill(badgeColor(for: state))
                Text("\(position)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(state == .dragging ? SenpaiTheme.ink : .white)
            }
            .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(command.command)
                    .font(.system(.body, design: .monospaced).weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(command.hint)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }
            Spacer()

            // Drag handle
            Image(systemName: "line.3.horizontal")
                .font(.body.weight(.regular))
                .foregroundStyle(.white.opacity(state == .dragging ? 0.8 : 0.35))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(height: cardHeight)
        .background(cardBackground(for: state))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(cardBorder(for: state), lineWidth: state == .dragging ? 1.5 : 1)
        )
    }

    private func badgeColor(for state: CardDisplayState) -> Color {
        switch state {
        case .normal:   return SenpaiTheme.accent.opacity(0.85)
        case .wrong:    return Color.red.opacity(0.85)
        case .correct:  return SenpaiTheme.mint
        case .dragging: return SenpaiTheme.accent
        }
    }

    private func cardBackground(for state: CardDisplayState) -> some ShapeStyle {
        switch state {
        case .normal:   return AnyShapeStyle(Color.white.opacity(0.07))
        case .wrong:    return AnyShapeStyle(Color.red.opacity(0.13))
        case .correct:  return AnyShapeStyle(SenpaiTheme.mint.opacity(0.10))
        case .dragging: return AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.14, green: 0.18, blue: 0.28), Color(red: 0.10, green: 0.13, blue: 0.22)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        }
    }

    private func cardBorder(for state: CardDisplayState) -> Color {
        switch state {
        case .normal:   return Color.white.opacity(0.12)
        case .wrong:    return Color.red.opacity(0.65)
        case .correct:  return SenpaiTheme.mint.opacity(0.55)
        case .dragging: return SenpaiTheme.accent.opacity(0.8)
        }
    }

    // MARK: - Drag Gesture

    private func makeDragGesture(for command: GitCommand, at index: Int) -> some Gesture {
        DragGesture(minimumDistance: 6)
            .onChanged { value in
                if draggingID == nil {
                    withAnimation(.none) {
                        draggingID = command.id
                        originalDragIndex = index
                        currentDragIndex = index
                        dragTranslation = value.translation.height
                    }
                } else if draggingID == command.id {
                    dragTranslation = value.translation.height

                    // Compute target index from original position + total drag
                    let rawTarget = originalDragIndex + Int((value.translation.height / slotHeight).rounded())
                    let targetIndex = max(0, min(commands.count - 1, rawTarget))

                    if targetIndex != currentDragIndex {
                        withAnimation(.interactiveSpring(response: 0.22, dampingFraction: 0.72)) {
                            let from = currentDragIndex
                            let to = targetIndex > currentDragIndex ? targetIndex + 1 : targetIndex
                            commands.move(fromOffsets: IndexSet(integer: from), toOffset: to)
                            currentDragIndex = targetIndex
                        }
                        if checkState != .solved {
                            incorrectIDs = []
                            checkState = .idle
                        }
                    }
                }
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
                    draggingID = nil
                    dragTranslation = 0
                    originalDragIndex = 0
                    currentDragIndex = 0
                }
            }
    }

    // MARK: - Footer

    private var footerView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: feedbackIcon)
                    .foregroundStyle(feedbackIconColor)
                    .font(.caption.weight(.semibold))
                Text(feedbackText)
                    .font(.caption)
                    .foregroundStyle(checkState == .incorrect ? .red.opacity(0.85) : .white.opacity(0.65))
                Spacer()
            }

            Button(action: checkAnswer) {
                HStack(spacing: 8) {
                    if checkState == .solved {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    Text(checkState == .solved ? "เรียบร้อยแล้ว" : "ตรวจคำตอบ")
                        .font(.headline.weight(.bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    checkState == .solved ? SenpaiTheme.mint : SenpaiTheme.accent,
                    in: RoundedRectangle(cornerRadius: 14)
                )
                .foregroundStyle(SenpaiTheme.ink)
            }
            .disabled(checkState == .solved)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: checkState)
        }
    }

    private var feedbackIcon: String {
        switch checkState {
        case .idle:      return "hand.draw"
        case .incorrect: return "xmark.circle"
        case .solved:    return "checkmark.seal.fill"
        }
    }

    private var feedbackIconColor: Color {
        switch checkState {
        case .idle:      return SenpaiTheme.accent
        case .incorrect: return .red
        case .solved:    return SenpaiTheme.mint
        }
    }

    private var feedbackText: String {
        switch checkState {
        case .idle:      return "กดค้างที่ไอคอน ≡ แล้วลากเพื่อสลับตำแหน่ง"
        case .incorrect: return "ยังมีบางอันผิดตำแหน่งอยู่นะ ลองลากใหม่ได้เลย"
        case .solved:    return "ถูกต้องทั้งหมด! เก่งมาก 🎉"
        }
    }

    // MARK: - Check Answer

    private func checkAnswer() {
        incorrectIDs = Set(commands.enumerated().compactMap { index, command in
            command.correctOrder == index + 1 ? nil : command.id
        })
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            if incorrectIDs.isEmpty {
                checkState = .solved
                gameState.skills["git", default: 0] = 100
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    gameState.currentIndex += 1
                }
            } else {
                checkState = .incorrect
            }
        }
    }
}
