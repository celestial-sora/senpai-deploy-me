import SwiftUI

enum SenpaiTheme {
    static let ink = Color(red: 0.08, green: 0.10, blue: 0.17)
    static let panel = Color(red: 0.10, green: 0.12, blue: 0.20)
    static let accent = Color(red: 0.39, green: 0.80, blue: 1.00)
    static let violet = Color(red: 0.62, green: 0.48, blue: 1.00)
    static let mint = Color(red: 0.37, green: 0.93, blue: 0.76)
    static let gold = Color(red: 1.00, green: 0.76, blue: 0.35)
}

struct GlassPanel<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 24

    init(cornerRadius: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.28), radius: 24, y: 12)
    }
}

struct StatusDot: View {
    let color: Color

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .shadow(color: color.opacity(0.7), radius: 6)
    }
}
