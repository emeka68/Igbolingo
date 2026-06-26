import Foundation
import SwiftUI

// MARK: - Progression Tiers

struct IgboTitle: Identifiable, Equatable {
    let id: Int
    let igbo: String
    let english: String
    let meaning: String
    let emoji: String
    let color: Color

    // Requirements to reach this tier
    let wordsRequired: Int
    let lessonsRequired: Int
    let streakRequired: Int

    static func == (l: IgboTitle, r: IgboTitle) -> Bool { l.id == r.id }
}

let igboTitles: [IgboTitle] = [
    IgboTitle(
        id: 0,
        igbo: "Onye Ọhụrụ",
        english: "The Newcomer",
        meaning: "Every journey begins with a single step. Welcome to the Igbo language.",
        emoji: "🌱",
        color: .gray,
        wordsRequired: 0, lessonsRequired: 0, streakRequired: 0
    ),
    IgboTitle(
        id: 1,
        igbo: "Onye Ọmụmụ",
        english: "The Student",
        meaning: "You have begun to learn. The Igbo say: 'Onye wetara oji wetara ndụ' — you have brought life to your mind.",
        emoji: "📖",
        color: Color(red: 0.4, green: 0.6, blue: 0.9),
        wordsRequired: 10, lessonsRequired: 1, streakRequired: 0
    ),
    IgboTitle(
        id: 2,
        igbo: "Onye Chọọ Ihe",
        english: "The Seeker",
        meaning: "You search with purpose. The seeds of the Igbo tongue are taking root in you.",
        emoji: "🔍",
        color: Color(red: 0.3, green: 0.7, blue: 0.7),
        wordsRequired: 30, lessonsRequired: 5, streakRequired: 2
    ),
    IgboTitle(
        id: 3,
        igbo: "Onye Asụsụ",
        english: "The Speaker",
        meaning: "Words are forming on your tongue. You are no longer a stranger to the Igbo language.",
        emoji: "🗣️",
        color: Color(red: 0.2, green: 0.75, blue: 0.5),
        wordsRequired: 60, lessonsRequired: 10, streakRequired: 5
    ),
    IgboTitle(
        id: 4,
        igbo: "Okorobia",
        english: "The Young Brave",
        meaning: "Strong and growing. You show the courage of one who does not turn back from difficulty.",
        emoji: "⚡",
        color: Color(red: 0.9, green: 0.65, blue: 0.1),
        wordsRequired: 100, lessonsRequired: 20, streakRequired: 7
    ),
    IgboTitle(
        id: 5,
        igbo: "Odogwu",
        english: "The Champion",
        meaning: "Odogwu! A title given to those who excel, who show strength of character and persistence. You have earned it.",
        emoji: "🏆",
        color: Color(red: 0.85, green: 0.5, blue: 0.1),
        wordsRequired: 150, lessonsRequired: 30, streakRequired: 14
    ),
    IgboTitle(
        id: 6,
        igbo: "Dibia",
        english: "The Wise One",
        meaning: "The Dibia is the keeper of knowledge — healer, counsellor, wise person. You walk in deep understanding.",
        emoji: "🧠",
        color: Color(red: 0.6, green: 0.2, blue: 0.8),
        wordsRequired: 200, lessonsRequired: 50, streakRequired: 21
    ),
    IgboTitle(
        id: 7,
        igbo: "Ichie",
        english: "The Title Holder",
        meaning: "Ichie is a high honour — given to those whose contributions to their community are beyond question. You honour Igbo culture.",
        emoji: "🦅",
        color: Color(red: 0.13, green: 0.55, blue: 0.33),
        wordsRequired: 300, lessonsRequired: 75, streakRequired: 30
    ),
    IgboTitle(
        id: 8,
        igbo: "Ọzọ",
        english: "The Elder",
        meaning: "The Ọzọ title is one of the highest in Igbo society. You carry the language with the grace of an elder.",
        emoji: "👑",
        color: Color(red: 0.78, green: 0.18, blue: 0.18),
        wordsRequired: 400, lessonsRequired: 100, streakRequired: 60
    ),
    IgboTitle(
        id: 9,
        igbo: "Eze Igbo",
        english: "The Igbo Master",
        meaning: "Eze — King. You have walked the full road. You are a keeper of the Igbo tongue, a guardian of the culture. Daalụ.",
        emoji: "🌟",
        color: Color(red: 0.91, green: 0.69, blue: 0.13),
        wordsRequired: 500, lessonsRequired: 150, streakRequired: 90
    ),
]

// MARK: - Progression Engine

struct ProgressionEngine {
    static func currentTitle(words: Int, lessons: Int, streak: Int) -> IgboTitle {
        // Walk backwards — highest tier the user qualifies for
        for title in igboTitles.reversed() {
            if words >= title.wordsRequired &&
               lessons >= title.lessonsRequired &&
               streak >= title.streakRequired {
                return title
            }
        }
        return igboTitles[0]
    }

    static func nextTitle(current: IgboTitle) -> IgboTitle? {
        guard current.id + 1 < igboTitles.count else { return nil }
        return igboTitles[current.id + 1]
    }

    static func progress(toward next: IgboTitle, words: Int, lessons: Int, streak: Int) -> Double {
        guard next.wordsRequired > 0 || next.lessonsRequired > 0 || next.streakRequired > 0 else { return 1 }

        var scores: [Double] = []
        if next.wordsRequired > 0 {
            scores.append(min(1.0, Double(words) / Double(next.wordsRequired)))
        }
        if next.lessonsRequired > 0 {
            scores.append(min(1.0, Double(lessons) / Double(next.lessonsRequired)))
        }
        if next.streakRequired > 0 {
            scores.append(min(1.0, Double(streak) / Double(next.streakRequired)))
        }
        return scores.reduce(0, +) / Double(scores.count)
    }
}
