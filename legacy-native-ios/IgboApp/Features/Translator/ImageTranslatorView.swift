import SwiftUI
import PhotosUI

struct ImageTranslatorView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var wordPairs: [WordPair] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showCamera = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Image picker area
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.igboCard)
                        .frame(height: 240)

                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 48))
                                .foregroundStyle(Color.igboGreen)
                            Text("Take a photo or choose from library")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }

                HStack(spacing: 12) {
                    Button {
                        showCamera = true
                    } label: {
                        Label("Camera", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.igboGreen)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Library", systemImage: "photo.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.igboCard)
                            .foregroundStyle(Color.igboGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.igboGreen, lineWidth: 1.5))
                    }
                }

                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                        .font(.footnote)
                }

                if isLoading {
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("Identifying objects…")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }

                if !wordPairs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Objects Found")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(wordPairs) { pair in
                            ImageWordRow(pair: pair)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding()
            .animation(.spring, value: wordPairs.count)
        }
        .onChange(of: selectedItem) { _, new in
            Task { await loadImage(from: new) }
        }
        .sheet(isPresented: $showCamera) {
            CameraPickerView { image in
                selectedImage = image
                Task { await analyzeImage(image) }
            }
        }
    }

    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            selectedImage = image
            await analyzeImage(image)
        }
    }

    private func analyzeImage(_ image: UIImage) async {
        isLoading = true
        errorMessage = nil
        wordPairs = []
        defer { isLoading = false }
        do {
            wordPairs = try await ClaudeService.shared.translateImage(image)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ImageWordRow: View {
    let pair: WordPair
    @State private var speechService = SpeechService()

    var body: some View {
        HStack {
            if let emoji = pair.emoji {
                Text(emoji).font(.largeTitle)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(pair.igbo)
                    .font(.headline)
                    .foregroundStyle(Color.igboGreen)
                Text(pair.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(pair.pronunciation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                speechService.speak(pair.igbo)
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundStyle(Color.igboGreen)
            }
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 14))
    }
}
