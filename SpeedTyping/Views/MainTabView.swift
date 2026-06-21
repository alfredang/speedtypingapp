import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            LearnView()
                .tabItem { Label("Learn", systemImage: "graduationcap.fill") }
            PracticeView()
                .tabItem { Label("Practice", systemImage: "keyboard.fill") }
            TestView()
                .tabItem { Label("Test", systemImage: "checkmark.seal.fill") }
            FeedbackView()
                .tabItem { Label("Feedback", systemImage: "bubble.left.and.bubble.right.fill") }
            AboutView()
                .tabItem { Label("About", systemImage: "info.circle.fill") }
        }
        .tint(Theme.accent)
        .preferredColorScheme(.dark)
    }
}
