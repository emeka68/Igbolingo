import Foundation

struct QuizQuestion: Codable, Identifiable {
    var id = UUID()
    let question: String
    let correctAnswer: String
    let wrongAnswers: [String]

    var allAnswers: [String] {
        (wrongAnswers + [correctAnswer]).shuffled()
    }

    enum CodingKeys: String, CodingKey {
        case question, correctAnswer, wrongAnswers
    }
}
