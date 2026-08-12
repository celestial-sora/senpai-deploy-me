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
                VStack {
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
                        SkillBarView()
                            .frame(width: min(220, max(140, geometry.size.width * 0.30)))
                    }
                    .padding(.horizontal, min(24, geometry.size.width * 0.035))
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Sprite
                    if let sprite = currentLine.sprite {
                        ResourceImage(name: sprite, folder: "Sprites")
                            .scaledToFit()
                            .frame(maxHeight: currentLine.choices != nil ? min(260, geometry.size.height * 0.28) : min(430, geometry.size.height * 0.42))
                            .transition(.opacity)
                            .animation(.easeInOut, value: sprite)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    if let choices = currentLine.choices {
                        VStack(spacing: 12) {
                            ForEach(Array(choices.enumerated()), id: \.element.id) { index, choice in
                                Button(action: {
                                    handleChoice(choice)
                                }) {
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
                                    .frame(maxWidth: 520)
                                    .background(Color.white.opacity(0.13), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.18), lineWidth: 1))
                                }
                            }
                        }
                        .padding(.bottom, 20)
                        .zIndex(2)
                    } else {
                        // Invisible area to advance text by tapping anywhere else
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
                    .background(Color.black.opacity(0.66), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.2), lineWidth: 1))
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
}
