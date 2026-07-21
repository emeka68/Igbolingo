import SwiftUI

struct SettingsView: View {
    @AppStorage("claude_api_key") private var apiKey = ""
    @AppStorage("elevenlabs_api_key") private var elevenLabsKey = ""
    @AppStorage("onboarding_complete") private var onboardingComplete = false
    @AppStorage("learner_profile") private var profileRaw = ""
    @State private var appState = AppState.shared
    @State private var showClaudeKey = false
    @State private var showElevenKey = false

    var profile: LearnerProfile {
        LearnerProfile(rawValue: profileRaw) ?? .both
    }

    var body: some View {
        NavigationStack {
            Form {
                // Profile
                Section {
                    Picker("Who's learning?", selection: Binding(
                        get: { profile },
                        set: { profileRaw = $0.rawValue }
                    )) {
                        ForEach(LearnerProfile.allCases, id: \.self) { p in
                            Label(p.title, systemImage: "person").tag(p)
                        }
                    }

                    if profile == .both {
                        Toggle("Kid Mode", isOn: Binding(
                            get: { appState.isKidMode },
                            set: { appState.isKidMode = $0 }
                        ))
                        .tint(Color.igboGreen)
                    }
                } header: {
                    Text("Learner Profile")
                }

                // Stats
                let currentTitle = ProgressionEngine.currentTitle(
                    words: appState.wordsLearned,
                    lessons: appState.lessonsCompleted,
                    streak: appState.streakCount
                )
                Section("Your Title") {
                    HStack(spacing: 14) {
                        Text(currentTitle.emoji).font(.largeTitle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentTitle.igbo)
                                .font(.headline.bold())
                                .foregroundStyle(currentTitle.color)
                            Text(currentTitle.english)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("Level \(currentTitle.id + 1) of \(igboTitles.count)")
                            .font(.caption.bold())
                            .foregroundStyle(currentTitle.color)
                    }
                    .padding(.vertical, 4)
                }

                Section("Your Progress") {
                    LabeledContent("Day streak", value: "\(appState.streakCount) 🔥")
                    LabeledContent("Words learned", value: "\(appState.wordsLearned)")
                    LabeledContent("Lessons completed", value: "\(appState.lessonsCompleted)")
                    Button("Reset progress", role: .destructive) {
                        appState.streakCount = 0
                        appState.wordsLearned = 0
                        appState.lessonsCompleted = 0
                    }
                }

                // Claude API Key
                Section {
                    HStack {
                        if showClaudeKey {
                            TextField("sk-ant-…", text: $apiKey)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("sk-ant-…", text: $apiKey)
                        }
                        Button { showClaudeKey.toggle() } label: {
                            Image(systemName: showClaudeKey ? "eye.slash" : "eye").foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Claude API Key (required)")
                } footer: {
                    Text("Get your key from console.anthropic.com")
                }

                // ElevenLabs (optional)
                Section {
                    HStack {
                        if showElevenKey {
                            TextField("Optional…", text: $elevenLabsKey)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("Optional…", text: $elevenLabsKey)
                        }
                        Button { showElevenKey.toggle() } label: {
                            Image(systemName: showElevenKey ? "eye.slash" : "eye").foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("ElevenLabs API Key (optional)")
                } footer: {
                    Text("Adds higher-quality Igbo pronunciation. Get a key at elevenlabs.io.")
                }

                // About
                Section("About") {
                    LabeledContent("App", value: "Igbolingo")
                    LabeledContent("Version", value: "1.0")
                    LabeledContent("AI", value: "Claude \(AppModel.current)")
                }

                // Reset onboarding
                Section {
                    Button("Restart onboarding", role: .destructive) {
                        onboardingComplete = false
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

private enum AppModel {
    static let current = "claude-sonnet-4-6"
}
