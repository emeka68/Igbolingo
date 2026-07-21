import SwiftUI

struct FillBlankQuestion: Identifiable {
    let id = UUID()
    let phrase: WordPair          // full phrase
    let blankedIgbo: String       // Igbo with one word replaced by "___"
    let missingWord: String       // the word that was removed
    let options: [String]         // 4 choices including the correct one
}

struct FillBlankGame: View {
    let words: [WordPair]
    @Environment(\.dismiss) private var dismiss

    @State private var questions: [FillBlankQuestion] = []
    @State private var currentIndex = 0
    @State private var selected: String?
    @State private var score = 0
    @State private var isFinished = false

    private let totalQ = 7

    var currentQ: FillBlankQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: Double(currentIndex), total: Double(totalQ))
                .tint(Color.igboGreen)
                .padding(.horizontal)

            Text("\(currentIndex + 1) of \(totalQ)")
                .font(.subheadline).foregroundStyle(.secondary)

            if isFinished {
                GameResultView(score: score, total: totalQ, onReplay: startGame) { dismiss() }
            } else if let q = currentQ {
                VStack(spacing: 20) {
                    // English phrase for context
                    VStack(spacing: 6) {
                        Text("Complete the Igbo phrase:").font(.subheadline).foregroundStyle(.secondary)

                        // English hint
                        Text(q.phrase.english)
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.igboGold.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
                    }

                    // Blanked phrase
                    Text(q.blankedIgbo)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.igboGreen)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.igboGreen.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                    // Listen to full phrase
                    Button {
                        AudioService.shared.speak(q.phrase.igbo)
                    } label: {
                        Label("Hear full phrase", systemImage: "speaker.wave.2.fill")
                            .font(.subheadline)
                            .foregroundStyle(Color.igboGreen)
                    }

                    // Options
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(q.options, id: \.self) { opt in
                            BlankOptionButton(
                                text: opt,
                                isSelected: selected == opt,
                                isCorrect: opt == q.missingWord,
                                hasAnswered: selected != nil
                            ) {
                                guard selected == nil else { return }
                                selected = opt
                                if opt == q.missingWord { score += 1 }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { advance() }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .padding(.top)
        .background(Color.igboBackground)
        .navigationTitle("Fill the Blank ✏️")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startGame() }
    }

    private func advance() {
        selected = nil
        if currentIndex + 1 >= totalQ { isFinished = true }
        else { withAnimation { currentIndex += 1 } }
    }

    private func startGame() {
        let pool = words.filter { $0.igbo.components(separatedBy: " ").count >= 2 }.shuffled()
        questions = Array(pool.prefix(totalQ)).map { makeQuestion($0) }
        currentIndex = 0
        score = 0
        selected = nil
        isFinished = false
    }

    private func makeQuestion(_ phrase: WordPair) -> FillBlankQuestion {
        let igboParts = phrase.igbo.components(separatedBy: " ")
        let removeIdx = Int.random(in: 0..<igboParts.count)
        let missing = igboParts[removeIdx]
        var blanked = igboParts
        blanked[removeIdx] = "___"

        // Build distractors from other phrase igbo words
        let distractors = words
            .filter { $0.english != phrase.english }
            .flatMap { $0.igbo.components(separatedBy: " ") }
            .filter { $0 != missing && $0.count > 1 }
            .shuffled()
            .prefix(3)
            .map { $0 }

        let options = (Array(distractors) + [missing]).shuffled()

        return FillBlankQuestion(
            phrase: phrase,
            blankedIgbo: blanked.joined(separator: " "),
            missingWord: missing,
            options: options
        )
    }
}

struct BlankOptionButton: View {
    let text: String
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
                Text(text)
                    .font(.headline)
                    .foregroundStyle(Color.igboGreen)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
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
