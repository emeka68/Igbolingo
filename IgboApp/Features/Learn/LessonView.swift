import SwiftUI

struct LessonView: View {
    let topic: LearnTopic

    @State private var words: [WordPair] = []
    @State private var culturalNote: String?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showFlashcards = false
    @State private var showQuiz = false
    @State private var showGames = false
    @State private var appState = AppState.shared

    var isKidMode: Bool { appState.isKidMode }

    var body: some View {
        Group {
            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                    Text(isKidMode ? "Getting your lesson ready! 🎉" : "Preparing your lesson…")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage {
                ContentUnavailableView(
                    "Could not load lesson",
                    systemImage: "wifi.slash",
                    description: Text(errorMessage)
                )
            } else {
                LessonContentView(
                    words: words,
                    culturalNote: culturalNote,
                    isKidMode: isKidMode,
                    onFlashcards: { showFlashcards = true },
                    onQuiz: { showQuiz = true },
                    onGames: { showGames = true }
                )
            }
        }
        .navigationTitle(isKidMode ? "\(topic.emoji) \(topic.title)" : topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.igboBackground)
        .task { await loadLesson() }
        .fullScreenCover(isPresented: $showFlashcards) {
            FlashcardView(words: words, isKidMode: isKidMode)
        }
        .fullScreenCover(isPresented: $showQuiz) {
            QuizView(words: words, isKidMode: isKidMode)
        }
        .fullScreenCover(isPresented: $showGames) {
            GamesMenuView(words: words)
        }
    }

    private func loadLesson() async {
        isLoading = true
        defer { isLoading = false }

        // Use offline bank first (instant, no API cost)
        if let offline = OfflineWordBank.words(for: topic.offlineKey) {
            words = offline
            // Still ask Claude for a cultural note
            Task {
                culturalNote = try? await ClaudeService.shared.culturalNote(for: topic.topic)
            }
        } else {
            // Fallback: generate via Claude
            do {
                let level: LearningLevel = isKidMode ? .child : .adult
                let lesson = try await ClaudeService.shared.generateLesson(topic: topic.topic, level: level)
                words = lesson.words
                culturalNote = lesson.culturalNote
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct LessonContentView: View {
    let words: [WordPair]
    let culturalNote: String?
    let isKidMode: Bool
    let onFlashcards: () -> Void
    let onQuiz: () -> Void
    let onGames: () -> Void
    @State private var appState = AppState.shared

    var body: some View {
        ScrollView {
            VStack(spacing: isKidMode ? 24 : 20) {
                // Kid mode encouragement header
                if isKidMode {
                    HStack {
                        Text("Let's learn \(words.count) words today! 🌟")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.igboGold.opacity(0.2), in: RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                }

                // Cultural note
                if let note = culturalNote {
                    HStack(alignment: .top, spacing: 10) {
                        Text("💡").font(.title2)
                        Text(note)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.igboGold.opacity(0.15), in: RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                }

                // Word list
                VStack(spacing: isKidMode ? 14 : 10) {
                    ForEach(words) { word in
                        if isKidMode {
                            KidWordCard(word: word)
                        } else {
                            WordCard(word: word, audioService: AudioService.shared)
                        }
                    }
                }
                .padding(.horizontal)

                // Practice buttons
                VStack(spacing: 12) {
                    Button(action: onFlashcards) {
                        Label(isKidMode ? "Play Flashcards! 🃏" : "Practice Flashcards",
                              systemImage: "rectangle.on.rectangle")
                            .frame(maxWidth: .infinity)
                            .padding(isKidMode ? 18 : 14)
                            .background(Color.igboGreen)
                            .foregroundStyle(.white)
                            .font(isKidMode ? .headline : .body)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Button(action: onQuiz) {
                        Label(isKidMode ? "Take the Quiz! ✏️" : "Take Quiz",
                              systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                            .padding(isKidMode ? 18 : 14)
                            .background(Color.igboCard)
                            .foregroundStyle(Color.igboGreen)
                            .font(isKidMode ? .headline : .body)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.igboGreen, lineWidth: 1.5))
                    }

                    Button(action: onGames) {
                        Label(isKidMode ? "Play Mini Games! 🎮" : "Mini Games",
                              systemImage: "gamecontroller.fill")
                            .frame(maxWidth: .infinity)
                            .padding(isKidMode ? 18 : 14)
                            .background(Color.igboGold.opacity(0.15))
                            .foregroundStyle(Color.igboGold)
                            .font(isKidMode ? .headline : .body)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.igboGold.opacity(0.5), lineWidth: 1.5))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top)
        }
        .onDisappear {
            appState.wordsLearned += words.count
            appState.lessonsCompleted += 1
        }
    }
}

struct KidWordCard: View {
    let word: WordPair

    var body: some View {
        HStack(spacing: 16) {
            if let emoji = word.emoji {
                Text(emoji).font(.system(size: 48))
                    .frame(width: 60)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(word.igbo)
                    .font(.title2.bold())
                    .foregroundStyle(Color.igboGreen)
                Text(word.english)
                    .font(.headline)
                Text("Say it: \(word.pronunciation)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                AudioService.shared.speak(word.igbo)
            } label: {
                Image(systemName: "speaker.wave.3.fill")
                    .font(.title2)
                    .foregroundStyle(Color.igboGreen)
                    .padding(12)
                    .background(Color.igboGreen.opacity(0.12), in: Circle())
            }
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.igboGreen.opacity(0.2), lineWidth: 1.5))
    }
}

struct WordCard: View {
    let word: WordPair
    let audioService: AudioService

    var body: some View {
        HStack {
            if let emoji = word.emoji {
                Text(emoji).font(.title)
                    .frame(width: 44)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(word.igbo)
                    .font(.headline)
                    .foregroundStyle(Color.igboGreen)
                Text(word.english)
                    .font(.subheadline)
                Text(word.pronunciation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 12) {
                SaveWordButton(word: word)

                Button {
                    audioService.speak(word.igbo)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundStyle(Color.igboGreen)
                }
            }
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 14))
    }
}

struct SaveWordButton: View {
    let word: WordPair
    @State private var appState = AppState.shared
    @State private var srStore = SpacedRepetitionStore.shared

    var body: some View {
        Button {
            withAnimation(.spring) {
                appState.toggleSaved(word)
                // Enroll in spaced repetition when saving; unenroll when unsaving
                if appState.isSaved(word) {
                    srStore.enroll(word)
                } else {
                    srStore.unenroll(wordID: word.english)
                }
            }
        } label: {
            Image(systemName: appState.isSaved(word) ? "bookmark.fill" : "bookmark")
                .foregroundStyle(appState.isSaved(word) ? Color.igboGold : .secondary)
        }
    }
}
