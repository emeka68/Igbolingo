import SwiftUI

struct TextTranslatorView: View {
    @State private var inputText = ""
    @State private var result: TranslationResult?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var speechService = SpeechService()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Input card
                VStack(alignment: .leading, spacing: 8) {
                    Text("English")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    TextField("Type a word or phrase…", text: $inputText, axis: .vertical)
                        .font(.title3)
                        .lineLimit(3...6)
                        .submitLabel(.done)
                        .onSubmit { Task { await translate() } }
                }
                .padding()
                .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))

                Button(action: { Task { await translate() } }) {
                    HStack {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        Text(isLoading ? "Translating…" : "Translate to Igbo")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(inputText.isEmpty ? Color.gray : Color.igboGreen)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(inputText.isEmpty || isLoading)

                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                if let result {
                    TranslationResultCard(result: result, speechService: speechService)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding()
            .animation(.spring, value: result != nil)
        }
    }

    private func translate() async {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            result = try await ClaudeService.shared.translate(text: inputText)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct TranslationResultCard: View {
    let result: TranslationResult
    let speechService: SpeechService

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Igbo word
            VStack(alignment: .leading, spacing: 4) {
                Text("Igbo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                HStack(alignment: .top) {
                    Text(result.igbo)
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.igboGreen)

                    Spacer()

                    Button {
                        speechService.speak(result.igbo)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundStyle(Color.igboGreen)
                    }
                }
            }

            Divider()

            // Pronunciation
            InfoRow(label: "Pronunciation", value: result.pronunciation)
            InfoRow(label: "Tone guide", value: result.tones)

            if let example = result.example, let translation = result.exampleTranslation {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Example")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Text(example)
                        .italic()
                        .foregroundStyle(Color.igboGreen)
                    Text(translation)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(value)
                .font(.body)
        }
    }
}
