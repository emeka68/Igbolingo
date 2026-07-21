import SwiftUI

// MARK: - Compact title badge shown in Learn tab header

struct TitleBadge: View {
    @State private var appState = AppState.shared
    @State private var showDetail = false

    var currentTitle: IgboTitle {
        ProgressionEngine.currentTitle(
            words: appState.wordsLearned,
            lessons: appState.lessonsCompleted,
            streak: appState.streakCount
        )
    }

    var body: some View {
        Button { showDetail = true } label: {
            HStack(spacing: 8) {
                Text(currentTitle.emoji)
                    .font(.title3)
                VStack(alignment: .leading, spacing: 1) {
                    Text(currentTitle.igbo)
                        .font(.subheadline.bold())
                        .foregroundStyle(currentTitle.color)
                    Text(currentTitle.english)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(currentTitle.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(currentTitle.color.opacity(0.25), lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            TitleDetailSheet(currentTitle: currentTitle, appState: appState)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Detail sheet: current title + road to next + full ladder

struct TitleDetailSheet: View {
    let currentTitle: IgboTitle
    let appState: AppState
    @Environment(\.dismiss) private var dismiss

    var nextTitle: IgboTitle? { ProgressionEngine.nextTitle(current: currentTitle) }

    var progressToNext: Double {
        guard let next = nextTitle else { return 1 }
        return ProgressionEngine.progress(toward: next, words: appState.wordsLearned,
                                          lessons: appState.lessonsCompleted, streak: appState.streakCount)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Current title hero
                    VStack(spacing: 10) {
                        Text(currentTitle.emoji)
                            .font(.system(size: 72))
                        Text(currentTitle.igbo)
                            .font(.largeTitle.bold())
                            .foregroundStyle(currentTitle.color)
                        Text(currentTitle.english)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Text(currentTitle.meaning)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                            .lineSpacing(3)
                    }
                    .padding(.top)

                    // Progress to next title
                    if let next = nextTitle {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Next: \(next.igbo)")
                                    .font(.headline)
                                Spacer()
                                Text("\(Int(progressToNext * 100))%")
                                    .font(.headline.bold())
                                    .foregroundStyle(next.color)
                            }

                            ProgressView(value: progressToNext)
                                .tint(next.color)
                                .scaleEffect(y: 2.5)

                            HStack(spacing: 16) {
                                RequirementPill(
                                    icon: "text.book.closed.fill",
                                    current: appState.wordsLearned,
                                    required: next.wordsRequired,
                                    label: "words",
                                    color: Color.igboGreen
                                )
                                RequirementPill(
                                    icon: "checkmark.seal.fill",
                                    current: appState.lessonsCompleted,
                                    required: next.lessonsRequired,
                                    label: "lessons",
                                    color: Color.igboGold
                                )
                                if next.streakRequired > 0 {
                                    RequirementPill(
                                        icon: "flame.fill",
                                        current: appState.streakCount,
                                        required: next.streakRequired,
                                        label: "streak",
                                        color: .orange
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    } else {
                        HStack(spacing: 10) {
                            Text("🌟")
                            Text("You have reached the highest title. Daalụ!")
                                .font(.headline)
                                .foregroundStyle(currentTitle.color)
                        }
                        .padding()
                        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }

                    // Full title ladder
                    VStack(alignment: .leading, spacing: 0) {
                        Text("All Titles")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.bottom, 10)

                        ForEach(igboTitles) { title in
                            TitleLadderRow(
                                title: title,
                                isCurrent: title.id == currentTitle.id,
                                isUnlocked: title.id <= currentTitle.id
                            )
                            if title.id < igboTitles.count - 1 {
                                HStack {
                                    Spacer().frame(width: 28)
                                    Rectangle()
                                        .fill(title.id < currentTitle.id ? title.color.opacity(0.4) : Color.secondary.opacity(0.15))
                                        .frame(width: 2, height: 16)
                                    Spacer()
                                }
                                .padding(.leading, 28)
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .background(Color.igboBackground)
            .navigationTitle("Your Title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct RequirementPill: View {
    let icon: String
    let current: Int
    let required: Int
    let label: String
    let color: Color

    var done: Bool { current >= required }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: done ? "checkmark.circle.fill" : icon)
                .foregroundStyle(done ? .green : color)
                .font(.caption)
            Text(done ? "✓" : "\(current)/\(required)")
                .font(.caption.bold())
                .foregroundStyle(done ? .green : .primary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background((done ? Color.green : color).opacity(0.1), in: Capsule())
        .frame(maxWidth: .infinity)
    }
}

struct TitleLadderRow: View {
    let title: IgboTitle
    let isCurrent: Bool
    let isUnlocked: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? title.color.opacity(0.15) : Color.secondary.opacity(0.08))
                    .frame(width: 44, height: 44)
                if isUnlocked {
                    Text(title.emoji).font(.title3)
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(Color.secondary.opacity(0.4))
                        .font(.subheadline)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title.igbo)
                    .font(.subheadline.bold())
                    .foregroundStyle(isUnlocked ? title.color : .secondary)
                Text(title.english)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if !isUnlocked && title.wordsRequired > 0 {
                    Text("\(title.wordsRequired)w · \(title.lessonsRequired)L" +
                         (title.streakRequired > 0 ? " · \(title.streakRequired)d streak" : ""))
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            if isCurrent {
                Text("NOW")
                    .font(.caption2.bold())
                    .foregroundStyle(title.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(title.color.opacity(0.15), in: Capsule())
            } else if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(isCurrent ? title.color.opacity(0.06) : Color.clear)
        .overlay(
            isCurrent ?
            RoundedRectangle(cornerRadius: 0)
                .stroke(title.color.opacity(0.15), lineWidth: 1)
                .padding(.horizontal, 8)
            : nil
        )
    }
}
