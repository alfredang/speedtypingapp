import SwiftUI

/// A QWERTY keyboard rendered with each key tinted by the finger that should press it.
/// Pass `highlight` to glow the next key the user needs to hit.
struct KeyboardView: View {
    var highlight: Character? = nil
    var showFingerColors: Bool = true

    private var highlightLabel: String? {
        guard let h = highlight else { return nil }
        if h == " " { return "Space" }
        return h.uppercased()
    }

    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 6
            // Number row has the most units; size keys off it.
            let unit = (geo.size.width - spacing * 14) / 15.6
            VStack(spacing: spacing) {
                ForEach(Array(KeyboardLayout.rows.enumerated()), id: \.offset) { _, row in
                    HStack(spacing: spacing) {
                        ForEach(row) { key in
                            keyView(key, unit: unit)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: row.count == 1 ? .center : .center)
                }
            }
        }
        .aspectRatio(2.9, contentMode: .fit)
    }

    @ViewBuilder
    private func keyView(_ key: Key, unit: CGFloat) -> some View {
        let isHighlit = highlightLabel != nil && key.label.uppercased() == highlightLabel
        let base = showFingerColors ? key.finger.color : Theme.surface
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(base.opacity(isHighlit ? 1.0 : 0.28))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isHighlit ? Theme.highlight : Color.white.opacity(0.08),
                            lineWidth: isHighlit ? 3 : 1)
            )
            .overlay(alignment: .center) {
                Text(key.label)
                    .font(.system(size: max(11, unit * 0.42), weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.ink)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.horizontal, 2)
            }
            .overlay(alignment: .bottom) {
                if key.isHomeKey {
                    Capsule()
                        .fill(Theme.ink.opacity(0.6))
                        .frame(width: unit * 0.3, height: 3)
                        .padding(.bottom, 4)
                }
            }
            .frame(width: unit * key.width, height: unit)
            .scaleEffect(isHighlit ? 1.04 : 1.0)
            .animation(.easeOut(duration: 0.12), value: isHighlit)
    }
}

/// Compact legend mapping finger colours to names.
struct FingerLegend: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], alignment: .leading, spacing: 10) {
            ForEach(Finger.allCases) { finger in
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(finger.color)
                        .frame(width: 16, height: 16)
                    Text(finger.name)
                        .font(.subheadline)
                        .foregroundStyle(Theme.mutedInk)
                    if let home = finger.homeKey {
                        Text(home)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.ink)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Theme.surface, in: Capsule())
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }
}
