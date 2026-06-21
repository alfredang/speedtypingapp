import SwiftUI

/// About tab — app card, developer card with website link, and version row.
struct AboutView: View {
    private let developerURL = URL(string: "https://www.tertiaryinfotech.com")!

    private var versionString: String {
        let i = Bundle.main.infoDictionary
        let s = i?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = i?["CFBundleVersion"] as? String ?? "1"
        return "\(s) (\(b))"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("About")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.ink)

                    // App card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 14) {
                            Image(systemName: "keyboard.fill")
                                .font(.system(size: 34))
                                .foregroundStyle(Theme.primary)
                            Text("SpeedTyping")
                                .font(.title2.bold())
                                .foregroundStyle(Theme.ink)
                        }
                        Text("Learn to type fast and accurately on your iPad. SpeedTyping teaches correct hand position and fingering, then builds your speed through graded practice articles, repetitive drills, and timed tests measured in words and characters per minute.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                    }
                    .appCard(padding: 18)

                    // Developer card
                    Text("DEVELOPER").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                    VStack(alignment: .leading, spacing: 0) {
                        Label("Tertiary Infotech Academy Pte Ltd", systemImage: "building.2.fill")
                            .foregroundStyle(Theme.ink)
                            .padding(.vertical, 14)
                        Divider().overlay(Color.white.opacity(0.08))
                        Link(destination: developerURL) {
                            Label("tertiaryinfotech.com", systemImage: "globe")
                                .foregroundStyle(Theme.secondary)
                        }
                        .padding(.vertical, 14)
                    }
                    .appCard(padding: 18)

                    // Version row
                    HStack {
                        Text("Version").foregroundStyle(Theme.ink)
                        Spacer()
                        Text(versionString).foregroundStyle(Theme.mutedInk)
                    }
                    .appCard(padding: 18)
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
