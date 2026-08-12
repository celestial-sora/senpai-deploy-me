import SwiftUI

struct EndingView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            SenpaiTheme.ink
                .ignoresSafeArea()
            ResourceImage(name: "bg_ending", folder: "Backgrounds")
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.32).ignoresSafeArea()

            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack(spacing: 24) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 54))
                                .foregroundStyle(SenpaiTheme.mint)
                                .shadow(color: SenpaiTheme.mint.opacity(0.6), radius: 18)
                            
                            VStack(spacing: 8) {
                                Text("DEPLOYMENT COMPLETE")
                                    .font(.caption.weight(.bold))
                                    .tracking(2)
                                    .foregroundStyle(SenpaiTheme.mint)
                                Text("จบหลักสูตร Senpai Deploy Me!")
                                    .font(.system(.title, design: .default, weight: .bold))
                                    .foregroundStyle(.white)
                                    .minimumScaleFactor(0.85)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                Text("เว็บแรกของน้อง live อยู่บน internet แล้ว")
                                    .font(.body)
                                    .foregroundStyle(.white.opacity(0.72))
                                    .multilineTextAlignment(.center)
                            }
                            
                            SkillBarView()
                                .frame(maxWidth: 400)
                            
                            replayButton
                        }
                        .padding(28)
                        .frame(maxWidth: min(520, geometry.size.width - 40))
                        .background(Color(red: 0.08, green: 0.10, blue: 0.16).opacity(0.88), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.22), lineWidth: 1))
                        .shadow(color: .black.opacity(0.4), radius: 30, y: 15)
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                    .padding(.vertical, 24)
                }
            }
        }
    }

    @ViewBuilder
    private var replayButton: some View {
        let label = Label("เล่นอีกครั้ง", systemImage: "arrow.counterclockwise")
            .font(.headline.weight(.bold))
            .padding(.horizontal, 28)
            .padding(.vertical, 14)

        if #available(iOS 26.0, macOS 26.0, *) {
            Button(action: gameState.reset) { label }
                .foregroundStyle(SenpaiTheme.ink)
                .buttonStyle(.glassProminent)
                .tint(SenpaiTheme.accent)
        } else {
            Button(action: gameState.reset) {
                label
                    .background(SenpaiTheme.accent, in: Capsule())
                    .foregroundStyle(SenpaiTheme.ink)
            }
            .buttonStyle(.plain)
        }
    }
}
