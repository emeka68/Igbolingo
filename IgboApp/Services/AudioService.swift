import AVFoundation
import Foundation

// Handles Igbo pronunciation playback.
// Strategy:
//   1. Ask Claude for a slow phonetic syllable breakdown so pronunciation guides are accurate.
//   2. Play back using AVSpeechSynthesizer with the Nigerian English voice as the closest
//      available approximation (iOS has no native Igbo TTS voice).
//   3. If an ElevenLabs API key is provided, use it for higher-quality output.
@Observable
final class AudioService: NSObject {
    static let shared = AudioService()

    private let synthesizer = AVSpeechSynthesizer()
    private var audioPlayer: AVAudioPlayer?
    var isSpeaking = false

    private var elevenLabsKey: String {
        UserDefaults.standard.string(forKey: "elevenlabs_api_key") ?? ""
    }

    // Voice ID — "Sarah" works reasonably well for Igbo phonemes
    private let elevenLabsVoiceID = "EXAVITQu4vr4xnSDxMaL"

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        if !elevenLabsKey.isEmpty {
            Task { await speakWithElevenLabs(text) }
        } else {
            speakWithAVSpeech(text)
        }
    }

    // MARK: - AVSpeech fallback

    func speakWithAVSpeech(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)

        let utterance = AVSpeechUtterance(string: text)
        // en-NG (Nigerian English) is the closest voice Apple offers
        utterance.voice = AVSpeechSynthesisVoice(language: "en-NG")
            ?? AVSpeechSynthesisVoice(language: "en-GB")
            ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.38     // slow enough to catch syllables
        utterance.pitchMultiplier = 1.1
        isSpeaking = true
        synthesizer.speak(utterance)
    }

    // MARK: - ElevenLabs (optional, higher quality)

    private func speakWithElevenLabs(_ text: String) async {
        guard let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/\(elevenLabsVoiceID)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(elevenLabsKey, forHTTPHeaderField: "xi-api-key")
        let body: [String: Any] = [
            "text": text,
            "model_id": "eleven_multilingual_v2",
            "voice_settings": ["stability": 0.5, "similarity_boost": 0.75]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                speakWithAVSpeech(text)
                return
            }
            audioPlayer = try AVAudioPlayer(data: data)
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
            isSpeaking = true
            audioPlayer?.play()
        } catch {
            speakWithAVSpeech(text)
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        audioPlayer?.stop()
        isSpeaking = false
    }
}

extension AudioService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}
