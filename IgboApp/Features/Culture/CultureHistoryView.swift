import SwiftUI

struct CultureHistoryView: View {
    @State private var selectedCategory: CultureCategory?
    @State private var selectedArticle: CultureArticle?

    var filteredArticles: [CultureArticle] {
        guard let cat = selectedCategory else { return cultureArticles }
        return cultureArticles.filter { $0.category == cat }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Category filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryChip(label: "All", emoji: "🌍", isSelected: selectedCategory == nil) {
                            withAnimation { selectedCategory = nil }
                        }
                        ForEach(CultureCategory.allCases, id: \.self) { cat in
                            CategoryChip(label: cat.rawValue, emoji: cat.emoji, isSelected: selectedCategory == cat) {
                                withAnimation { selectedCategory = selectedCategory == cat ? nil : cat }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                VStack(spacing: 12) {
                    ForEach(filteredArticles) { article in
                        ArticleCard(article: article)
                            .onTapGesture { selectedArticle = article }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .animation(.spring, value: selectedCategory)
            }
            .padding(.vertical, 8)
        }
        .navigationDestination(item: $selectedArticle) { article in
            ArticleReaderView(article: article)
        }
    }
}

struct CategoryChip: View {
    let label: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(emoji)
                Text(label).font(.subheadline.bold())
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.igboGreen : Color.igboCard,
                        in: Capsule())
            .foregroundStyle(isSelected ? .white : .primary)
            .overlay(Capsule().stroke(isSelected ? Color.clear : Color.igboGreen.opacity(0.2), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct ArticleCard: View {
    let article: CultureArticle

    var body: some View {
        HStack(spacing: 16) {
            Text(article.emoji)
                .font(.system(size: 40))
                .frame(width: 56)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(article.category.rawValue)
                        .font(.caption.bold())
                        .foregroundStyle(Color.igboGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.igboGreen.opacity(0.1), in: Capsule())
                }
                Text(article.title)
                    .font(.headline)
                Text(article.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.igboGreen.opacity(0.12), lineWidth: 1))
    }
}

struct ArticleReaderView: View {
    let article: CultureArticle
    @State private var isPlaying = false
    @State private var fontSize: CGFloat = 16

    private var fullText: String {
        article.sections.map { section in
            [section.heading, section.body].compactMap { $0 }.joined(separator: ". ")
        }.joined(separator: ". ")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero
                VStack(spacing: 12) {
                    Text(article.emoji).font(.system(size: 64))
                    Text(article.title)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text(article.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.igboGreen.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))

                // Controls row
                HStack {
                    Button {
                        if isPlaying { AudioService.shared.stop(); isPlaying = false }
                        else { isPlaying = true; AudioService.shared.speak(fullText) }
                    } label: {
                        Label(isPlaying ? "Stop" : "Listen",
                              systemImage: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(isPlaying ? Color.igboRed.opacity(0.1) : Color.igboGreen.opacity(0.1),
                                        in: Capsule())
                            .foregroundStyle(isPlaying ? Color.igboRed : Color.igboGreen)
                    }

                    Spacer()

                    HStack(spacing: 10) {
                        Button { fontSize = max(13, fontSize - 2) } label: {
                            Image(systemName: "textformat.size.smaller").foregroundStyle(Color.igboGreen)
                        }
                        Button { fontSize = min(24, fontSize + 2) } label: {
                            Image(systemName: "textformat.size.larger").foregroundStyle(Color.igboGreen)
                        }
                    }
                }

                // Sections
                ForEach(article.sections) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        if let heading = section.heading {
                            Text(heading)
                                .font(.headline)
                                .foregroundStyle(Color.igboGreen)
                        }
                        Text(section.body)
                            .font(.system(size: fontSize))
                            .lineSpacing(5)
                    }
                }
            }
            .padding()
        }
        .background(Color.igboBackground)
        .navigationTitle(article.category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { AudioService.shared.stop() }
    }
}
