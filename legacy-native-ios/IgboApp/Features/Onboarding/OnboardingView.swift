import SwiftUI

struct OnboardingView: View {
    @AppStorage("claude_api_key") private var apiKey = ""
    @AppStorage("onboarding_complete") private var onboardingComplete = false
    @AppStorage("learner_profile") private var learnerProfileRaw = ""

    @State private var page = 0
    @State private var keyInput = ""
    @State private var isValidating = false
    @State private var validationError: String?
    @State private var selectedProfile: LearnerProfile?

    var body: some View {
        TabView(selection: $page) {
            WelcomePage().tag(0)
            ProfilePickerPage(selected: $selectedProfile, onNext: { page = 2 }).tag(1)
            APIKeyPage(
                keyInput: $keyInput,
                isValidating: $isValidating,
                validationError: $validationError,
                onConfirm: validateAndFinish
            ).tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            if page == 0 {
                Button("Next") { withAnimation { page = 1 } }
                    .padding()
                    .padding(.top, 48)
            }
        }
        .tint(Color.igboGreen)
    }

    private func validateAndFinish() {
        guard !keyInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            validationError = "Please enter your API key."
            return
        }
        isValidating = true
        validationError = nil
        Task {
            UserDefaults.standard.set(keyInput.trimmingCharacters(in: .whitespaces), forKey: "claude_api_key")
            do {
                // Quick sanity-check translation
                _ = try await ClaudeService.shared.translate(text: "hello")
                if let profile = selectedProfile {
                    UserDefaults.standard.set(profile.rawValue, forKey: "learner_profile")
                }
                onboardingComplete = true
            } catch ClaudeError.missingAPIKey {
                validationError = "No API key provided."
            } catch {
                validationError = "Could not connect: \(error.localizedDescription)"
            }
            isValidating = false
        }
    }
}

// MARK: - Pages

struct WelcomePage: View {
    var body: some View {
        ZStack {
            Color.igboGreen.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                Text("🇳🇬").font(.system(size: 96))
                VStack(spacing: 8) {
                    Text("Igbolingo").font(.system(size: 42, weight: .bold)).foregroundStyle(.white)
                    Text("Learn and translate Igbo\nwith your family")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
                Spacer()
                VStack(spacing: 12) {
                    FeaturePill(icon: "globe", text: "Translate text, images & speech")
                    FeaturePill(icon: "book.fill", text: "Interactive lessons & quizzes")
                    FeaturePill(icon: "speaker.wave.2.fill", text: "Hear native-style pronunciation")
                }
                .padding(.horizontal)
                Spacer()
                Text("Swipe to get started →")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.bottom, 48)
            }
            .padding()
        }
    }
}

struct FeaturePill: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).frame(width: 24)
            Text(text).font(.subheadline)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding()
        .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct ProfilePickerPage: View {
    @Binding var selected: LearnerProfile?
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack(spacing: 8) {
                Text("Who's learning?").font(.largeTitle.bold())
                Text("We'll tailor the experience for you.")
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                ProfileCard(
                    profile: .child,
                    isSelected: selected == .child,
                    onTap: { selected = .child }
                )
                ProfileCard(
                    profile: .adult,
                    isSelected: selected == .adult,
                    onTap: { selected = .adult }
                )
                ProfileCard(
                    profile: .both,
                    isSelected: selected == .both,
                    onTap: { selected = .both }
                )
            }
            .padding(.horizontal)

            Spacer()

            Button(action: onNext) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selected != nil ? Color.igboGreen : Color.gray)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(selected == nil)
            .padding(.horizontal)
            .padding(.bottom, 48)
        }
        .padding(.top, 80)
    }
}

struct ProfileCard: View {
    let profile: LearnerProfile
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(profile.emoji).font(.largeTitle)
                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.title).font(.headline)
                    Text(profile.description).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.igboGreen).font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.igboCard)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? Color.igboGreen : Color.clear, lineWidth: 2))
            )
        }
        .buttonStyle(.plain)
        .animation(.spring, value: isSelected)
    }
}

struct APIKeyPage: View {
    @Binding var keyInput: String
    @Binding var isValidating: Bool
    @Binding var validationError: String?
    let onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 80)

                VStack(spacing: 8) {
                    Text("Connect to Claude AI").font(.largeTitle.bold())
                    Text("Igbolingo uses Claude to power translations and lessons.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Your API Key").font(.subheadline.bold())
                    SecureField("sk-ant-api03-…", text: $keyInput)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 14))

                    if let error = validationError {
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }

                    Text("Get a free key at console.anthropic.com → API Keys. Your key is stored only on this device.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                Button(action: onConfirm) {
                    HStack {
                        if isValidating {
                            ProgressView().tint(.white)
                            Text("Checking…")
                        } else {
                            Text("Start Learning")
                        }
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.igboGreen)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(isValidating || keyInput.isEmpty)
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
