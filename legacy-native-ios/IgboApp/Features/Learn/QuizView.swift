import SwiftUI

struct QuizView: View {
    let words: [WordPair]
    let isKidMode: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var questions: [QuizQuestion] = []
    @State private var currentIndex = 0
    @State private var selectedAnswer: String?
    @State private var score = 0
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var quizFinished = false

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text(isKidMode ? "Making your quiz… 🎯" : "Generating quiz…")
                            .foregroundStyle(.secondary)
                    }
                } else if let errorMessage {
                    ContentUnavailableView("Quiz unavailable", systemImage: "wifi.slash",
                                          description: Text(errorMessage))
                } else if quizFinished {
                    QuizResultView(score: score, total: questions.count, isKidMode: isKidMode) {
                        Task { await loadQuiz() }
                    }
                } else if let question = currentQuestion {
                    QuizQuestionView(
                        question: question,
                        questionNumber: currentIndex + 1,
                        total: questions.count,
                        isKidMode: isKidMode,
                        selectedAnswer: $selectedAnswer,
                        onNext: nextQuestion
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.igboBackground)
            .navigationTitle(isKidMode ? "Quiz Time! ✏️" : "Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .task { await loadQuiz() }
        }
    }

    private func loadQuiz() async {
        isLoading = true
        quizFinished = false
        currentIndex = 0
        score = 0
        selectedAnswer = nil
        errorMessage = nil
        defer { isLoading = false }
        do {
            questions = try await ClaudeService.shared.generateQuiz(from: words)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func nextQuestion() {
        if selectedAnswer == currentQuestion?.correctAnswer { score += 1 }
        selectedAnswer = nil
        if currentIndex + 1 < questions.count {
            withAnimation { currentIndex += 1 }
        } else {
            quizFinished = true
        }
    }
}

struct QuizQuestionView: View {
    let question: QuizQuestion
    let questionNumber: Int
    let total: Int
    let isKidMode: Bool
    @Binding var selectedAnswer: String?
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: isKidMode ? 28 : 24) {
            ProgressView(value: Double(questionNumber), total: Double(total))
                .tint(Color.igboGreen)
                .padding(.horizontal)

            Text("Question \(questionNumber) of \(total)")
                .font(isKidMode ? .headline : .subheadline)
                .foregroundStyle(.secondary)

            Text(question.question)
                .font(isKidMode ? .title2.bold() : .title3.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: isKidMode ? 14 : 12) {
                ForEach(question.allAnswers, id: \.self) { answer in
                    AnswerButton(
                        answer: answer,
                        isSelected: selectedAnswer == answer,
                        isCorrect: answer == question.correctAnswer,
                        hasAnswered: selectedAnswer != nil,
                        isKidMode: isKidMode
                    ) {
                        if selectedAnswer == nil {
                            withAnimation { selectedAnswer = answer }
                            if answer == question.correctAnswer {
                                AudioService.shared.speak("Correct!")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)

            if selectedAnswer != nil {
                Button(action: onNext) {
                    Text(questionNumber == total ? (isKidMode ? "See my score! 🏆" : "See Results") : (isKidMode ? "Next question ➡️" : "Next Question"))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(isKidMode ? 18 : 14)
                        .background(Color.igboGreen)
                        .foregroundStyle(.white)
                        .font(isKidMode ? .headline : .body)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer()
        }
        .padding(.top)
        .animation(.spring, value: selectedAnswer)
    }
}

struct AnswerButton: View {
    let answer: String
    let isSelected: Bool
    let isCorrect: Bool
    let hasAnswered: Bool
    let isKidMode: Bool
    let action: () -> Void

    var backgroundColor: Color {
        if !hasAnswered { return Color.igboCard }
        if isCorrect { return Color.igboGreen.opacity(0.2) }
        if isSelected { return Color.igboRed.opacity(0.2) }
        return Color.igboCard
    }

    var borderColor: Color {
        if !hasAnswered { return Color.clear }
        if isCorrect { return Color.igboGreen }
        if isSelected { return Color.igboRed }
        return Color.clear
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer)
                    .font(isKidMode ? .headline : .body)
                    .multilineTextAlignment(.leading)
                Spacer()
                if hasAnswered {
                    if isCorrect {
                        Text(isKidMode ? "✅" : "").font(.title2)
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.igboGreen)
                    } else if isSelected {
                        Text(isKidMode ? "❌" : "").font(.title2)
                        Image(systemName: "xmark.circle.fill").foregroundStyle(Color.igboRed)
                    }
                }
            }
            .padding(isKidMode ? 16 : 14)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: isKidMode ? 16 : 14))
            .overlay(RoundedRectangle(cornerRadius: isKidMode ? 16 : 14).stroke(borderColor, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .animation(.spring, value: hasAnswered)
    }
}

struct QuizResultView: View {
    let score: Int
    let total: Int
    let isKidMode: Bool
    let onRetry: () -> Void
    @Environment(\.dismiss) private var dismiss

    var percentage: Int { Int((Double(score) / Double(total)) * 100) }
    var emoji: String {
        if percentage >= 80 { return isKidMode ? "🏆🌟🎊" : "🏆" }
        if percentage >= 60 { return isKidMode ? "👍😊" : "👍" }
        return isKidMode ? "📚💪" : "📚"
    }
    var message: String {
        if percentage >= 80 { return isKidMode ? "WOW! You're amazing! 🎉" : "Excellent work!" }
        if percentage >= 60 { return isKidMode ? "Great job! Keep going! 💪" : "Good effort! Keep practising." }
        return isKidMode ? "Keep practising — you've got this! 🌟" : "Keep learning — you'll get there!"
    }

    var body: some View {
        VStack(spacing: isKidMode ? 28 : 24) {
            Text(emoji).font(.system(size: isKidMode ? 72 : 60))

            VStack(spacing: 8) {
                Text("\(score)/\(total)")
                    .font(.system(size: isKidMode ? 72 : 60, weight: .bold))
                    .foregroundStyle(Color.igboGreen)
                Text("\(percentage)% correct")
                    .font(isKidMode ? .title2 : .title3)
                    .foregroundStyle(.secondary)
            }

            Text(message)
                .font(isKidMode ? .title3.bold() : .headline)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button(isKidMode ? "Try Again! 🔄" : "Try Again", action: onRetry)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.igboGreen)
                    .font(isKidMode ? .headline : .body)

                Button("Done") { dismiss() }
                    .foregroundStyle(Color.igboGreen)
                    .font(isKidMode ? .headline : .body)
            }
        }
        .padding()
    }
}
