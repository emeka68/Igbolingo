import SwiftUI

struct CultureView: View {
    @State private var selectedTab: CultureTab = .stories

    enum CultureTab: String, CaseIterable {
        case stories = "Stories"
        case culture = "Culture"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedTab) {
                    ForEach(CultureTab.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                switch selectedTab {
                case .stories: StoriesListView()
                case .culture: CultureHistoryView()
                }
            }
            .navigationTitle("Omenala — Culture")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.igboBackground)
        }
    }
}
