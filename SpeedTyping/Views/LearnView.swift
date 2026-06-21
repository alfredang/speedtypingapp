import SwiftUI

/// The "Learn" tab: correct hand position, the finger-coloured keyboard,
/// a fingering legend, and tips for memorising key positions.
struct LearnView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    sectionTitle("Correct hand position", "hand.raised.fill")
                    handPositionCard

                    sectionTitle("The keyboard, by finger", "keyboard.fill")
                    VStack(alignment: .leading, spacing: 16) {
                        KeyboardView()
                        Text("Each key is coloured for the finger that should press it. The small bars under A S D F and J K L ; mark the home row — where your fingers rest.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                        Divider().overlay(Color.white.opacity(0.08))
                        FingerLegend()
                    }
                    .appCard(padding: 18)

                    sectionTitle("Tips to remember the keys", "lightbulb.fill")
                    ForEach(Library.tips) { tip in
                        tipRow(tip)
                    }
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Touch Typing Basics")
                .font(.largeTitle.bold())
                .foregroundStyle(Theme.ink)
            Text("Master the home row, learn which finger owns each key, then never look down again.")
                .font(.headline)
                .foregroundStyle(Theme.mutedInk)
        }
    }

    private func sectionTitle(_ text: String, _ symbol: String) -> some View {
        Label(text, systemImage: symbol)
            .font(.title2.bold())
            .foregroundStyle(Theme.ink)
            .padding(.top, 6)
    }

    private var handPositionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 24) {
                handGraphic(label: "LEFT HAND", keys: ["A", "S", "D", "F"], fingers: [.leftPinky, .leftRing, .leftMiddle, .leftIndex])
                Spacer()
                handGraphic(label: "RIGHT HAND", keys: ["J", "K", "L", ";"], fingers: [.rightIndex, .rightMiddle, .rightRing, .rightPinky])
            }
            Text("Rest eight fingers on the home row: left hand on **A S D F**, right hand on **J K L ;**. Both thumbs hover over the space bar. Feel for the ridges on **F** and **J** to anchor your hands without looking.")
                .font(.subheadline)
                .foregroundStyle(Theme.mutedInk)
        }
        .appCard(padding: 20)
    }

    private func handGraphic(label: String, keys: [String], fingers: [Finger]) -> some View {
        VStack(spacing: 10) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.mutedInk)
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(zip(keys, fingers)), id: \.0) { key, finger in
                    VStack(spacing: 6) {
                        Capsule()
                            .fill(finger.color)
                            .frame(width: 18, height: heightFor(finger))
                        Text(key)
                            .font(.headline.bold())
                            .foregroundStyle(Theme.ink)
                            .frame(width: 38, height: 38)
                            .background(finger.color.opacity(0.3),
                                        in: RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(finger.color, lineWidth: 2))
                    }
                }
            }
        }
    }

    // Visual finger-length variation for the little hand graphic.
    private func heightFor(_ finger: Finger) -> CGFloat {
        switch finger {
        case .leftMiddle, .rightMiddle: return 56
        case .leftRing, .rightRing:     return 48
        case .leftIndex, .rightIndex:   return 44
        default:                        return 36
        }
    }

    private func tipRow(_ tip: Tip) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: tip.symbol)
                .font(.title2)
                .foregroundStyle(Theme.primary)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text(tip.body)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard(padding: 16)
    }
}
