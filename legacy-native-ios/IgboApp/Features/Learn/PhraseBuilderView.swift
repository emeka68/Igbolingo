import SwiftUI

struct PhraseCategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let emoji: String
    let phrases: [WordPair]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: PhraseCategory, r: PhraseCategory) -> Bool { l.id == r.id }
}

let phraseCategories: [PhraseCategory] = [
    PhraseCategory(title: "Everyday", emoji: "☀️", phrases: OfflineWordBank.phrases),
    PhraseCategory(title: "Greetings", emoji: "👋", phrases: OfflineWordBank.greetings),
    PhraseCategory(title: "Family Talk", emoji: "👨‍👩‍👧", phrases: familyPhrases),
    PhraseCategory(title: "At School", emoji: "🏫", phrases: schoolPhrases),
    PhraseCategory(title: "Food & Eating", emoji: "🍽️", phrases: foodPhrases),
]

private let familyPhrases: [WordPair] = [
    WordPair(english: "I love you, Mum",       igbo: "A hụrụ m gị n'anya, Nne",     pronunciation: "ah HOO-roo mm ghee n-AH-nyah nn-EH",     emoji: "❤️"),
    WordPair(english: "I love you, Dad",        igbo: "A hụrụ m gị n'anya, Nna",     pronunciation: "ah HOO-roo mm ghee n-AH-nyah nn-AH",     emoji: "❤️"),
    WordPair(english: "Come and eat",           igbo: "Bia rie nri",                  pronunciation: "BEE-ah REE-yeh n-REE",                    emoji: "🍽️"),
    WordPair(english: "Good night",             igbo: "Ka chi fo",                    pronunciation: "kah CHEE foh",                            emoji: "🌙"),
    WordPair(english: "Wake up",               igbo: "Bilite",                        pronunciation: "BEE-lee-teh",                             emoji: "⏰"),
    WordPair(english: "Well done",             igbo: "Ọ dị mma",                     pronunciation: "oh dee MAH",                              emoji: "👏"),
    WordPair(english: "Be careful",            igbo: "Dị ndụ",                       pronunciation: "dee n-DOO",                               emoji: "⚠️"),
    WordPair(english: "I miss you",            igbo: "Achọpụtara m gị",              pronunciation: "ah-CHOH-poo-tah-rah mm ghee",             emoji: "🥺"),
]

private let schoolPhrases: [WordPair] = [
    WordPair(english: "I don't understand",    igbo: "Enweghị m nghọta",             pronunciation: "en-WEH-ghee mm n-GHOH-tah",              emoji: "🤷"),
    WordPair(english: "Can you repeat that?",  igbo: "Biko kwuo ya ọzọ",             pronunciation: "BEE-koh KWOO-oh yah oh-ZOH",             emoji: "🔁"),
    WordPair(english: "How do you spell it?",  igbo: "Kedu ka e si dee ya?",          pronunciation: "KEH-doo kah eh SEE deh yah",             emoji: "✏️"),
    WordPair(english: "I know the answer",     igbo: "Ama m azịza ya",               pronunciation: "ah-MAH mm ah-ZEE-zah yah",               emoji: "🙋"),
    WordPair(english: "Can I go to toilet?",   igbo: "Enwere m ikwu aga ụlọ mmiri?", pronunciation: "en-WEH-reh mm ee-KWOO ah-GAH oo-LOH mm-EE-ree", emoji: "🚽"),
    WordPair(english: "Book",                  igbo: "Akwụkwọ",                      pronunciation: "ah-KWOO-kwoh",                           emoji: "📚"),
    WordPair(english: "Teacher",               igbo: "Onye nkuzi",                   pronunciation: "oh-NYEH n-KOO-zee",                      emoji: "👩‍🏫"),
    WordPair(english: "Friend",                igbo: "Enyi",                         pronunciation: "EH-nyee",                                emoji: "🤝"),
]

private let foodPhrases: [WordPair] = [
    WordPair(english: "I am hungry",           igbo: "Agụụ na-atọ m",               pronunciation: "ah-GWOO nah ah-TOH mm",                  emoji: "😋"),
    WordPair(english: "I am thirsty",          igbo: "Ọnụ ọ na-agwa m mmiri",       pronunciation: "oh-NOO oh nah ah-GWAH mm mm-EE-ree",     emoji: "😤"),
    WordPair(english: "It is delicious",       igbo: "Ọ dị ụtọ",                   pronunciation: "oh dee oo-TOH",                           emoji: "😋"),
    WordPair(english: "I am full",             igbo: "Afọ juola m",                  pronunciation: "ah-FOH joo-OH-lah mm",                   emoji: "😌"),
    WordPair(english: "More food please",      igbo: "Biko nye m nri ọzọ",          pronunciation: "BEE-koh NYEH mm n-REE oh-ZOH",           emoji: "🍽️"),
    WordPair(english: "What are we eating?",   igbo: "Gịnị ka anyị ga-eri?",        pronunciation: "ghee-NEE kah ah-NYEE gah EH-ree",        emoji: "❓"),
    WordPair(english: "Cook the food",         igbo: "Sie nri",                      pronunciation: "SEE-yeh n-REE",                          emoji: "👨‍🍳"),
    WordPair(english: "Eat your food",         igbo: "Rie nri gị",                  pronunciation: "REE-yeh n-REE ghee",                     emoji: "🍴"),
]

struct PhraseBuilderView: View {
    @State private var selectedCategory: PhraseCategory?
    @State private var appState = AppState.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                    // Intro
                    HStack(spacing: 12) {
                        Text("💬").font(.largeTitle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Speak in full sentences")
                                .font(.headline)
                            Text("Tap a phrase to hear it spoken")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.igboGreen.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

                    ForEach(phraseCategories) { category in
                        PhraseCategorySection(category: category, isKidMode: appState.isKidMode)
                    }
                }
                .padding(.vertical)
        }
        .navigationTitle("Phrases")
        .background(Color.igboBackground)
    }
}

struct PhraseCategorySection: View {
    let category: PhraseCategory
    let isKidMode: Bool
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            // Header — tap to expand
            Button {
                withAnimation(.spring) { isExpanded.toggle() }
            } label: {
                HStack {
                    Text(category.emoji).font(.title2)
                    Text(category.title).font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(category.phrases) { phrase in
                        PhraseRow(phrase: phrase, isKidMode: isKidMode)
                    }
                }
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}

struct PhraseRow: View {
    let phrase: WordPair
    let isKidMode: Bool
    @State private var isPlaying = false
    @State private var appState = AppState.shared

    var body: some View {
        HStack(spacing: 12) {
            if let emoji = phrase.emoji {
                Text(emoji).font(isKidMode ? .title : .title2)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(phrase.igbo)
                    .font(isKidMode ? .headline : .subheadline.bold())
                    .foregroundStyle(Color.igboGreen)
                Text(phrase.english)
                    .font(isKidMode ? .subheadline : .caption)
                    .foregroundStyle(.secondary)
                Text(phrase.pronunciation)
                    .font(.caption)
                    .foregroundStyle(Color.igboGreen.opacity(0.7))
            }

            Spacer()

            HStack(spacing: 10) {
                SaveWordButton(word: phrase)

                Button {
                    isPlaying = true
                    AudioService.shared.speak(phrase.igbo)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { isPlaying = false }
                } label: {
                    Image(systemName: isPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                        .foregroundStyle(isPlaying ? Color.igboGold : Color.igboGreen)
                        .font(isKidMode ? .title2 : .body)
                }
            }
        }
        .padding()
        .background(Color.igboCard, in: RoundedRectangle(cornerRadius: 12))
    }
}
