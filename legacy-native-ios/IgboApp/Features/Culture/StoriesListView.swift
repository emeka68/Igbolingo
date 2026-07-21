import SwiftUI

enum StoryFilter: String, CaseIterable {
    case all        = "All"
    case animal     = "Animal Tales"
    case origin     = "Origin Stories"
    case historical = "History & Culture"
    case modern     = "Modern"

    var emoji: String {
        switch self {
        case .all:        return "📚"
        case .animal:     return "🐾"
        case .origin:     return "🌍"
        case .historical: return "🏛️"
        case .modern:     return "🌆"
        }
    }
}

// Tag each story — indices match igboFolktales array order
private let storyFilters: [String: StoryFilter] = [
    "Mbe na Nnụnụ": .animal,
    "Gịnị mere igwe di anya n'elu": .origin,
    "Mbe na Ọ bụ onye ọchịchọ": .animal,
    "Odum na Mbe": .animal,
    "Chi na Ọ dị adị": .historical,
    "Gịnị mere nkịta bi na ụlọ mmadụ": .animal,
    "Gịnị mere ọkụkọ na-ẹkọ n'ụtụtụ": .origin,
    "Enyi na Mmiri": .animal,
    "Gịnị mere oji dị nsọ": .origin,
    "Ụgụ onye ọ chọrọ ikarị ihe niile": .animal,
    "Gịnị mere anyị na-ekele okenye tupu ndị ọzọ": .historical,
    "Enwe na onyinyo ya": .animal,
    "Ọ bụ otú ọkụ bịara n'obodo": .origin,
    "Ada na ikuku": .modern,
    "Ikenga — Chi ike mmadụ": .historical,
    "Ụmụnne abụọ na obodo ukwu": .modern,
    "Gịnị mere ọha osisi nkwụ di elu": .origin,
    "Udene na ihe omuma ya": .animal,
    "Ọmalị Nri — Obodo mbụ": .historical,
    "Nwa nwoke nke jụrụ ikele": .modern,
    "Gịnị mere ndị inyom ji ebu ụmụ ha n'azụ": .origin,
    "Onye ahịa na mmụọ mmiri": .modern,
    "Igba nke kwuru okwu": .historical,
    "Gịnị mere ụtọ na-afọ n'abalị": .animal,
    "Osisi Oji Ochie": .historical,
]

struct StoriesListView: View {
    @State private var selectedStory: IgboStory?
    @State private var filter: StoryFilter = .all

    var allStories: [IgboStory] { igboFolktales }

    var filtered: [IgboStory] {
        if filter == .all { return allStories }
        return allStories.filter { storyFilters[$0.title] == filter }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 12) {
                    Text("📖").font(.largeTitle)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Akụkọ Ifo")
                            .font(.headline)
                        Text("\(allStories.count) traditional Igbo folktales — tap to read and listen")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.igboGold.opacity(0.15), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                .padding(.bottom, 8)

                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(StoryFilter.allCases, id: \.self) { f in
                            Button {
                                withAnimation(.spring) { filter = f }
                            } label: {
                                HStack(spacing: 6) {
                                    Text(f.emoji)
                                    Text(f.rawValue).font(.subheadline.bold())
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(filter == f ? Color.igboGreen : Color.igboCard, in: Capsule())
                                .foregroundStyle(filter == f ? .white : .primary)
                                .overlay(Capsule().stroke(filter == f ? Color.clear : Color.igboGreen.opacity(0.2), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)

                // Story count
                Text("\(filtered.count) stor\(filtered.count == 1 ? "y" : "ies")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 4)

                VStack(spacing: 12) {
                    ForEach(filtered) { story in
                        StoryCard(story: story, filter: storyFilters[story.title] ?? .all)
                            .onTapGesture { selectedStory = story }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .animation(.spring, value: filter)
            }
        }
        .navigationDestination(item: $selectedStory) { story in
            StoryReaderView(story: story)
        }
    }
}

struct StoryCard: View {
    let story: IgboStory
    let filter: StoryFilter

    var body: some View {
        HStack(spacing: 16) {
            Text(story.emoji)
                .font(.system(size: 44))
                .frame(width: 56)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(filter.rawValue)
                        .font(.caption.bold())
                        .foregroundStyle(Color.igboGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.igboGreen.opacity(0.1), in: Capsule())
                    Spacer()
                }
                Text(story.title)
                    .font(.headline)
                    .foregroundStyle(Color.igboGreen)
                    .lineLimit(1)
                Text(story.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text("\(story.paragraphs.count) parts • \(story.igboWords.count) key words")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.igboGreen.opacity(0.12), lineWidth: 1))
    }
}
