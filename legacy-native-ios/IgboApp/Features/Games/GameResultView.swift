import SwiftUI

struct GameResultView: View {
    let score: Int
    let total: Int
    let onReplay: () -> Void
    var extraInfo: String? = nil
    let onDone: () -> Void

    var percentage: Int { Int(Double(score) / Double(total) * 100) }

    var medal: String {
        if percentage == 100 { return "🥇" }
        if percentage >= 80  { return "🥈" }
        if percentage >= 60  { return "🥉" }
        return "📚"
    }

    var message: String {
        if percentage == 100 { return "Perfect score! Incredible!" }
        if percentage >= 80  { return "Excellent! You're getting it." }
        if percentage >= 60  { return "Good effort — keep practising!" }
        return "Keep going — practice makes perfect!"
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            Text(medal).font(.system(size: 80))

            VStack(spacing: 8) {
                Text("\(score)/\(total)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(Color.igboGreen)
                Text("\(percentage)%")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                if let extra = extraInfo {
                    Text(extra)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button(action: onReplay) {
                    Label("Play Again", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.igboGreen)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button("Done", action: onDone)
                    .foregroundStyle(Color.igboGreen)
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}
