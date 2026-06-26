import SwiftUI

struct MemoryCard: Identifiable {
    let id = UUID()
    let word: WordPair
    let isIgbo: Bool
    var isFlipped = false
    var isMatched = false

    var displayText: String { isIgbo ? word.igbo : word.english }
    var matchKey: String { word.english }
}

struct MemoryFlipGame: View {
    let words: [WordPair]
    @Environment(\.dismiss) private var dismiss

    @State private var cards: [MemoryCard] = []
    @State private var firstSelected: MemoryCard?
    @State private var isChecking = false
    @State private var moves = 0
    @State private var matchedCount = 0
    @State private var isFinished = false
    @State private var startTime = Date()
    @State private var elapsedSeconds = 0
    @State private var timer: Timer?

    private let pairCount = 6

    private var columns: [GridItem] { Array(repeating: GridItem(.flexible(), spacing: 10), count: 4) }

    var body: some View {
        VStack(spacing: 16) {
            // Stats
            HStack {
                Label("\(moves) moves", systemImage: "arrow.2.squarepath")
                Spacer()
                Label("\(matchedCount)/\(pairCount)", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(Color.igboGreen)
                Spacer()
                Label(timeString, systemImage: "timer")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.horizontal)

            if isFinished {
                GameResultView(score: pairCount, total: pairCount, onReplay: startGame, extraInfo: "\(moves) moves • \(timeString)") {
                    dismiss()
                }
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(cards) { card in
                        MemoryCardView(card: card)
                            .onTapGesture { flip(card) }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
        .background(Color.igboBackground)
        .navigationTitle("Memory Flip 🃏")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startGame() }
        .onDisappear { timer?.invalidate() }
    }

    private var timeString: String {
        let m = elapsedSeconds / 60
        let s = elapsedSeconds % 60
        return m > 0 ? "\(m)m \(s)s" : "\(s)s"
    }

    private func flip(_ card: MemoryCard) {
        guard !isChecking,
              !card.isFlipped,
              !card.isMatched else { return }

        guard let idx = cards.firstIndex(where: { $0.id == card.id }) else { return }

        withAnimation(.spring(duration: 0.3)) {
            cards[idx].isFlipped = true
        }

        if let first = firstSelected {
            isChecking = true
            moves += 1

            if first.matchKey == card.matchKey && first.id != card.id {
                // Match
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        if let i1 = cards.firstIndex(where: { $0.id == first.id }),
                           let i2 = cards.firstIndex(where: { $0.id == card.id }) {
                            cards[i1].isMatched = true
                            cards[i2].isMatched = true
                        }
                        matchedCount += 1
                        firstSelected = nil
                        isChecking = false
                        if matchedCount == pairCount { isFinished = true; timer?.invalidate() }
                    }
                    AudioService.shared.speak(card.word.igbo)
                }
            } else {
                // No match — flip back
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.spring(duration: 0.3)) {
                        if let i1 = cards.firstIndex(where: { $0.id == first.id }),
                           let i2 = cards.firstIndex(where: { $0.id == card.id }) {
                            cards[i1].isFlipped = false
                            cards[i2].isFlipped = false
                        }
                        firstSelected = nil
                        isChecking = false
                    }
                }
            }
        } else {
            firstSelected = card
        }
    }

    private func startGame() {
        timer?.invalidate()
        let picked = Array(words.shuffled().prefix(pairCount))
        var deck: [MemoryCard] = []
        for word in picked {
            deck.append(MemoryCard(word: word, isIgbo: false))
            deck.append(MemoryCard(word: word, isIgbo: true))
        }
        cards = deck.shuffled()
        firstSelected = nil
        isChecking = false
        moves = 0
        matchedCount = 0
        isFinished = false
        elapsedSeconds = 0
        startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }
}

struct MemoryCardView: View {
    let card: MemoryCard

    var body: some View {
        ZStack {
            if card.isFlipped || card.isMatched {
                RoundedRectangle(cornerRadius: 10)
                    .fill(card.isMatched ? Color.igboGreen.opacity(0.15) : Color.igboCard)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                        card.isMatched ? Color.igboGreen : Color.igboGreen.opacity(0.3), lineWidth: 1.5))

                VStack(spacing: 2) {
                    if !card.isIgbo, let emoji = card.word.emoji {
                        Text(emoji).font(.body)
                    }
                    Text(card.displayText)
                        .font(.caption.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(card.isIgbo ? Color.igboGreen : .primary)
                        .minimumScaleFactor(0.7)
                }
                .padding(4)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.igboGreen)

                Text("🇳🇬")
                    .font(.title2)
            }
        }
        .frame(height: 80)
        .rotation3DEffect(.degrees(card.isFlipped || card.isMatched ? 0 : 180), axis: (0, 1, 0))
        .animation(.spring(duration: 0.35), value: card.isFlipped)
    }
}
