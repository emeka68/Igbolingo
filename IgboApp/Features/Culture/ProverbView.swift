import SwiftUI

// MARK: - Daily Proverb Logic

struct DailyProverb {
    static var today: IgboProverb {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % igboProverbs.count
        return igboProverbs[index]
    }
}

// MARK: - Proverb of the Day Card (used in CultureView)

struct ProverbOfTheDayCard: View {
    @State private var isExpanded = false
    @State private var isPlaying = false

    private let proverb = DailyProverb.today

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Label("Ilu Ụbọchị", systemImage: "quote.opening")
                    .font(.caption.bold())
                    .foregroundStyle(Color.igboGold)
                    .textCase(.uppercase)
                Spacer()
                Text("Proverb of the Day")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top, 14)

            Divider().padding(.horizontal).padding(.top, 8)

            VStack(alignment: .leading, spacing: 12) {
                // Igbo proverb
                HStack(alignment: .top, spacing: 10) {
                    Text(proverb.igbo)
                        .font(.headline)
                        .foregroundStyle(Color.igboGreen)
                        .italic()
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Button {
                        isPlaying = true
                        AudioService.shared.speak(proverb.igbo)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { isPlaying = false }
                    } label: {
                        Image(systemName: isPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                            .foregroundStyle(isPlaying ? Color.igboGold : Color.igboGreen)
                            .font(.subheadline)
                    }
                }

                // English translation
                Text("\"\(proverb.english)\"")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if isExpanded {
                    Divider()
                    Text(proverb.meaning)
                        .font(.subheadline)
                        .lineSpacing(4)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                Button {
                    withAnimation(.spring) { isExpanded.toggle() }
                } label: {
                    Label(isExpanded ? "Show less" : "What does it mean?",
                          systemImage: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                        .foregroundStyle(Color.igboGreen)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.igboCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.igboGold.opacity(0.4), lineWidth: 1.5)
                )
        )
    }
}

// MARK: - Full Proverb Browser

struct ProverbBrowserView: View {
    @State private var searchText = ""
    @State private var selectedProverb: IgboProverb?

    var filtered: [IgboProverb] {
        if searchText.isEmpty { return igboProverbs }
        return igboProverbs.filter {
            $0.igbo.localizedCaseInsensitiveContains(searchText) ||
            $0.english.localizedCaseInsensitiveContains(searchText) ||
            $0.meaning.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            // Today's proverb pinned at top
            Section("Today's Proverb") {
                ProverbRow(proverb: DailyProverb.today, isToday: true)
            }

            Section("All \(igboProverbs.count) Proverbs") {
                ForEach(filtered) { proverb in
                    ProverbRow(proverb: proverb, isToday: false)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search proverbs…")
        .listStyle(.insetGrouped)
        .navigationTitle("Ilu — Proverbs")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProverbRow: View {
    let proverb: IgboProverb
    let isToday: Bool
    @State private var isExpanded = false
    @State private var isPlaying = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    if isToday {
                        Label("Today", systemImage: "star.fill")
                            .font(.caption.bold())
                            .foregroundStyle(Color.igboGold)
                    }
                    Text(proverb.igbo)
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.igboGreen)
                        .italic()
                }
                Spacer()
                Button {
                    isPlaying = true
                    AudioService.shared.speak(proverb.igbo)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { isPlaying = false }
                } label: {
                    Image(systemName: isPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                        .foregroundStyle(isPlaying ? Color.igboGold : Color.igboGreen)
                }
                .buttonStyle(.plain)
            }

            Text("\"\(proverb.english)\"")
                .font(.caption)
                .foregroundStyle(.secondary)

            if isExpanded {
                Text(proverb.meaning)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .lineSpacing(3)
                    .padding(.top, 2)
                    .transition(.opacity)
            }

            Button {
                withAnimation(.spring(duration: 0.3)) { isExpanded.toggle() }
            } label: {
                Text(isExpanded ? "Less ▲" : "Meaning ▼")
                    .font(.caption.bold())
                    .foregroundStyle(Color.igboGreen)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
