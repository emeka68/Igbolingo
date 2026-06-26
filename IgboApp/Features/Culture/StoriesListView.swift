import SwiftUI

struct StoriesListView: View {
    @State private var selectedStory: IgboStory?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header card
                HStack(spacing: 12) {
                    Text("📖").font(.largeTitle)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Akụkọ Ifo")
                            .font(.headline)
                        Text("Traditional Igbo folktales — tap a story to read and listen")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.igboGold.opacity(0.15), in: RoundedRectangle(cornerRadius: 16))
                .padding()

                VStack(spacing: 12) {
                    ForEach(igboFolktales) { story in
                        StoryCard(story: story)
                            .onTapGesture { selectedStory = story }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationDestination(item: $selectedStory) { story in
            StoryReaderView(story: story)
        }
    }
}

struct StoryCard: View {
    let story: IgboStory

    var body: some View {
        HStack(spacing: 16) {
            Text(story.emoji)
                .font(.system(size: 48))
                .frame(width: 64)

            VStack(alignment: .leading, spacing: 4) {
                Text(story.title)
                    .font(.headline)
                    .foregroundStyle(Color.igboGreen)
                Text(story.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text("\(story.paragraphs.count) parts • \(story.igboWords.count) key words")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.igboGreen.opacity(0.15), lineWidth: 1))
    }
}
