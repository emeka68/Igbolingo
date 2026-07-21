import SwiftUI

struct LearnTopic: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let emoji: String
    let topic: String
    let offlineKey: String   // key into OfflineWordBank.all

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: LearnTopic, rhs: LearnTopic) -> Bool { lhs.id == rhs.id }
}

let learnTopics: [LearnTopic] = [
    LearnTopic(title: "Greetings",    emoji: "👋", topic: "common Igbo greetings and polite phrases",  offlineKey: "Greetings"),
    LearnTopic(title: "Numbers",      emoji: "🔢", topic: "numbers 1-20 in Igbo",                      offlineKey: "Numbers"),
    LearnTopic(title: "Family",       emoji: "👨‍👩‍👧‍👦", topic: "family members in Igbo",                    offlineKey: "Family"),
    LearnTopic(title: "Food & Drink", emoji: "🍛", topic: "common Nigerian and Igbo foods and drinks", offlineKey: "Food & Drink"),
    LearnTopic(title: "Animals",      emoji: "🐾", topic: "common animals in Igbo",                    offlineKey: "Animals"),
    LearnTopic(title: "Colours",      emoji: "🎨", topic: "colours in Igbo",                           offlineKey: "Colours"),
    LearnTopic(title: "Body Parts",   emoji: "🧍", topic: "body parts in Igbo",                        offlineKey: "Body Parts"),
    LearnTopic(title: "Days & Time",  emoji: "📅", topic: "days of the week and time in Igbo",         offlineKey: "Days & Time"),
    LearnTopic(title: "Phrases",      emoji: "💬", topic: "common everyday Igbo phrases",              offlineKey: "Common Phrases"),
]

struct LearnView: View {
    @State private var selectedTopic: LearnTopic?
    @State private var appState = AppState.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TitleBadge()
                    .padding(.horizontal)

                StatsBar()
                    .padding(.horizontal)

                if appState.learnerProfile == .both {
                    KidModeToggle()
                        .padding(.horizontal)
                }

                Text("Choose a topic")
                    .font(appState.isKidMode ? .title2.bold() : .headline)
                    .padding(.horizontal)

                if appState.isKidMode {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(learnTopics) { topic in
                            KidTopicCard(topic: topic)
                                .onTapGesture { selectedTopic = topic }
                        }
                    }
                    .padding(.horizontal)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(learnTopics) { topic in
                            TopicCard(topic: topic)
                                .onTapGesture { selectedTopic = topic }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(appState.isKidMode ? "🧒 Learn Igbo!" : "Learn Igbo")
        .background(Color.igboBackground)
        .navigationDestination(item: $selectedTopic) { topic in
            LessonView(topic: topic)
        }
        .onAppear { AppState.shared.recordActivity() }
    }
}

struct StatsBar: View {
    @State private var appState = AppState.shared
    @State private var srStore = SpacedRepetitionStore.shared
    @State private var showReview = false

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                StatPill(value: "\(appState.streakCount)", label: "day streak", icon: "flame.fill", color: .orange)
                Spacer()
                StatPill(value: "\(appState.wordsLearned)", label: "words", icon: "text.book.closed.fill", color: Color.igboGreen)
                Spacer()
                StatPill(value: "\(appState.lessonsCompleted)", label: "lessons", icon: "checkmark.seal.fill", color: Color.igboGold)
            }

            if srStore.dueCount > 0 {
                Button {
                    showReview = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "brain.head.profile")
                        Text("\(srStore.dueCount) word\(srStore.dueCount == 1 ? "" : "s") due for review")
                            .font(.subheadline.bold())
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.igboGreen, in: RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
        .fullScreenCover(isPresented: $showReview) {
            ReviewView()
        }
        .animation(.spring, value: srStore.dueCount)
    }
}

struct StatPill: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon).foregroundStyle(color).font(.caption)
                Text(value).font(.headline.bold())
            }
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
    }
}

struct KidModeToggle: View {
    @State private var appState = AppState.shared

    var body: some View {
        HStack {
            Image(systemName: appState.isKidMode ? "hare.fill" : "tortoise.fill")
                .foregroundStyle(Color.igboGreen)
            Text(appState.isKidMode ? "Kid Mode" : "Adult Mode")
                .font(.subheadline.bold())
            Spacer()
            Toggle("", isOn: Binding(
                get: { appState.isKidMode },
                set: { appState.isKidMode = $0 }
            ))
            .tint(Color.igboGreen)
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Topic Cards

struct TopicCard: View {
    let topic: LearnTopic

    var body: some View {
        VStack(spacing: 10) {
            Text(topic.emoji).font(.system(size: 44))
            Text(topic.title)
                .font(.subheadline.bold())
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.igboGreen.opacity(0.2), lineWidth: 1))
    }
}

struct KidTopicCard: View {
    let topic: LearnTopic

    var body: some View {
        VStack(spacing: 12) {
            Text(topic.emoji).font(.system(size: 56))
            Text(topic.title)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.igboGreen.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.igboGreen.opacity(0.4), lineWidth: 2))
        )
    }
}

struct LearnerBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Text("🇳🇬").font(.largeTitle)
            VStack(alignment: .leading, spacing: 2) {
                Text("Ndewo! Welcome")
                    .font(.headline)
                Text("Start a lesson to learn Igbo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.igboGreen.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
    }
}
