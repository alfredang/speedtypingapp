import SwiftUI

struct MainTabView: View {
    // Allows screenshot automation to open a specific tab via a launch argument
    // e.g. `-uiTab 2`. Defaults to the Learn tab.
    @State private var selection: Int = {
        // `-uiTab N` lands in the NSArgumentDomain; integer(forKey:) coerces it. 0 = Learn.
        let idx = UserDefaults.standard.integer(forKey: "uiTab")
        return (0...4).contains(idx) ? idx : 0
    }()

    var body: some View {
        TabView(selection: $selection) {
            LearnView()
                .tabItem { Label("Learn", systemImage: "graduationcap.fill") }
                .tag(0)
            PracticeView()
                .tabItem { Label("Practice", systemImage: "keyboard.fill") }
                .tag(1)
            TestView()
                .tabItem { Label("Test", systemImage: "checkmark.seal.fill") }
                .tag(2)
            FeedbackView()
                .tabItem { Label("Feedback", systemImage: "bubble.left.and.bubble.right.fill") }
                .tag(3)
            AboutView()
                .tabItem { Label("About", systemImage: "info.circle.fill") }
                .tag(4)
        }
        .tint(Theme.accent)
        .preferredColorScheme(.dark)
    }
}
