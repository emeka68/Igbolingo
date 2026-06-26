import Foundation

// Simplified SM-2 spaced repetition.
// Intervals (days): 1 → 3 → 7 → 14 → 30 → 60 → 120 (then stays at 120)
// Rating "Easy" advances the interval; "Hard" resets to day 1.

private let intervals: [Int] = [1, 3, 7, 14, 30, 60, 120]

struct WordReviewRecord: Codable {
    var wordID: String          // WordPair.english used as stable ID
    var igbo: String
    var english: String
    var pronunciation: String
    var emoji: String?
    var intervalIndex: Int      // index into `intervals` array
    var nextReviewDate: Date

    var isDue: Bool {
        nextReviewDate <= Date()
    }

    var intervalDays: Int {
        intervals[min(intervalIndex, intervals.count - 1)]
    }

    mutating func recordEasy() {
        intervalIndex = min(intervalIndex + 1, intervals.count - 1)
        nextReviewDate = Calendar.current.date(
            byAdding: .day,
            value: intervals[intervalIndex],
            to: Date()
        ) ?? Date()
    }

    mutating func recordHard() {
        intervalIndex = 0
        nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
}

@Observable
final class SpacedRepetitionStore {
    static let shared = SpacedRepetitionStore()

    private let key = "sr_word_records"

    var records: [WordReviewRecord] {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let decoded = try? JSONDecoder().decode([WordReviewRecord].self, from: data)
            else { return [] }
            return decoded
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }

    var dueCount: Int { records.filter { $0.isDue }.count }
    var dueWords: [WordReviewRecord] { records.filter { $0.isDue }.shuffled() }

    // Enroll a word if not already tracked
    func enroll(_ word: WordPair) {
        var current = records
        guard !current.contains(where: { $0.wordID == word.english }) else { return }
        let record = WordReviewRecord(
            wordID: word.english,
            igbo: word.igbo,
            english: word.english,
            pronunciation: word.pronunciation,
            emoji: word.emoji,
            intervalIndex: 0,
            nextReviewDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        )
        current.append(record)
        records = current
    }

    func unenroll(wordID: String) {
        records = records.filter { $0.wordID != wordID }
    }

    func markEasy(wordID: String) {
        var current = records
        if let i = current.firstIndex(where: { $0.wordID == wordID }) {
            current[i].recordEasy()
        }
        records = current
    }

    func markHard(wordID: String) {
        var current = records
        if let i = current.firstIndex(where: { $0.wordID == wordID }) {
            current[i].recordHard()
        }
        records = current
    }

    func record(for wordID: String) -> WordReviewRecord? {
        records.first { $0.wordID == wordID }
    }
}
