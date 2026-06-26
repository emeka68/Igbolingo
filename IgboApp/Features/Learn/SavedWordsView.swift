import SwiftUI

struct SavedWordsView: View {
    @State private var appState = AppState.shared
    @State private var srStore = SpacedRepetitionStore.shared
    @State private var showFlashcards = false
    @State private var showReview = false
    @State private var searchText = ""

    var allSavedWords: [WordPair] {
        let ids = appState.savedWordIDs
        return OfflineWordBank.all.values.flatMap { $0 }.filter { ids.contains($0.english) }
    }

    var filtered: [WordPair] {
        if searchText.isEmpty { return allSavedWords }
        return allSavedWords.filter {
            $0.english.localizedCaseInsensitiveContains(searchText) ||
            $0.igbo.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if allSavedWords.isEmpty {
                    ContentUnavailableView(
                        "No saved words yet",
                        systemImage: "bookmark.slash",
                        description: Text("Tap the bookmark icon on any word to save it here.")
                    )
                } else {
                    List {
                        // Review due banner
                        if srStore.dueCount > 0 {
                            Section {
                                Button {
                                    showReview = true
                                } label: {
                                    HStack(spacing: 14) {
                                        ZStack {
                                            Circle().fill(Color.igboGreen).frame(width: 44, height: 44)
                                            Image(systemName: "brain.head.profile")
                                                .foregroundStyle(.white)
                                        }
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("\(srStore.dueCount) word\(srStore.dueCount == 1 ? "" : "s") due for review")
                                                .font(.headline)
                                                .foregroundStyle(Color.igboGreen)
                                            Text("Tap to start your daily review session")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        ForEach(filtered) { word in
                            SavedWordRow(word: word)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { i in
                                appState.toggleSaved(filtered[i])
                                srStore.unenroll(wordID: filtered[i].english)
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search saved words")
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Saved Words (\(allSavedWords.count))")
            .toolbar {
                if !allSavedWords.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showFlashcards = true
                        } label: {
                            Label("Practise", systemImage: "rectangle.on.rectangle")
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showReview) {
                ReviewView()
            }
            .fullScreenCover(isPresented: $showFlashcards) {
                FlashcardView(words: allSavedWords, isKidMode: appState.isKidMode)
            }
        }
    }
}

struct SavedWordRow: View {
    let word: WordPair
    @State private var appState = AppState.shared

    var body: some View {
        HStack(spacing: 12) {
            if let emoji = word.emoji {
                Text(emoji).font(.title2)
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

            HStack(spacing: 14) {
                Button {
                    AudioService.shared.speak(word.igbo)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundStyle(Color.igboGreen)
                }

                Button {
                    withAnimation { appState.toggleSaved(word) }
                } label: {
                    Image(systemName: "bookmark.fill")
                        .foregroundStyle(Color.igboGold)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
