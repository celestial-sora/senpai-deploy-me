import SwiftUI

struct DialogueView: View {
    @EnvironmentObject var gameState: GameState
    @State private var currentBackground: String = "bg_faculty"
    
    var currentLine: DialogueLine {
        script[gameState.currentIndex]
    }
    
    var body: some View {
        ZStack {
            // 1. Background
            Image(currentBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
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
            
            // 2. Main Content
            if currentLine.isTerminalStep {
                TerminalMiniGameView(isSecondTime: gameState.currentIndex > 10)
            } else {
                VStack {
                    // Skill Bar at top right
                    HStack {
                        Spacer()
                        SkillBarView()
                            .scaleEffect(0.8)
                            .padding(.top, 20)
                            .padding(.trailing, 20)
                    }
                    
                    Spacer()
                    
                    // Sprite
                    if let sprite = currentLine.sprite {
                        Image(sprite)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
                            .transition(.opacity)
                            .animation(.easeInOut, value: sprite)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    // Choices
                    if let choices = currentLine.choices {
                        VStack(spacing: 10) {
                            ForEach(choices) { choice in
                                Button(action: {
                                    handleChoice(choice)
                                }) {
                                    Text(choice.text)
                                        .font(.title3)
                                        .padding()
                                        .frame(maxWidth: 400)
                                        .background(Capsule().fill(Color(white: 0.2, opacity: 0.9)))
                                        .foregroundColor(.white)
                                        .overlay(Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1))
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
                    
                    // Dialogue Box
                    VStack(alignment: .leading, spacing: 5) {
                        if !currentLine.speaker.isEmpty {
                            Text(currentLine.speaker)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(Color.blue.opacity(0.8)))
                                .offset(x: 20, y: 15)
                                .zIndex(1)
                        }
                        
                        Text(currentLine.text)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(25)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Capsule().fill(Color(white: 0.1, opacity: 0.85)))
                            .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 2))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
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
