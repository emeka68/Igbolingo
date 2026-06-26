import SwiftUI

// Full-screen level-up celebration shown when the user earns a new title

struct LevelUpView: View {
    let newTitle: IgboTitle
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 0.4
    @State private var opacity: Double = 0
    @State private var particlesVisible = false
    @State private var titleGlow = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [newTitle.color.opacity(0.9), newTitle.color.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Particle burst (simple circles)
            if particlesVisible {
                ForEach(0..<16, id: \.self) { i in
                    ParticleView(index: i, color: i % 2 == 0 ? .white : newTitle.color.opacity(0.6))
                }
            }

            VStack(spacing: 28) {
                Spacer()

                // Announcement label
                Text("New Title Unlocked!")
                    .font(.callout.bold())
                    .foregroundStyle(.white.opacity(0.85))
                    .textCase(.uppercase)
                    .tracking(2)

                // Title emoji
                Text(newTitle.emoji)
                    .font(.system(size: 100))
                    .scaleEffect(scale)
                    .shadow(color: .white.opacity(titleGlow ? 0.8 : 0), radius: titleGlow ? 30 : 10)

                // Title name
                VStack(spacing: 6) {
                    Text(newTitle.igbo)
                        .font(.system(size: 40, weight: .black))
                        .foregroundStyle(.white)
                    Text(newTitle.english)
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .scaleEffect(scale)

                // Meaning
                Text(newTitle.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
                    .opacity(opacity)

                Spacer()

                Button(action: onDismiss) {
                    Text("Daalụ! 🙌")
                        .font(.headline.bold())
                        .foregroundStyle(newTitle.color)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.7, bounce: 0.4)) {
                scale = 1.0
            }
            withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                particlesVisible = true
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.3)) {
                titleGlow = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                opacity = 1
            }
            AudioService.shared.speak("\(newTitle.igbo)! \(newTitle.english)!")
        }
    }
}

private struct ParticleView: View {
    let index: Int
    let color: Color

    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1

    private var angle: Double { Double(index) * (360.0 / 16.0) }

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: CGFloat.random(in: 6...14), height: CGFloat.random(in: 6...14))
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                let rad = angle * .pi / 180
                let dist = Double.random(in: 120...220)
                withAnimation(.easeOut(duration: 1.2).delay(Double.random(in: 0...0.3))) {
                    offset = CGSize(width: cos(rad) * dist, height: sin(rad) * dist)
                    opacity = 0
                }
            }
    }
}

// MARK: - Level-up detector modifier

struct LevelUpDetector: ViewModifier {
    @State private var appState = AppState.shared
    @State private var lastTitleID: Int = -1
    @State private var pendingTitle: IgboTitle?

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $pendingTitle) { title in
                LevelUpView(newTitle: title) {
                    pendingTitle = nil
                }
            }
            .onAppear { lastTitleID = currentTitleID }
            .onChange(of: appState.wordsLearned) { checkForLevelUp() }
            .onChange(of: appState.lessonsCompleted) { checkForLevelUp() }
            .onChange(of: appState.streakCount) { checkForLevelUp() }
    }

    private var currentTitleID: Int {
        ProgressionEngine.currentTitle(
            words: appState.wordsLearned,
            lessons: appState.lessonsCompleted,
            streak: appState.streakCount
        ).id
    }

    private func checkForLevelUp() {
        let newID = currentTitleID
        if newID > lastTitleID && lastTitleID >= 0 {
            pendingTitle = igboTitles[newID]
        }
        lastTitleID = newID
    }
}

extension View {
    func levelUpDetector() -> some View {
        modifier(LevelUpDetector())
    }
}

