import SwiftUI

struct ContentView: View {
    @AppStorage("onboarding_complete") private var onboardingComplete = false

    var body: some View {
        if onboardingComplete {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    @State private var appState = AppState.shared
    @State private var srStore = SpacedRepetitionStore.shared

    var body: some View {
        TabView {
            TranslatorView()
                .tabItem { Label("Translate", systemImage: "globe") }

            LearnTabView()
                .tabItem { Label("Learn", systemImage: "book.fill") }

            CultureView()
                .tabItem { Label("Culture", systemImage: "theatermasks.fill") }

            SavedWordsView()
                .tabItem { Label("Saved", systemImage: "bookmark.fill") }
                .badge(srStore.dueCount > 0 ? srStore.dueCount : 0)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(Color.igboGreen)
    }
}

// Groups Learn + Phrases into a single nav destination
struct LearnTabView: View {
    var body: some View {
        NavigationStack {
            LearnView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            PhraseBuilderView()
                        } label: {
                            Label("Phrases", systemImage: "text.bubble.fill")
                        }
                    }
                }
        }
    }
}
