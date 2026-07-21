import SwiftUI

struct ReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var store = SpacedRepetitionStore.shared
    @State private var dueWords: [WordReviewRecord] = []
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var isFinished = false
    @State private var easyCount = 0
    @State private var hardCount = 0
    @State private var showCelebration = false

    var current: WordReviewRecord? {
        guard currentIndex < dueWords.count else { return nil }
        return dueWords[currentIndex]
    }

    var body: some View {
        NavigationStack {
            Group {
                if isFinished {
                    ReviewCompleteView(
                        easyCount: easyCount,
                        hardCount: hardCount,
                        onDone: { dismiss() }
                    )
                } else if dueWords.isEmpty {
                    ContentUnavailableView(
                        "All caught up! ✅",
                        systemImage: "checkmark.seal.fill",
                        description: Text("No words are due for review right now.\nSave words in lessons and come back tomorrow.")
                    )
                } else if let word = current {
                    VStack(spacing: 0) {
                        // Progress
                        VStack(spacing: 6) {
                            ProgressView(value: Double(currentIndex), total: Double(dueWords.count))
                                .tint(Color.igboGreen)
                            Text("\(currentIndex + 1) of \(dueWords.count) due")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()

                        Spacer()

                        // Card
                        ReviewCard(record: word, isFlipped: isFlipped)
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.4)) { isFlipped.toggle() }
                                if isFlipped { AudioService.shared.speak(word.igbo) }
                            }
                            .padding(.horizontal)

                        Spacer()

                        // Rating buttons — only show after flip
                        if isFlipped {
                            VStack(spacing: 12) {
                                Text("How well did you know it?")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                HStack(spacing: 16) {
                                    RatingButton(
                                        label: "Hard",
                                        sublabel: "Review tomorrow",
                                        icon: "xmark.circle.fill",
                                        color: Color.igboRed
                                    ) {
                                        rate(easy: false)
                                    }

                                    RatingButton(
                                        label: "Easy",
                                        sublabel: nextIntervalLabel(for: word, easy: true),
                                        icon: "checkmark.circle.fill",
                                        color: Color.igboGreen
                                    ) {
                                        rate(easy: true)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            Text("Tap card to reveal Igbo")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 40)
                        }
                    }
                    .animation(.spring, value: isFlipped)
                }
            }
            .background(Color.igboBackground)
            .navigationTitle("Daily Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                dueWords = store.dueWords
            }
        }
    }

    private func nextIntervalLabel(for record: WordReviewRecord, easy: Bool) -> String {
        if !easy { return "Review tomorrow" }
        let nextIdx = min(record.intervalIndex + 1, 6)
        let days = [1, 3, 7, 14, 30, 60, 120][nextIdx]
        return days == 1 ? "Review in 1 day" : "Review in \(days) days"
    }

    private func rate(easy: Bool) {
        guard let word = current else { return }
        if easy {
            store.markEasy(wordID: word.wordID)
            easyCount += 1
        } else {
            store.markHard(wordID: word.wordID)
            hardCount += 1
        }

        withAnimation(.spring) {
            isFlipped = false
            if currentIndex + 1 >= dueWords.count {
                isFinished = true
            } else {
                currentIndex += 1
            }
        }
    }
}

struct ReviewCard: View {
    let record: WordReviewRecord
    let isFlipped: Bool

    var body: some View {
        ZStack {
            // Back — Igbo
            VStack(spacing: 16) {
                if let emoji = record.emoji { Text(emoji).font(.system(size: 56)) }
                Text(record.igbo)
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.igboGreen)
                    .multilineTextAlignment(.center)
                Text(record.pronunciation)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Button {
                    AudioService.shared.speak(record.igbo)
                } label: {
                    Label("Listen", systemImage: "speaker.wave.2.fill")
                        .foregroundStyle(Color.igboGreen)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .padding()
            .background(Color.igboGreen.opacity(0.08), in: RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.igboGreen.opacity(0.4), lineWidth: 1.5))
            .rotation3DEffect(.degrees(isFlipped ? 0 : -90), axis: (1, 0, 0))
            .opacity(isFlipped ? 1 : 0)

            // Front — English
            VStack(spacing: 16) {
                if let emoji = record.emoji { Text(emoji).font(.system(size: 56)) }
                Text(record.english)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                Text("Tap to reveal Igbo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .padding()
            .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 24))
            .rotation3DEffect(.degrees(isFlipped ? 90 : 0), axis: (1, 0, 0))
            .opacity(isFlipped ? 0 : 1)
        }
        .animation(.spring(duration: 0.4), value: isFlipped)
    }
}

struct RatingButton: View {
    let label: String
    let sublabel: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                    Text(label).fontWeight(.semibold)
                }
                .foregroundStyle(color)
                Text(sublabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.3), lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}

struct ReviewCompleteView: View {
    let easyCount: Int
    let hardCount: Int
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("🎉").font(.system(size: 72))
            Text("Review Complete!")
                .font(.largeTitle.bold())

            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(easyCount)").font(.system(size: 40, weight: .bold)).foregroundStyle(Color.igboGreen)
                    Text("Easy").foregroundStyle(.secondary)
                }
                VStack(spacing: 4) {
                    Text("\(hardCount)").font(.system(size: 40, weight: .bold)).foregroundStyle(Color.igboRed)
                    Text("Hard").foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))

            Text(hardCount == 0
                 ? "Perfect! All words solid. 🏆"
                 : "Hard words will come back tomorrow. Keep at it!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Done", action: onDone)
                .buttonStyle(.borderedProminent)
                .tint(Color.igboGreen)
                .padding(.top)
            Spacer()
        }
        .padding()
    }
}
