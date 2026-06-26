import SwiftUI

struct GameType: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let emoji: String
    let difficulty: String

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: GameType, r: GameType) -> Bool { l.id == r.id }
}

let availableGames: [GameType] = [
    GameType(title: "Word Match",    description: "Match English words to their Igbo pair before time runs out", emoji: "🎯", difficulty: "Easy"),
    GameType(title: "Listen & Pick", description: "Hear an Igbo word spoken — tap the right English meaning",      emoji: "👂", difficulty: "Medium"),
    GameType(title: "Memory Flip",   description: "Flip cards to find matching Igbo and English pairs",            emoji: "🃏", difficulty: "Medium"),
    GameType(title: "Fill the Blank",description: "Complete the Igbo phrase with the missing word",               emoji: "✏️", difficulty: "Hard"),
]

struct GamesMenuView: View {
    let words: [WordPair]
    @State private var selectedGame: GameType?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Text("🎮").font(.largeTitle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mini Games").font(.headline)
                            Text("Play to remember what you've learned")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.igboGreen.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

                    ForEach(availableGames) { game in
                        GameCard(game: game)
                            .onTapGesture { selectedGame = game }
                    }
                }
                .padding()
            }
            .background(Color.igboBackground)
            .navigationTitle("Choose a Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .navigationDestination(item: $selectedGame) { game in
                gameView(for: game)
            }
        }
    }

    @ViewBuilder
    private func gameView(for game: GameType) -> some View {
        switch game.title {
        case "Word Match":    WordMatchGame(words: words)
        case "Listen & Pick": ListenPickGame(words: words)
        case "Memory Flip":   MemoryFlipGame(words: words)
        case "Fill the Blank":FillBlankGame(words: OfflineWordBank.phrases + OfflineWordBank.greetings)
        default:              Text("Coming soon")
        }
    }
}

struct GameCard: View {
    let game: GameType

    var difficultyColor: Color {
        switch game.difficulty {
        case "Easy":   return .green
        case "Medium": return .orange
        default:       return .red
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            Text(game.emoji).font(.system(size: 44)).frame(width: 60)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(game.title).font(.headline)
                    Spacer()
                    Text(game.difficulty)
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(difficultyColor.opacity(0.15), in: Capsule())
                        .foregroundStyle(difficultyColor)
                }
                Text(game.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.igboGreen.opacity(0.15), lineWidth: 1))
    }
}
