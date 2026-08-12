import SwiftUI

struct SkillBarView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SkillRow(name: "Confidence", value: gameState.skills["confidence"] ?? 0, color: .orange)
            SkillRow(name: "Git", value: gameState.skills["git"] ?? 0, color: .purple)
            SkillRow(name: "AI", value: gameState.skills["ai"] ?? 0, color: .blue)
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(10)
    }
}

struct SkillRow: View {
    let name: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.white)
                .frame(width: 80, alignment: .leading)
                .font(.headline)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: min(CGFloat(value) / 100.0 * geometry.size.width, geometry.size.width), height: 20)
                        .cornerRadius(10)
                        .animation(.linear, value: value)
                }
            }
            .frame(height: 20)
            
            Text("\(min(value, 100))%")
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(width: 40, alignment: .trailing)
        }
    }
}
