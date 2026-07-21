import SwiftUI

struct FlashcardView: View {
    let words: [WordPair]
    let isKidMode: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var dragOffset: CGFloat = 0
    @State private var completed = false
    @State private var showCelebration = false

    var currentWord: WordPair { words[currentIndex] }

    var body: some View {
        NavigationStack {
            ZStack {
                (isKidMode ? Color.igboGreen.opacity(0.05) : Color.igboBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Progress dots
                    HStack(spacing: 6) {
                        ForEach(0..<words.count, id: \.self) { i in
                            Circle()
                                .fill(i < currentIndex ? Color.igboGreen : i == currentIndex ? Color.igboGold : Color.gray.opacity(0.3))
                                .frame(width: i == currentIndex ? 12 : 8, height: i == currentIndex ? 12 : 8)
                        }
                    }
                    .animation(.spring, value: currentIndex)

                    Text("\(currentIndex + 1) / \(words.count)")
                        .font(isKidMode ? .headline : .subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    if completed {
                        CompletionView(wordCount: words.count, isKidMode: isKidMode) {
                            currentIndex = 0
                            isFlipped = false
                            completed = false
                        }
                    } else {
                        ZStack {
                            CardFace(isBack: true, word: currentWord, isKidMode: isKidMode)
                                .rotation3DEffect(.degrees(isFlipped ? 0 : -90), axis: (1, 0, 0))
                                .opacity(isFlipped ? 1 : 0)

                            CardFace(isBack: false, word: currentWord, isKidMode: isKidMode)
                                .rotation3DEffect(.degrees(isFlipped ? 90 : 0), axis: (1, 0, 0))
                                .opacity(isFlipped ? 0 : 1)
                        }
                        .offset(x: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { dragOffset = $0.translation.width }
                                .onEnded { value in
                                    if value.translation.width < -80 { advance() }
                                    else if value.translation.width > 80 { goBack() }
                                    withAnimation { dragOffset = 0 }
                                }
                        )
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.4)) { isFlipped.toggle() }
                            if isFlipped { AudioService.shared.speak(currentWord.igbo) }
                        }
                        .padding(.horizontal)

                        if isKidMode {
                            Text(isFlipped ? "Tap to hide • swipe ➡️ for next" : "Tap to see Igbo! 👆")
                                .font(.subheadline.bold())
                                .foregroundStyle(Color.igboGreen)
                        } else {
                            Text(isFlipped ? "Tap to hide · swipe to navigate" : "Tap to reveal Igbo · swipe to navigate")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    if !completed {
                        HStack(spacing: 20) {
                            Button { goBack() } label: {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(isKidMode ? .largeTitle : .title)
                                    .foregroundStyle(currentIndex == 0 ? .gray : Color.igboGreen)
                            }
                            .disabled(currentIndex == 0)

                            Spacer()

                            Button { advance() } label: {
                                Label(
                                    currentIndex == words.count - 1 ? (isKidMode ? "Finish! 🎉" : "Finish") : (isKidMode ? "Next ➡️" : "Next"),
                                    systemImage: currentIndex == words.count - 1 ? "checkmark.circle.fill" : "arrow.right.circle.fill"
                                )
                                .font(isKidMode ? .headline : .body)
                                .padding(.horizontal, isKidMode ? 28 : 24)
                                .padding(.vertical, isKidMode ? 14 : 12)
                                .background(Color.igboGreen)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom)
                    }
                }
                .padding(.top)

                // Celebration overlay for kids
                if showCelebration {
                    CelebrationOverlay()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showCelebration = false
                            }
                        }
                }
            }
            .navigationTitle(isKidMode ? "Flashcards 🃏" : "Flashcards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func advance() {
        withAnimation(.spring) {
            isFlipped = false
            if currentIndex < words.count - 1 {
                currentIndex += 1
                if isKidMode && currentIndex % 3 == 0 { showCelebration = true }
            } else {
                completed = true
                if isKidMode { showCelebration = true }
            }
        }
    }

    private func goBack() {
        guard currentIndex > 0 else { return }
        withAnimation(.spring) { isFlipped = false; currentIndex -= 1 }
    }
}

struct CardFace: View {
    let isBack: Bool
    let word: WordPair
    let isKidMode: Bool

    var body: some View {
        VStack(spacing: isKidMode ? 20 : 16) {
            if let emoji = word.emoji {
                Text(emoji).font(.system(size: isKidMode ? 80 : 64))
            }

            if isBack {
                VStack(spacing: isKidMode ? 12 : 8) {
                    Text(word.igbo)
                        .font(isKidMode ? .system(size: 44, weight: .bold) : .largeTitle.bold())
                        .foregroundStyle(Color.igboGreen)
                        .multilineTextAlignment(.center)
                    Text(word.pronunciation)
                        .font(isKidMode ? .title2 : .title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button {
                        AudioService.shared.speak(word.igbo)
                    } label: {
                        Label("Listen", systemImage: "speaker.wave.2.fill")
                            .font(isKidMode ? .headline : .body)
                            .foregroundStyle(Color.igboGreen)
                    }
                    .padding(.top, 4)
                }
            } else {
                VStack(spacing: 8) {
                    Text(word.english)
                        .font(isKidMode ? .system(size: 36, weight: .bold) : .largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text(isKidMode ? "Tap to see! 👆" : "Tap to see Igbo")
                        .font(isKidMode ? .headline : .subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: isKidMode ? 340 : 300)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: isKidMode ? 28 : 24)
                .fill(isBack ? Color.igboGreen.opacity(0.08) : Color.igboCard)
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: isKidMode ? 28 : 24)
                .stroke(isBack ? Color.igboGreen.opacity(0.4) : Color.clear, lineWidth: isKidMode ? 2 : 1.5)
        )
    }
}

struct CompletionView: View {
    let wordCount: Int
    let isKidMode: Bool
    let onRestart: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: isKidMode ? 28 : 20) {
            Text(isKidMode ? "🎊🏆🎊" : "🎉").font(.system(size: isKidMode ? 72 : 60))
            Text(isKidMode ? "Amazing job!" : "Great work!")
                .font(isKidMode ? .system(size: 40, weight: .bold) : .largeTitle.bold())
            Text("You practised all \(wordCount) words\(isKidMode ? "! You're a star! ⭐" : ".")")
                .font(isKidMode ? .title3 : .body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button(isKidMode ? "Play Again! 🔄" : "Practice Again", action: onRestart)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.igboGreen)
                    .font(isKidMode ? .headline : .body)

                Button("Done") { dismiss() }
                    .foregroundStyle(Color.igboGreen)
                    .font(isKidMode ? .headline : .body)
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct CelebrationOverlay: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1

    var body: some View {
        VStack {
            Text("⭐ Great! ⭐")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(Color.igboGold)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.15))
        .onAppear {
            withAnimation(.spring(duration: 0.4)) { scale = 1.2 }
            withAnimation(.easeOut(duration: 0.5).delay(1.2)) { opacity = 0 }
        }
    }
}
