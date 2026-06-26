import Foundation

enum LearnerProfile: String, CaseIterable {
    case child, adult, both

    var title: String {
        switch self {
        case .child: return "My child"
        case .adult: return "Myself (adult)"
        case .both:  return "Both of us"
        }
    }

    var description: String {
        switch self {
        case .child: return "Fun, visual, gamified lessons"
        case .adult: return "Structured lessons with grammar notes"
        case .both:  return "Adaptive — switch modes anytime"
        }
    }

    var emoji: String {
        switch self {
        case .child: return "🧒"
        case .adult: return "🧑"
        case .both:  return "👨‍👩‍👧"
        }
    }
}

@Observable
final class AppState {
    static let shared = AppState()

    var learnerProfile: LearnerProfile {
        get {
            LearnerProfile(rawValue: UserDefaults.standard.string(forKey: "learner_profile") ?? "") ?? .both
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "learner_profile")
        }
    }

    var isKidMode: Bool {
        get { UserDefaults.standard.bool(forKey: "kid_mode") }
        set { UserDefaults.standard.set(newValue, forKey: "kid_mode") }
    }

    var savedWordIDs: Set<String> {
        get { Set(UserDefaults.standard.stringArray(forKey: "saved_words") ?? []) }
        set { UserDefaults.standard.set(Array(newValue), forKey: "saved_words") }
    }

    func toggleSaved(_ word: WordPair) {
        var ids = savedWordIDs
        if ids.contains(word.english) { ids.remove(word.english) } else { ids.insert(word.english) }
        savedWordIDs = ids
    }

    func isSaved(_ word: WordPair) -> Bool { savedWordIDs.contains(word.english) }

    // Streak
    var streakCount: Int {
        get { UserDefaults.standard.integer(forKey: "streak_count") }
        set { UserDefaults.standard.set(newValue, forKey: "streak_count") }
    }

    var lastActiveDate: Date? {
        get { UserDefaults.standard.object(forKey: "last_active_date") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "last_active_date") }
    }

    var wordsLearned: Int {
        get { UserDefaults.standard.integer(forKey: "words_learned") }
        set { UserDefaults.standard.set(newValue, forKey: "words_learned") }
    }

    var lessonsCompleted: Int {
        get { UserDefaults.standard.integer(forKey: "lessons_completed") }
        set { UserDefaults.standard.set(newValue, forKey: "lessons_completed") }
    }

    func recordActivity() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastActiveDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1 { streakCount += 1 }
            else if diff > 1 { streakCount = 1 }
            // diff == 0 means already active today — no change
        } else {
            streakCount = 1
        }
        lastActiveDate = today
    }
}
