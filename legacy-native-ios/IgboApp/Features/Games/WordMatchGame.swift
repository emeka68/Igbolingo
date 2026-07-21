import SwiftUI

struct WordMatchGame: View {
    let words: [WordPair]
    @Environment(\.dismiss) private var dismiss

    @State private var gameWords: [WordPair] = []
    @State private var englishOrder: [WordPair] = []
    @State private var igboOrder: [WordPair] = []
    @State private var selectedEnglish: WordPair?
    @State private var selectedIgbo: WordPair?
    @State private var matched: Set<String> = []
    @State private var wrong: Set<String> = []
    @State private var score = 0
    @State private var timeLeft = 60
    @State private var timer: Timer?
    @State private var isFinished = false

    private let pairCount = 5

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Label("\(timeLeft)s", systemImage: "timer")
                    .font(.headline)
                    .foregroundStyle(timeLeft < 15 ? .red : Color.igboGreen)
                Spacer()
                Label("\(score)/\(pairCount)", systemImage: "star.fill")
                    .font(.headline)
                    .foregroundStyle(Color.igboGold)
            }
            .padding(.horizontal)

            ProgressView(value: Double(matched.count), total: Double(pairCount))
                .tint(Color.igboGreen)
                .padding(.horizontal)

            if isFinished {
                GameResultView(score: score, total: pairCount, onReplay: startGame) {
                    dismiss()
                }
            } else {
                HStack(alignment: .top, spacing: 12) {
                    // English column
                    VStack(spacing: 10) {
                        Text("English").font(.caption.bold()).foregroundStyle(.secondary).textCase(.uppercase)
                        ForEach(englishOrder) { word in
                            MatchCard(
                                text: word.english,
                                emoji: word.emoji,
                                state: cardState(word: word, column: .english)
                            ) {
                                selectEnglish(word)
                            }
                        }
                    }

                    // Igbo column
                    VStack(spacing: 10) {
                        Text("Igbo").font(.caption.bold()).foregroundStyle(Color.igboGreen).textCase(.uppercase)
                        ForEach(igboOrder) { word in
                            MatchCard(
                                text: word.igbo,
                                emoji: nil,
                                state: cardState(word: word, column: .igbo)
                            ) {
                                selectIgbo(word)
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
        .navigationTitle("Word Match 🎯")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startGame() }
        .onDisappear { timer?.invalidate() }
    }

    private enum Column { case english, igbo }

    private func cardState(word: WordPair, column: Column) -> MatchCard.CardState {
        if matched.contains(word.english) { return .matched }
        if wrong.contains(word.english) { return .wrong }
        if column == .english && selectedEnglish?.english == word.english { return .selected }
        if column == .igbo && selectedIgbo?.english == word.english { return .selected }
        return .idle
    }

    private func selectEnglish(_ word: WordPair) {
        guard !matched.contains(word.english) else { return }
        selectedEnglish = word
        checkMatch()
    }

    private func selectIgbo(_ word: WordPair) {
        guard !matched.contains(word.english) else { return }
        selectedIgbo = word
        checkMatch()
    }

    private func checkMatch() {
        guard let eng = selectedEnglish, let igbo = selectedIgbo else { return }
        if eng.english == igbo.english {
            withAnimation(.spring) { matched.insert(eng.english) }
            score += 1
            AudioService.shared.speak(igbo.igbo)
            if matched.count == pairCount { isFinished = true; timer?.invalidate() }
        } else {
            withAnimation {
                wrong.insert(eng.english)
                wrong.insert(igbo.english)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation { wrong.removeAll() }
            }
        }
        selectedEnglish = nil
        selectedIgbo = nil
    }

    private func startGame() {
        timer?.invalidate()
        gameWords = Array(words.shuffled().prefix(pairCount))
        englishOrder = gameWords.shuffled()
        igboOrder = gameWords.shuffled()
        matched = []
        wrong = []
        selectedEnglish = nil
        selectedIgbo = nil
        score = 0
        timeLeft = 60
        isFinished = false

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeLeft > 0 { timeLeft -= 1 }
            else { timer?.invalidate(); isFinished = true }
        }
    }
}

struct MatchCard: View {
    let text: String
    let emoji: String?
    let state: CardState
    let action: () -> Void

    enum CardState { case idle, selected, matched, wrong }

    var background: Color {
        switch state {
        case .idle:     return Color.igboCard
        case .selected: return Color.igboGreen.opacity(0.2)
        case .matched:  return Color.igboGreen.opacity(0.15)
        case .wrong:    return Color.igboRed.opacity(0.2)
        }
    }

    var border: Color {
        switch state {
        case .idle:     return Color.clear
        case .selected: return Color.igboGreen
        case .matched:  return Color.igboGreen.opacity(0.5)
        case .wrong:    return Color.igboRed
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let emoji { Text(emoji).font(.body) }
                Text(text)
                    .font(.subheadline.bold())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                if state == .matched {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.igboGreen)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.horizontal, 10)
            .background(background, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(border, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .animation(.spring, value: state)
        .disabled(state == .matched)
    }
}
