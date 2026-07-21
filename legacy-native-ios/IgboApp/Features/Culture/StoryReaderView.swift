import SwiftUI

struct StoryReaderView: View {
    let story: IgboStory
    @State private var currentParagraph = 0
    @State private var isPlaying = false
    @State private var readingMode: ReadingMode = .paginated
    @State private var fontSize: CGFloat = 17
    @State private var showVocab = false

    enum ReadingMode: String, CaseIterable {
        case paginated = "Pages"
        case scroll    = "Scroll"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack(spacing: 16) {
                Picker("Mode", selection: $readingMode) {
                    ForEach(ReadingMode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)

                Spacer()

                // Font size
                HStack(spacing: 8) {
                    Button { fontSize = max(13, fontSize - 2) } label: {
                        Image(systemName: "textformat.size.smaller").foregroundStyle(Color.igboGreen)
                    }
                    Button { fontSize = min(24, fontSize + 2) } label: {
                        Image(systemName: "textformat.size.larger").foregroundStyle(Color.igboGreen)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.igboCard)

            if readingMode == .paginated {
                PaginatedReader(story: story, currentParagraph: $currentParagraph,
                               isPlaying: $isPlaying, fontSize: fontSize)
            } else {
                ScrollReader(story: story, isPlaying: $isPlaying, fontSize: fontSize)
            }
        }
        .navigationTitle(story.subtitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation { showVocab.toggle() }
                } label: {
                    Label("Vocab", systemImage: "text.book.closed.fill")
                }
            }
        }
        .sheet(isPresented: $showVocab) {
            StoryVocabSheet(story: story)
        }
        .onDisappear {
            AudioService.shared.stop()
        }
    }
}

// MARK: - Paginated reader (one paragraph at a time)

struct PaginatedReader: View {
    let story: IgboStory
    @Binding var currentParagraph: Int
    @Binding var isPlaying: Bool
    let fontSize: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            // Story header (only on first page)
            if currentParagraph == 0 {
                VStack(spacing: 8) {
                    Text(story.emoji).font(.system(size: 56))
                    Text(story.title)
                        .font(.title2.bold())
                        .foregroundStyle(Color.igboGreen)
                        .multilineTextAlignment(.center)
                    Text(story.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.igboGold.opacity(0.1))
            }

            // Paragraph
            ScrollView {
                Text(story.paragraphs[currentParagraph])
                    .font(.system(size: fontSize))
                    .lineSpacing(6)
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Moral lesson on last paragraph
            if currentParagraph == story.paragraphs.count - 1 {
                HStack(alignment: .top, spacing: 10) {
                    Text("💡").font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Moral").font(.caption.bold()).foregroundStyle(.secondary).textCase(.uppercase)
                        Text(story.moralLesson).font(.subheadline)
                    }
                }
                .padding()
                .background(Color.igboGold.opacity(0.15), in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
            }

            Spacer()

            // Controls
            HStack(spacing: 24) {
                Button {
                    guard currentParagraph > 0 else { return }
                    withAnimation { currentParagraph -= 1 }
                    AudioService.shared.stop()
                    isPlaying = false
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(currentParagraph == 0 ? .gray : Color.igboGreen)
                }
                .disabled(currentParagraph == 0)

                // Play / stop paragraph
                Button {
                    if isPlaying {
                        AudioService.shared.stop()
                        isPlaying = false
                    } else {
                        isPlaying = true
                        AudioService.shared.speak(story.paragraphs[currentParagraph])
                        // Auto-advance when done speaking
                        let charCount = story.paragraphs[currentParagraph].count
                        let delay = Double(charCount) / 12.0  // rough estimate
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            isPlaying = false
                        }
                    }
                } label: {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.igboGreen)
                }

                Button {
                    guard currentParagraph < story.paragraphs.count - 1 else { return }
                    withAnimation { currentParagraph += 1 }
                    AudioService.shared.stop()
                    isPlaying = false
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(currentParagraph == story.paragraphs.count - 1 ? .gray : Color.igboGreen)
                }
                .disabled(currentParagraph == story.paragraphs.count - 1)
            }
            .padding()

            // Progress indicator
            HStack(spacing: 6) {
                ForEach(0..<story.paragraphs.count, id: \.self) { i in
                    Capsule()
                        .fill(i == currentParagraph ? Color.igboGreen : Color.gray.opacity(0.3))
                        .frame(width: i == currentParagraph ? 20 : 6, height: 6)
                }
            }
            .animation(.spring, value: currentParagraph)
            .padding(.bottom, 24)
        }
        .background(Color.igboBackground)
    }
}

// MARK: - Scroll reader (full story at once)

struct ScrollReader: View {
    let story: IgboStory
    @Binding var isPlaying: Bool
    let fontSize: CGFloat

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text(story.emoji).font(.system(size: 56))
                    Text(story.title)
                        .font(.title2.bold())
                        .foregroundStyle(Color.igboGreen)
                    Text(story.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.igboGold.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

                // Play full story
                Button {
                    if isPlaying {
                        AudioService.shared.stop()
                        isPlaying = false
                    } else {
                        isPlaying = true
                        AudioService.shared.speak(story.fullText)
                    }
                } label: {
                    Label(isPlaying ? "Stop Reading" : "Read Full Story Aloud",
                          systemImage: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isPlaying ? Color.igboRed.opacity(0.15) : Color.igboGreen)
                        .foregroundStyle(isPlaying ? Color.igboRed : .white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Paragraphs
                ForEach(Array(story.paragraphs.enumerated()), id: \.offset) { _, para in
                    Text(para)
                        .font(.system(size: fontSize))
                        .lineSpacing(6)
                }

                // Moral
                HStack(alignment: .top, spacing: 10) {
                    Text("💡").font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Moral").font(.caption.bold()).foregroundStyle(.secondary).textCase(.uppercase)
                        Text(story.moralLesson).font(.subheadline)
                    }
                }
                .padding()
                .background(Color.igboGold.opacity(0.15), in: RoundedRectangle(cornerRadius: 14))
            }
            .padding()
        }
        .background(Color.igboBackground)
    }
}

// MARK: - Vocab sheet

struct StoryVocabSheet: View {
    let story: IgboStory
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(story.igboWords) { word in
                HStack(spacing: 12) {
                    if let emoji = word.emoji { Text(emoji).font(.title2) }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(word.igbo).font(.headline).foregroundStyle(Color.igboGreen)
                        Text(word.english).font(.subheadline)
                        Text(word.pronunciation).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button {
                        AudioService.shared.speak(word.igbo)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill").foregroundStyle(Color.igboGreen)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Key Words")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
