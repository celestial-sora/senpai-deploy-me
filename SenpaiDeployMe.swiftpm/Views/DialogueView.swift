import SwiftUI

struct DialogueView: View {
    @EnvironmentObject var gameState: GameState
    @State private var currentBackground: String = "bg_faculty"
    
    var currentLine: DialogueLine {
        script[gameState.currentIndex]
    }
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
            SenpaiTheme.ink
                .ignoresSafeArea()
            ResourceImage(name: currentBackground, folder: "Backgrounds")
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .ignoresSafeArea()
                .overlay {
                    LinearGradient(
                        colors: [.black.opacity(0.10), .black.opacity(0.04), .black.opacity(0.76)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                }
                .onChange(of: gameState.currentIndex) { _ in
                    if let newBg = currentLine.background {
                        currentBackground = newBg
                    }
                }
                .onAppear {
                    if let newBg = currentLine.background {
                        currentBackground = newBg
                    }
                }
            
            if currentLine.isTerminalStep {
                TerminalMiniGameView(isSecondTime: gameState.currentIndex > 10)
                    .frame(maxWidth: min(680, geometry.size.width - 24), maxHeight: min(580, geometry.size.height - 24))
            } else {
                // Character Sprite Layer (Anchored to bottom, behind UI)
                if let sprite = currentLine.sprite {
                    VStack {
                        Spacer()
                        ResourceImage(name: sprite, folder: "Sprites")
                            .scaledToFit()
                            .frame(maxHeight: max(380, geometry.size.height * 0.72))
                            .offset(y: 40) // Anchor down slightly so character sits on bottom frame
                            .transition(.opacity)
                            .animation(.easeInOut, value: sprite)
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                }

                // Header Bar & Top Controls Layer
                VStack {
                    VStack(spacing: 8) {
                        HStack {
                            if geometry.size.width > 620 {
                                Label("SENPAI DEPLOY ME", systemImage: "sparkles")
                                    .font(.caption.weight(.bold))
                                    .tracking(1.4)
                                    .foregroundStyle(.white.opacity(0.9))
                            } else {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                            Spacer()
                            Text("บทที่ \(chapterNumber)  /  5")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.75))
                            if geometry.size.width >= 500 {
                                SkillBarView()
                                    .frame(width: min(220, max(140, geometry.size.width * 0.30)))
                            }
                        }
                        if geometry.size.width < 500 {
                            SkillBarView()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.horizontal, min(24, geometry.size.width * 0.035))
                    .padding(.top, 10)
                    
                    Spacer()
                }
                
                // Dialogue Box & Interactive Choices Layer
                VStack {
                    Spacer()
                    
                    if let choices = currentLine.choices {
                        Group {
                            if #available(iOS 26.0, macOS 26.0, *) {
                                GlassEffectContainer(spacing: 12) {
                                    choiceList(choices)
                                }
                                .padding(.bottom, 16)
                            } else {
                                choiceList(choices)
                                    .padding(.bottom, 16)
                            }
                        }
                        .zIndex(2)
                    } else {
                        // Tap anywhere outside choices to advance dialogue
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                advanceLine()
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        if !currentLine.speaker.isEmpty {
                            HStack(spacing: 8) {
                                StatusDot(color: currentLine.speaker == "AI" ? SenpaiTheme.mint : SenpaiTheme.accent)
                                Text(currentLine.speaker.uppercased())
                                    .font(.caption.weight(.bold))
                                    .tracking(1.2)
                            }
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal, 18)
                            .padding(.top, 16)
                        }
                        
                        Text(currentLine.text)
                            .font(.system(.title3, design: .default, weight: .medium))
                            .foregroundStyle(.white.opacity(0.96))
                            .lineSpacing(5)
                            .minimumScaleFactor(0.78)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.clear)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
                    .background(Color.black.opacity(0.78), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.22), lineWidth: 1))
                    .padding(.horizontal, 20)
                    .padding(.bottom, min(22, geometry.size.height * 0.025))
                    .allowsHitTesting(currentLine.choices == nil)
                    .onTapGesture {
                        if currentLine.choices == nil {
                            advanceLine()
                        }
                    }
                }
            }
        }
        }
        .ignoresSafeArea()
    }

    private var chapterNumber: Int {
        switch gameState.currentIndex {
        case 0...3: return 1
        case 4...7: return 2
        case 8...11: return 3
        case 12...15: return 4
        default: return 5
        }
    }
    
    func advanceLine() {
        if let autoEffect = currentLine.autoSkillEffect {
            for (skill, effect) in autoEffect {
                gameState.skills[skill, default: 0] += effect
            }
        }
        
        if gameState.currentIndex == script.count - 1 {
            gameState.isEnded = true
        } else {
            if let jump = currentLine.jumpIndex {
                gameState.currentIndex = jump
            } else {
                gameState.currentIndex += 1
            }
        }
    }
    
    func handleChoice(_ choice: Choice) {
        for (skill, effect) in choice.skillEffect {
            gameState.skills[skill, default: 0] += effect
        }
        gameState.currentIndex = choice.nextIndex
    }

    @ViewBuilder
    private func choiceList(_ choices: [Choice]) -> some View {
        VStack(spacing: 12) {
            ForEach(Array(choices.enumerated()), id: \.element.id) { index, choice in
                choiceButton(choice, index: index)
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func choiceButton(_ choice: Choice, index: Int) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Button(action: { handleChoice(choice) }) {
                choiceLabel(choice, index: index)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: 520)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        } else {
            Button(action: { handleChoice(choice) }) {
                choiceLabel(choice, index: index)
                    .background(Color(red: 0.08, green: 0.10, blue: 0.16).opacity(0.85), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2), lineWidth: 1))
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: 520)
        }
    }

    private func choiceLabel(_ choice: Choice, index: Int) -> some View {
        HStack(spacing: 14) {
            Text("0\(index + 1)")
                .font(.caption.weight(.bold))
                .foregroundStyle(SenpaiTheme.accent)
            Text(choice.text)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            Spacer()
            Image(systemName: "arrow.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.55))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
    }
}
