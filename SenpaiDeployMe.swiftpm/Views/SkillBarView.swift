import SwiftUI

struct SkillBarView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("SKILL CHECK")
                    .font(.caption2.weight(.bold))
                    .tracking(1.1)
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
                Image(systemName: "chart.bar.fill")
                    .font(.caption)
                    .foregroundStyle(SenpaiTheme.accent)
            }
            SkillRow(name: "Git", value: gameState.skills["git"] ?? 0, color: SenpaiTheme.violet)
            SkillRow(name: "GitHub", value: gameState.skills["github"] ?? 0, color: SenpaiTheme.accent)
        }
        .padding(14)
        .background(Color.black.opacity(0.42), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.15), lineWidth: 1))
    }
}

struct SkillRow: View {
    let name: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .foregroundStyle(.white.opacity(0.78))
                .frame(width: 67, alignment: .leading)
                .font(.caption2.weight(.semibold))
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.14))
                        .frame(height: 7)
                    
                    Capsule().fill(color)
                        .frame(width: min(CGFloat(value) / 100.0 * geometry.size.width, geometry.size.width), height: 7)
                        .shadow(color: color.opacity(0.7), radius: 5)
                        .animation(.linear, value: value)
                }
            }
            .frame(height: 20)
            
            Text("\(min(value, 100))%")
                .foregroundColor(.white)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(width: 44, alignment: .trailing)
        }
    }
}
