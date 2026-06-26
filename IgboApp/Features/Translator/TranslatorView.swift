import SwiftUI

enum TranslatorMode: String, CaseIterable {
    case text  = "Text"
    case image = "Camera"
    case voice = "Voice"

    var icon: String {
        switch self {
        case .text:  return "textformat"
        case .image: return "camera.fill"
        case .voice: return "mic.fill"
        }
    }
}

struct TranslatorView: View {
    @State private var mode: TranslatorMode = .text

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Mode", selection: $mode) {
                    ForEach(TranslatorMode.allCases, id: \.self) { m in
                        Label(m.rawValue, systemImage: m.icon).tag(m)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                switch mode {
                case .text:  TextTranslatorView()
                case .image: ImageTranslatorView()
                case .voice: VoiceTranslatorView()
                }
            }
            .navigationTitle("Translate")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.igboBackground)
        }
    }
}
