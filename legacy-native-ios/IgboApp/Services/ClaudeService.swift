import Foundation
import UIKit

struct TranslationResult: Codable {
    let igbo: String
    let pronunciation: String
    let tones: String
    let example: String?
    let exampleTranslation: String?
}

struct LessonContent: Codable {
    let title: String
    let words: [WordPair]
    let culturalNote: String?
}

struct WordPair: Codable, Identifiable {
    var id: String { english }
    let english: String
    let igbo: String
    let pronunciation: String
    let emoji: String?
}

actor ClaudeService {
    static let shared = ClaudeService()

    private let baseURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-sonnet-4-6"

    private var apiKey: String {
        // Read from UserDefaults so the user can set it in-app
        UserDefaults.standard.string(forKey: "claude_api_key") ?? ""
    }

    // MARK: - Text Translation

    func translate(text: String) async throws -> TranslationResult {
        let prompt = """
        Translate the following English text to Igbo. Return ONLY valid JSON with this structure:
        {
          "igbo": "<igbo translation with correct tone marks>",
          "pronunciation": "<simple phonetic guide for English speakers>",
          "tones": "<explanation of tone marks used, e.g. ị is low tone>",
          "example": "<a short Igbo example sentence using the word>",
          "exampleTranslation": "<English translation of the example>"
        }

        Text to translate: "\(text)"
        """
        let response = try await sendMessage(prompt: prompt)
        return try parseJSON(TranslationResult.self, from: response)
    }

    // MARK: - Image Translation

    func culturalNote(for topic: String) async throws -> String {
        let prompt = """
        Give one short (1-2 sentence) interesting cultural fact about the Igbo people related to "\(topic)".
        Return ONLY the plain text fact, no JSON, no preamble.
        """
        return try await sendMessage(prompt: prompt)
    }

    func translateImage(_ image: UIImage) async throws -> [WordPair] {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ClaudeError.imageEncodingFailed
        }
        let base64 = imageData.base64EncodedString()

        let prompt = """
        Look at this image and identify the main objects visible. For each object, provide the Igbo name.
        Return ONLY valid JSON as an array:
        [
          {
            "english": "<object name>",
            "igbo": "<igbo name with tone marks>",
            "pronunciation": "<phonetic guide>",
            "emoji": "<relevant emoji>"
          }
        ]
        Limit to the 5 most prominent objects. Focus on everyday nouns that are useful to learn.
        """

        let response = try await sendMessageWithImage(prompt: prompt, base64Image: base64)
        return try parseJSON([WordPair].self, from: response)
    }

    // MARK: - Live Voice Translation

    func translateSpeech(_ text: String) async throws -> String {
        let prompt = """
        Translate this spoken English to Igbo for a real-time conversation.
        Return ONLY the Igbo translation with correct tone marks. Nothing else.
        Keep it natural and conversational.

        English: "\(text)"
        """
        return try await sendMessage(prompt: prompt)
    }

    // MARK: - Lesson Generation

    func generateLesson(topic: String, level: LearningLevel) async throws -> LessonContent {
        let levelDesc = level == .child ? "a young child (ages 4-10), using simple words and fun examples" : "an adult beginner"
        let prompt = """
        Create an Igbo language lesson about "\(topic)" for \(levelDesc).
        Return ONLY valid JSON:
        {
          "title": "<lesson title>",
          "words": [
            {
              "english": "<word>",
              "igbo": "<igbo with tone marks>",
              "pronunciation": "<phonetic>",
              "emoji": "<emoji>"
            }
          ],
          "culturalNote": "<optional interesting cultural fact about Igbo language or culture>"
        }
        Include 6-8 words. Make the words practical and commonly used.
        """
        let response = try await sendMessage(prompt: prompt)
        return try parseJSON(LessonContent.self, from: response)
    }

    // MARK: - Quiz Question

    func generateQuiz(from words: [WordPair]) async throws -> [QuizQuestion] {
        let wordList = words.map { "\($0.english) = \($0.igbo)" }.joined(separator: "\n")
        let prompt = """
        Create 5 multiple-choice quiz questions from these English-Igbo word pairs:
        \(wordList)

        Return ONLY valid JSON as an array:
        [
          {
            "question": "<question text>",
            "correctAnswer": "<correct answer>",
            "wrongAnswers": ["<wrong1>", "<wrong2>", "<wrong3>"]
          }
        ]
        Mix question types: some ask for the Igbo word, some ask for the English meaning.
        """
        let response = try await sendMessage(prompt: prompt)
        return try parseJSON([QuizQuestion].self, from: response)
    }

    // MARK: - Private helpers

    private func sendMessage(prompt: String) async throws -> String {
        let body: [String: Any] = [
            "model": model,
            "max_tokens": 1024,
            "messages": [["role": "user", "content": prompt]]
        ]
        return try await performRequest(body: body)
    }

    private func sendMessageWithImage(prompt: String, base64Image: String) async throws -> String {
        let body: [String: Any] = [
            "model": model,
            "max_tokens": 1024,
            "messages": [[
                "role": "user",
                "content": [
                    ["type": "image", "source": ["type": "base64", "media_type": "image/jpeg", "data": base64Image]],
                    ["type": "text", "text": prompt]
                ]
            ]]
        ]
        return try await performRequest(body: body)
    }

    private func performRequest(body: [String: Any]) async throws -> String {
        guard !apiKey.isEmpty else { throw ClaudeError.missingAPIKey }

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else { throw ClaudeError.invalidResponse }
        guard http.statusCode == 200 else {
            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ClaudeError.apiError(http.statusCode, msg)
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let content = (json?["content"] as? [[String: Any]])?.first
        guard let text = content?["text"] as? String else { throw ClaudeError.invalidResponse }
        return text
    }

    private func parseJSON<T: Decodable>(_ type: T.Type, from text: String) throws -> T {
        // Strip markdown code fences if present
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("```") {
            cleaned = cleaned.components(separatedBy: "\n").dropFirst().dropLast().joined(separator: "\n")
        }
        guard let data = cleaned.data(using: .utf8) else { throw ClaudeError.parseError }
        return try JSONDecoder().decode(type, from: data)
    }
}

enum ClaudeError: LocalizedError {
    case missingAPIKey
    case imageEncodingFailed
    case invalidResponse
    case apiError(Int, String)
    case parseError

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "Please add your Claude API key in Settings."
        case .imageEncodingFailed: return "Could not process the image."
        case .invalidResponse: return "Unexpected response from the server."
        case .apiError(let code, let msg): return "API error \(code): \(msg)"
        case .parseError: return "Could not read the translation response."
        }
    }
}

enum LearningLevel {
    case child, adult
}
