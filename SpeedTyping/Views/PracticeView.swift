import SwiftUI

/// The "Practice" tab: a library of articles from basic to advanced, plus
/// repetitive fingering drills. Tapping any item opens an ungraded typing run.
struct PracticeView: View {
    @State private var result: TypingResult?
    @State private var activeItem: TypingItem?

    private var grouped: [(Difficulty, [TypingItem])] {
        Difficulty.allCases.compactMap { diff in
            let items = Library.practice.filter { $0.difficulty == diff }
            return items.isEmpty ? nil : (diff, items)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Practice Sessions")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.ink)
                    Text("Work through articles from basic to advanced. No pass mark here — just build speed and accuracy.")
                        .font(.headline)
                        .foregroundStyle(Theme.mutedInk)

                    NavigationLink {
                        DrillsView()
                    } label: {
                        drillsBanner
                    }
                    .buttonStyle(.plain)

                    ForEach(grouped, id: \.0) { diff, items in
                        VStack(alignment: .leading, spacing: 12) {
                            Label(diff.rawValue, systemImage: diff.icon)
                                .font(.title2.bold())
                                .foregroundStyle(diff.color)
                            ForEach(items) { item in
                                Button { activeItem = item } label: {
                                    PassageRow(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $activeItem) { item in
                runner(for: item)
            }
        }
    }

    private var drillsBanner: some View {
        HStack(spacing: 16) {
            Image(systemName: "repeat.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(Theme.highlight)
            VStack(alignment: .leading, spacing: 4) {
                Text("Repetitive Fingering Drills")
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text("Short, repeated patterns to train muscle memory finger by finger.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard(padding: 18)
    }

    @ViewBuilder
    private func runner(for item: TypingItem) -> some View {
        if let result {
            ResultView(result: result,
                       onRetry: { self.result = nil },
                       onDone: { self.result = nil; self.activeItem = nil })
        } else {
            NavigationStack {
                TypingSurface(item: item) { self.result = $0 }
                    .navigationTitle(item.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { activeItem = nil }
                        }
                    }
            }
        }
    }
}

struct PassageRow: View {
    let item: TypingItem
    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text(item.text)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.lengthLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(item.difficulty.color)
                Text("\(item.wordCount) words")
                    .font(.caption2)
                    .foregroundStyle(Theme.mutedInk)
            }
        }
        .appCard(padding: 16)
    }
}
