import SwiftUI

/// The "Test" tab: graded passages with a pass/fail verdict based on the
/// admin-configurable passing speed (WPM) and a 90% accuracy floor.
struct TestView: View {
    @AppStorage("passingWPM") private var passingWPM: Int = 40
    @State private var result: TypingResult?
    @State private var activeItem: TypingItem?
    @State private var showAdmin = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Typing Tests")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.ink)

                    passMarkCard

                    ForEach(Library.tests) { item in
                        Button { activeItem = item } label: {
                            TestRow(item: item, passingWPM: passingWPM)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdmin = true } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .tint(Theme.mutedInk)
                }
            }
            .sheet(isPresented: $showAdmin) { AdminSettingsView() }
            .fullScreenCover(item: $activeItem) { item in
                runner(for: item)
            }
        }
    }

    private var passMarkCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "speedometer")
                .font(.system(size: 36))
                .foregroundStyle(Theme.primary)
            VStack(alignment: .leading, spacing: 4) {
                Text("Passing speed: \(passingWPM) WPM")
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text("Beat this speed with at least 90% accuracy to pass. Tap the gear to change it (admin).")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
            }
            Spacer()
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
                TypingSurface(item: item, passingWPM: passingWPM) { self.result = $0 }
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

struct TestRow: View {
    let item: TypingItem
    let passingWPM: Int
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.difficulty.icon)
                .font(.title)
                .foregroundStyle(item.difficulty.color)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text("\(item.wordCount) words · \(item.difficulty.rawValue) · pass at \(passingWPM) WPM")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard(padding: 16)
    }
}

/// Admin panel — passcode-gated configuration of the passing speed.
struct AdminSettingsView: View {
    @AppStorage("passingWPM") private var passingWPM: Int = 40
    @AppStorage("adminPasscode") private var adminPasscode: String = "2468"
    @Environment(\.dismiss) private var dismiss

    @State private var unlocked = false
    @State private var entered = ""
    @State private var newPasscode = ""

    var body: some View {
        NavigationStack {
            Form {
                if unlocked {
                    Section("Passing speed") {
                        Stepper(value: $passingWPM, in: 10...120, step: 5) {
                            Text("\(passingWPM) WPM")
                                .font(.headline)
                        }
                        Text("Students must reach this words-per-minute speed (with ≥90% accuracy) to pass any test.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Section("Admin passcode") {
                        SecureField("New passcode", text: $newPasscode)
                            .keyboardType(.numberPad)
                        Button("Update passcode") {
                            if !newPasscode.isEmpty { adminPasscode = newPasscode; newPasscode = "" }
                        }
                        .disabled(newPasscode.isEmpty)
                    }
                } else {
                    Section("Admin access") {
                        SecureField("Enter admin passcode", text: $entered)
                            .keyboardType(.numberPad)
                        Button("Unlock") {
                            unlocked = (entered == adminPasscode)
                            entered = ""
                        }
                        Text("Default passcode is 2468. Change it once unlocked.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Admin Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
