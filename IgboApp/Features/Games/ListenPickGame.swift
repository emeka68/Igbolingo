import SwiftUI

struct ListenPickGame: View {
    let words: [WordPair]
    @Environment(\.dismiss) private var dismiss

    @State private var gameWords: [WordPair] = []
    @State private var currentWord: WordPair?
    @State private var options: [WordPair] = []
    @State private var selected: WordPair?
    @State private var questionIndex = 0
    @State private var score = 0
    @State private var isFinished = false
    @State private var hasPlayed = false

    private let totalQuestions = 8

    var body: some View {
        VStack(spacing: 28) {
            // Progress
            ProgressView(value: Double(questionIndex), total: Double(totalQuestions))
                .tint(Color.igboGreen)
                .padding(.horizontal)

            Text("\(questionIndex + 1) of \(totalQuestions)")
                .font(.subheadline).foregroundStyle(.secondary)

            if isFinished {
                GameResultView(score: score, total: totalQuestions, onReplay: startGame) { dismiss() }
            } else if let current = currentWord {
                VStack(spacing: 24) {
                    // Listen button
                    Button {
                        hasPlayed = true
                        AudioService.shared.speak(current.igbo)
                    } label: {
                        VStack(spacing: 12) {
                            if let emoji = current.emoji {
                                Text(emoji).font(.system(size: hasPlayed ? 56 : 72))
                            } else {
                                Image(systemName: "speaker.wave.3.fill")
                                    .font(.system(size: hasPlayed ? 48 : 72))
                                    .foregroundStyle(Color.igboGreen)
                            }

                            Text(hasPlayed ? current.igbo : "Tap to listen")
                                .font(hasPlayed ? .title.bold() : .headline)
                                .foregroundStyle(hasPlayed ? Color.igboGreen : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .background(Color.igboGreen.opacity(0.08), in: RoundedRectangle(cornerRadius: 24))
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.igboGreen.opacity(0.3), lineWidth: 2))
                    }
                    .buttonStyle(.plain)

                    Text("What does this mean in English?")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    // Options
                    VStack(spacing: 12) {
                        ForEach(options) { opt in
                            ListenAnswerButton(
                                word: opt,
                                isSelected: selected?.english == opt.english,
                                isCorrect: opt.english == current.english,
                                hasAnswered: selected != nil
                            ) {
                                guard selected == nil else { return }
                                selected = opt
                                if opt.english == current.english { score += 1 }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { advance() }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
        .background(Color.igboBackground)
        .navigationTitle("Listen & Pick 👂")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startGame() }
    }

    private func advance() {
        if questionIndex + 1 >= totalQuestions {
            isFinished = true
        } else {
            questionIndex += 1
            loadQuestion()
        }
    }

    private func loadQuestion() {
        hasPlayed = false
        selected = nil
        guard questionIndex < gameWords.count else { return }
        let current = gameWords[questionIndex]
        currentWord = current
        var distractors = words.filter { $0.english != current.english }.shuffled().prefix(3).map { $0 }
        options = (distractors + [current]).shuffled()

        // Auto-play after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            hasPlayed = true
            AudioService.shared.speak(current.igbo)
        }
    }

    private func startGame() {
        gameWords = Array(words.shuffled().prefix(totalQuestions))
        questionIndex = 0
        score = 0
        isFinished = false
        loadQuestion()
    }
}

struct ListenAnswerButton: View {
    let word: WordPair
    let isSelected: Bool
    let isCorrect: Bool
    let hasAnswered: Bool
    let action: () -> Void

    var bg: Color {
        if !hasAnswered { return Color.igboCard }
        if isCorrect { return Color.igboGreen.opacity(0.2) }
        if isSelected { return Color.igboRed.opacity(0.2) }
        return Color.igboCard
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let emoji = word.emoji { Text(emoji) }
                Text(word.english).font(.headline)
                Spacer()
                if hasAnswered {
                    if isCorrect { Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.igboGreen) }
                    else if isSelected { Image(systemName: "xmark.circle.fill").foregroundStyle(Color.igboRed) }
                }
            }
            .padding()
            .background(bg, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(
                isCorrect && hasAnswered ? Color.igboGreen : isSelected && hasAnswered ? Color.igboRed : Color.clear,
                lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .animation(.spring, value: hasAnswered)
    }
}
