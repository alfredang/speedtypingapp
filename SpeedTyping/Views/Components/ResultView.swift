import SwiftUI

struct ResultView: View {
    let result: TypingResult
    var onRetry: () -> Void
    var onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 0)

            if let passed = result.passed {
                Image(systemName: passed ? "checkmark.seal.fill" : "xmark.seal.fill")
                    .font(.system(size: 84))
                    .foregroundStyle(passed ? Theme.secondary : Theme.danger)
                Text(passed ? "Passed!" : "Not yet")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Theme.ink)
                if let p = result.passingWPM {
                    Text(passed
                         ? "You beat the \(p) WPM target with at least 90% accuracy."
                         : "You need \(p) WPM and 90% accuracy to pass. Keep practising!")
                        .font(.headline)
                        .foregroundStyle(Theme.mutedInk)
                        .multilineTextAlignment(.center)
                }
            } else {
                Image(systemName: "flag.checkered")
                    .font(.system(size: 84))
                    .foregroundStyle(Theme.primary)
                Text("Session complete")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Theme.ink)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                StatChip(label: "Words / min", value: "\(result.wpm)", tint: Theme.primary, big: true)
                StatChip(label: "Chars / min", value: "\(result.cpm)", tint: Theme.secondary, big: true)
                StatChip(label: "Accuracy", value: "\(Int((result.accuracy * 100).rounded()))%",
                         tint: result.accuracy >= 0.9 ? Theme.secondary : Theme.highlight, big: true)
                StatChip(label: "Errors", value: "\(result.errors)", tint: Theme.danger, big: true)
            }
            .frame(maxWidth: 520)

            HStack(spacing: 14) {
                Button(action: onRetry) {
                    Label("Try Again", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.primary)

                Button(action: onDone) {
                    Label("Done", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(Theme.mutedInk)
            }
            .frame(maxWidth: 520)

            Spacer(minLength: 0)
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}
