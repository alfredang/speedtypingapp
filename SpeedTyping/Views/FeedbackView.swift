import SwiftUI

/// Feedback tab — Title + Message fields and a "Send via WhatsApp" button
/// that opens wa.me/6588666375 with the composed text.
struct FeedbackView: View {
    private let whatsAppNumber = "6588666375"   // +65 8866 6375, no "+"/spaces
    @State private var title = ""
    @State private var message = ""

    private var canSend: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Feedback")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.ink)
                    Text("Found a bug, or have an idea to make SpeedTyping better? Send us a note.")
                        .font(.headline)
                        .foregroundStyle(Theme.mutedInk)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("TITLE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        TextField("Short summary", text: $title)
                            .textFieldStyle(.plain)
                            .padding(14)
                            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))

                        Text("MESSAGE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Your message…")
                                    .foregroundStyle(Theme.mutedInk)
                                    .padding(18)
                            }
                            TextEditor(text: $message)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 180)
                                .padding(8)
                        }
                        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .appCard(padding: 18)

                    Button(action: send) {
                        Label("Send via WhatsApp", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.secondary)
                    .disabled(!canSend)
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func send() {
        var text = ""
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let m = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if !t.isEmpty { text += "*\(t)*\n" }
        text += m
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = "wa.me"
        comps.path = "/\(whatsAppNumber)"
        comps.queryItems = [URLQueryItem(name: "text", value: text)]
        if let url = comps.url { UIApplication.shared.open(url) }
    }
}
