import SwiftUI

/// Repetitive fingering drills — short patterns repeated to build muscle memory.
struct DrillsView: View {
    @State private var result: TypingResult?
    @State private var activeDrill: Drill?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Train each finger with short, repeated patterns. Keep your eyes on the screen and let the colours guide your hands.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)

                ForEach(Library.drills) { drill in
                    Button { activeDrill = drill } label: { drillRow(drill) }
                        .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(Theme.background)
        .navigationTitle("Fingering Drills")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $activeDrill) { drill in
            runner(for: drill)
        }
    }

    private func drillRow(_ drill: Drill) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "hand.tap.fill")
                .font(.title2)
                .foregroundStyle(Theme.highlight)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(drill.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text(drill.focus)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                Text(drill.pattern)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(Theme.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Text("×\(drill.repetitions)")
                .font(.headline.monospacedDigit())
                .foregroundStyle(Theme.primary)
        }
        .appCard(padding: 16)
    }

    @ViewBuilder
    private func runner(for drill: Drill) -> some View {
        let item = TypingItem(title: drill.title, difficulty: .basic, text: drill.fullText)
        if let result {
            ResultView(result: result,
                       onRetry: { self.result = nil },
                       onDone: { self.result = nil; self.activeDrill = nil })
        } else {
            NavigationStack {
                TypingSurface(item: item) { self.result = $0 }
                    .navigationTitle(drill.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { activeDrill = nil }
                        }
                    }
            }
        }
    }
}
