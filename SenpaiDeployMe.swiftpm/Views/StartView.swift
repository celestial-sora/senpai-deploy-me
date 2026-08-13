import SwiftUI

struct StartView: View {
    @EnvironmentObject var gameState: GameState
    @State private var name = ""
    @FocusState private var nameFocused: Bool

    private var canStart: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        GeometryReader { geometry in
        ZStack {
            SenpaiTheme.ink
                .ignoresSafeArea()
            ResourceImage(name: "bg_faculty", folder: "Backgrounds")
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.82)
                .overlay(Color.black.opacity(0.52).ignoresSafeArea().allowsHitTesting(false))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundStyle(SenpaiTheme.accent)
                        .shadow(color: SenpaiTheme.accent.opacity(0.7), radius: 16)

                    VStack(spacing: 8) {
                        Text("SENPAI GIT IN 3 MINUTES")
                            .font(.caption.weight(.bold))
                            .tracking(2.4)
                            .foregroundStyle(SenpaiTheme.accent)
                        Text("พร้อมใช้ Git หรือยัง?")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        Text("เรียน Git และ GitHub แบบสั้น ใช้ได้จริง")
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.72))
                            .multilineTextAlignment(.center)
                    }

                    GlassPanel(cornerRadius: 22) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ชื่อน้องคืออะไร?")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                            
                            HStack {
                                TextField("รุ่นพี่จะเรียกคุณว่าอะไรดีน้าาา", text: $name)
                                    .font(.title3.weight(.medium))
                                    .foregroundStyle(.white)
                                    .textFieldStyle(.plain)
                                    .focused($nameFocused)
                                    #if os(iOS)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled(true)
                                    .submitLabel(.continue)
                                    #endif
                                    .onSubmit(startGame)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(nameFocused ? SenpaiTheme.accent : Color.white.opacity(0.18), lineWidth: nameFocused ? 2 : 1))

                            startButton
                        }
                        .padding(20)
                    }
                    .frame(maxWidth: min(460, geometry.size.width - 32))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, minHeight: max(420, geometry.size.height - 32))
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func startGame() {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedName.isEmpty else { return }
        gameState.playerName = cleanedName
    }

    @ViewBuilder
    private var startButton: some View {
        let label = HStack {
            Text("เริ่มเกม")
            Spacer()
            Image(systemName: "arrow.right")
        }
        .font(.headline.weight(.bold))
        .padding(.horizontal, 18)
        .padding(.vertical, 15)

        if #available(iOS 26.0, macOS 26.0, *) {
            Button(action: startGame) { label }
                .foregroundStyle(canStart ? SenpaiTheme.ink : .white.opacity(0.45))
                .buttonStyle(.glassProminent)
                .tint(SenpaiTheme.accent)
                .disabled(!canStart)
        } else {
            Button(action: startGame) {
                label
                    .foregroundStyle(canStart ? SenpaiTheme.ink : .white.opacity(0.45))
                    .background(canStart ? SenpaiTheme.accent : Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(!canStart)
        }
    }
}
