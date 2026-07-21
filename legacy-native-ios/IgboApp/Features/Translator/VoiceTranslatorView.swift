import SwiftUI

struct VoiceTranslatorView: View {
    @State private var speechService = SpeechService()
    @State private var igboTranslation = ""
    @State private var isTranslating = false
    @State private var errorMessage: String?
    @State private var hasPermission = false
    @State private var conversationHistory: [ConversationEntry] = []

    var body: some View {
        VStack(spacing: 0) {
            // Conversation history
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(conversationHistory) { entry in
                            ConversationBubble(entry: entry, speechService: speechService)
                                .id(entry.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: conversationHistory.count) { _, _ in
                    if let last = conversationHistory.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            Divider()

            // Live transcript preview
            if !speechService.transcript.isEmpty || speechService.isListening {
                HStack {
                    if speechService.isListening {
                        Circle().fill(Color.red).frame(width: 8, height: 8)
                            .opacity(speechService.isListening ? 1 : 0)
                            .animation(.easeInOut(duration: 0.6).repeatForever(), value: speechService.isListening)
                    }
                    Text(speechService.transcript.isEmpty ? "Listening…" : speechService.transcript)
                        .font(.subheadline)
                        .foregroundStyle(speechService.transcript.isEmpty ? .secondary : .primary)
                        .lineLimit(2)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.igboCard)
            }

            // Controls
            VStack(spacing: 12) {
                if !hasPermission {
                    Button("Enable Microphone") {
                        Task {
                            hasPermission = await speechService.requestPermissions()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.igboGreen)
                } else {
                    HStack(spacing: 20) {
                        // Mic button
                        Button {
                            toggleListening()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(speechService.isListening ? Color.red : Color.igboGreen)
                                    .frame(width: 72, height: 72)
                                    .shadow(radius: speechService.isListening ? 8 : 2)

                                Image(systemName: speechService.isListening ? "stop.fill" : "mic.fill")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                        }
                        .scaleEffect(speechService.isListening ? 1.1 : 1.0)
                        .animation(.spring, value: speechService.isListening)

                        if isTranslating {
                            VStack {
                                ProgressView()
                                Text("Translating…").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }

                    Text(speechService.isListening ? "Tap to stop and translate" : "Tap to speak in English")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red).font(.caption)
                }
            }
            .padding()
            .background(Color.igboBackground)
        }
        .task {
            hasPermission = await speechService.requestPermissions()
        }
    }

    private func toggleListening() {
        if speechService.isListening {
            speechService.stopListening()
            let spoken = speechService.transcript
            guard !spoken.isEmpty else { return }
            Task { await translateAndAppend(spoken) }
        } else {
            do {
                try speechService.startListening()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func translateAndAppend(_ text: String) async {
        isTranslating = true
        errorMessage = nil
        defer { isTranslating = false }
        do {
            let igbo = try await ClaudeService.shared.translateSpeech(text)
            let entry = ConversationEntry(english: text, igbo: igbo)
            conversationHistory.append(entry)
            speechService.speak(igbo)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ConversationEntry: Identifiable {
    let id = UUID()
    let english: String
    let igbo: String
}

struct ConversationBubble: View {
    let entry: ConversationEntry
    let speechService: SpeechService

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // English
            HStack {
                Text(entry.english)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 16))
                Spacer()
            }

            // Igbo
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    Text(entry.igbo)
                        .foregroundStyle(.white)

                    Button {
                        speechService.speak(entry.igbo)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.igboGreen, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}
