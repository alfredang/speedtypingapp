import SwiftUI

/// The shared typing experience: a colour-coded target passage, a hidden capture field,
/// live speed/accuracy stats, and a finger-coloured keyboard that highlights the next key.
struct TypingSurface: View {
    let item: TypingItem
    var passingWPM: Int? = nil
    var onFinish: (TypingResult) -> Void

    @StateObject private var engine: TypingEngine
    @FocusState private var focused: Bool

    init(item: TypingItem, passingWPM: Int? = nil, onFinish: @escaping (TypingResult) -> Void) {
        self.item = item
        self.passingWPM = passingWPM
        self.onFinish = onFinish
        _engine = StateObject(wrappedValue: TypingEngine(target: item.text))
    }

    private var nextChar: Character? {
        let chars = Array(engine.target)
        guard engine.cursor < chars.count else { return nil }
        return chars[engine.cursor]
    }

    var body: some View {
        VStack(spacing: 18) {
            statBar
            ProgressView(value: engine.progress)
                .tint(Theme.secondary)

            passageView
                .appCard(padding: 22)
                .onTapGesture { focused = true }

            // Hidden capture field — drives the engine.
            TextField("", text: $engine.typed, axis: .vertical)
                .focused($focused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapable)
                .opacity(0.02)
                .frame(height: 1)
                .accessibilityLabel("Typing input")

            KeyboardView(highlight: nextChar)

            HStack {
                Button {
                    engine.reset()
                    focused = true
                } label: {
                    Label("Restart", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
                .tint(Theme.mutedInk)

                Spacer()

                if !focused && !engine.isFinished {
                    Label("Tap here, then start typing", systemImage: "keyboard")
                        .font(.subheadline)
                        .foregroundStyle(Theme.highlight)
                }
            }
        }
        .padding(20)
        .background(Theme.background)
        .onAppear { focused = true }
        .onChange(of: engine.isFinished) { _, finished in
            if finished {
                onFinish(engine.makeResult(title: item.title, passingWPM: passingWPM))
            }
        }
    }

    // MARK: - Stat bar

    private var statBar: some View {
        HStack(spacing: 12) {
            StatChip(label: "WPM", value: "\(engine.wpm)", tint: Theme.primary, big: true)
            StatChip(label: "CPM", value: "\(engine.cpm)", tint: Theme.secondary, big: true)
            StatChip(label: "Accuracy", value: "\(Int((engine.accuracy * 100).rounded()))%",
                     tint: engine.accuracy >= 0.9 ? Theme.secondary : Theme.highlight)
            StatChip(label: "Time", value: timeString(engine.elapsed), tint: Theme.mutedInk)
            if let p = passingWPM {
                StatChip(label: "Target", value: "\(p) WPM", tint: Theme.highlight)
            }
        }
    }

    private func timeString(_ t: TimeInterval) -> String {
        let s = Int(t)
        return String(format: "%d:%02d", s / 60, s % 60)
    }

    // MARK: - Coloured passage

    private var passageView: some View {
        Text(attributedPassage)
            .font(.system(size: 26, weight: .regular, design: .monospaced))
            .lineSpacing(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.disabled)
    }

    private var attributedPassage: AttributedString {
        let target = Array(engine.target)
        let typed = engine.typedChars
        var result = AttributedString()
        for i in target.indices {
            var ch = AttributedString(String(target[i]))
            if i < typed.count {
                let correct = typed[i] == target[i]
                ch.foregroundColor = correct ? Theme.secondary : Theme.danger
                if !correct { ch.backgroundColor = Theme.danger.opacity(0.25) }
            } else if i == typed.count {
                ch.foregroundColor = Theme.background
                ch.backgroundColor = Theme.highlight
            } else {
                ch.foregroundColor = Theme.mutedInk
            }
            result += ch
        }
        return result
    }
}

struct StatChip: View {
    let label: String
    let value: String
    var tint: Color = Theme.primary
    var big: Bool = false

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(big ? .title2.bold().monospacedDigit() : .headline.monospacedDigit())
                .foregroundStyle(tint)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.mutedInk)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
