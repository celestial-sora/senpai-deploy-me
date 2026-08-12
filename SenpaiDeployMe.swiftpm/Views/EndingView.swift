import SwiftUI

struct EndingView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            Image("bg_ending")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("จบหลักสูตร Senpai Deploy Me!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(15)
                
                SkillBarView()
                    .frame(maxWidth: 400)
                
                Button(action: {
                    gameState.reset()
                }) {
                    Text("เล่นอีกครั้ง")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
