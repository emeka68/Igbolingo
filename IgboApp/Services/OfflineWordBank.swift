import Foundation

// Pre-baked Igbo vocabulary — no API needed for these.
// Sources: Igbo dictionary / standard orthography with tone marks.
struct OfflineWordBank {
    static let all: [String: [WordPair]] = [
        "Greetings": greetings,
        "Numbers": numbers,
        "Family": family,
        "Food & Drink": food,
        "Animals": animals,
        "Colours": colours,
        "Body Parts": bodyParts,
        "Days & Time": daysTime,
        "Common Phrases": phrases,
    ]

    static func words(for topic: String) -> [WordPair]? {
        all[topic]
    }

    // MARK: - Greetings
    static let greetings: [WordPair] = [
        WordPair(english: "Hello / Welcome",    igbo: "Ndewo",              pronunciation: "n-DEH-woh",         emoji: "👋"),
        WordPair(english: "Good morning",       igbo: "Ụtụtụ ọma",         pronunciation: "oo-TOO-too OH-mah", emoji: "🌅"),
        WordPair(english: "Good afternoon",     igbo: "Ehihie ọma",         pronunciation: "eh-HEE-yeh OH-mah", emoji: "☀️"),
        WordPair(english: "Good evening",       igbo: "Anyasị ọma",         pronunciation: "ah-nyah-SEE OH-mah",emoji: "🌙"),
        WordPair(english: "How are you?",       igbo: "Kedu ka ị dị?",      pronunciation: "KEH-doo kah ee DEE",emoji: "🤝"),
        WordPair(english: "I am fine",          igbo: "A dị m mma",         pronunciation: "ah dee mm MAH",     emoji: "😊"),
        WordPair(english: "Thank you",          igbo: "Daalụ",              pronunciation: "DAH-ah-loo",        emoji: "🙏"),
        WordPair(english: "You are welcome",    igbo: "Ọ dị mma",           pronunciation: "oh DEE mah",        emoji: "😌"),
        WordPair(english: "Please",             igbo: "Biko",               pronunciation: "BEE-koh",           emoji: "🙏"),
        WordPair(english: "Sorry / Excuse me",  igbo: "Ndo",                pronunciation: "n-DOH",             emoji: "😔"),
        WordPair(english: "Goodbye",            igbo: "Ka ọ dị",            pronunciation: "kah oh DEE",        emoji: "👋"),
        WordPair(english: "See you later",      igbo: "Ka anyị hụọ onwe",   pronunciation: "kah ah-nyee HOO oh-nweh", emoji: "👀"),
    ]

    // MARK: - Numbers
    static let numbers: [WordPair] = [
        WordPair(english: "One",    igbo: "Otu",     pronunciation: "OH-too",      emoji: "1️⃣"),
        WordPair(english: "Two",    igbo: "Abụọ",    pronunciation: "ah-BWOH",     emoji: "2️⃣"),
        WordPair(english: "Three",  igbo: "Atọ",     pronunciation: "ah-TOH",      emoji: "3️⃣"),
        WordPair(english: "Four",   igbo: "Anọ",     pronunciation: "ah-NOH",      emoji: "4️⃣"),
        WordPair(english: "Five",   igbo: "Ise",     pronunciation: "ee-SEH",      emoji: "5️⃣"),
        WordPair(english: "Six",    igbo: "Isii",    pronunciation: "ee-SEE",      emoji: "6️⃣"),
        WordPair(english: "Seven",  igbo: "Asaa",    pronunciation: "ah-SAH",      emoji: "7️⃣"),
        WordPair(english: "Eight",  igbo: "Asatọ",   pronunciation: "ah-SAH-toh",  emoji: "8️⃣"),
        WordPair(english: "Nine",   igbo: "Itoolu",  pronunciation: "ee-TOH-loo",  emoji: "9️⃣"),
        WordPair(english: "Ten",    igbo: "Iri",     pronunciation: "ee-REE",      emoji: "🔟"),
        WordPair(english: "Twenty", igbo: "Iri abụọ",pronunciation: "ee-REE ah-BWOH", emoji: "2️⃣0️⃣"),
        WordPair(english: "Hundred",igbo: "Nnari",   pronunciation: "nn-AH-ree",   emoji: "💯"),
    ]

    // MARK: - Family
    static let family: [WordPair] = [
        WordPair(english: "Mother",          igbo: "Nnе",          pronunciation: "nn-EH",          emoji: "👩"),
        WordPair(english: "Father",          igbo: "Nna",          pronunciation: "nn-AH",          emoji: "👨"),
        WordPair(english: "Child",           igbo: "Nwa",          pronunciation: "n-WAH",          emoji: "👶"),
        WordPair(english: "Son",             igbo: "Nwa okenye",   pronunciation: "n-WAH oh-KEH-nyeh", emoji: "👦"),
        WordPair(english: "Daughter",        igbo: "Nwa inyom",    pronunciation: "n-WAH ee-NYOHM", emoji: "👧"),
        WordPair(english: "Brother",         igbo: "Nwa nna",      pronunciation: "n-WAH nn-AH",    emoji: "👦"),
        WordPair(english: "Sister",          igbo: "Nwanne nwanyị", pronunciation: "n-WAHN-neh n-WAH-nyee", emoji: "👧"),
        WordPair(english: "Grandmother",     igbo: "Nnenna",       pronunciation: "nn-EH-nn-AH",    emoji: "👵"),
        WordPair(english: "Grandfather",     igbo: "Nnenna ọkọ",   pronunciation: "nn-EH-nn-AH oh-KOH", emoji: "👴"),
        WordPair(english: "Uncle",           igbo: "Nnanna",       pronunciation: "nn-AH-nn-AH",    emoji: "👨"),
        WordPair(english: "Aunt",            igbo: "Nne ochie",    pronunciation: "nn-EH oh-CHEE-yeh", emoji: "👩"),
        WordPair(english: "Family",          igbo: "Ezinụlọ",      pronunciation: "eh-ZEE-noo-loh", emoji: "👨‍👩‍👧‍👦"),
    ]

    // MARK: - Food & Drink
    static let food: [WordPair] = [
        WordPair(english: "Food",           igbo: "Nri",          pronunciation: "n-REE",          emoji: "🍽️"),
        WordPair(english: "Water",          igbo: "Mmiri",        pronunciation: "mm-EE-ree",      emoji: "💧"),
        WordPair(english: "Rice",           igbo: "Osikapa",      pronunciation: "oh-see-KAH-pah", emoji: "🍚"),
        WordPair(english: "Yam",            igbo: "Ji",           pronunciation: "JEE",            emoji: "🍠"),
        WordPair(english: "Palm oil",       igbo: "Mmanyị nri",   pronunciation: "mm-AH-nyee n-REE", emoji: "🫒"),
        WordPair(english: "Soup",           igbo: "Ofe",          pronunciation: "OH-feh",         emoji: "🥣"),
        WordPair(english: "Pepper soup",    igbo: "Ofe ọse",      pronunciation: "OH-feh OH-seh",  emoji: "🌶️"),
        WordPair(english: "Bread",          igbo: "Ọkụ",          pronunciation: "oh-KOO",         emoji: "🍞"),
        WordPair(english: "Meat",           igbo: "Anụ",          pronunciation: "ah-NOO",         emoji: "🥩"),
        WordPair(english: "Fish",           igbo: "Azụ",          pronunciation: "ah-ZOO",         emoji: "🐟"),
        WordPair(english: "Egg",            igbo: "Àkwa ọkụkọ",  pronunciation: "AH-kwah oh-KOO-koh", emoji: "🥚"),
        WordPair(english: "Banana",         igbo: "Unere",        pronunciation: "oo-NEH-reh",     emoji: "🍌"),
    ]

    // MARK: - Animals
    static let animals: [WordPair] = [
        WordPair(english: "Dog",    igbo: "Nkịta",   pronunciation: "n-KEE-tah",  emoji: "🐕"),
        WordPair(english: "Cat",    igbo: "Pụsị",    pronunciation: "poo-SEE",    emoji: "🐈"),
        WordPair(english: "Goat",   igbo: "Ewu",     pronunciation: "EH-woo",     emoji: "🐐"),
        WordPair(english: "Cow",    igbo: "Efi",     pronunciation: "EH-fee",     emoji: "🐄"),
        WordPair(english: "Chicken",igbo: "Ọkụkọ",  pronunciation: "oh-KOO-koh", emoji: "🐔"),
        WordPair(english: "Bird",   igbo: "Nnụnụ",  pronunciation: "nn-OO-noo",  emoji: "🐦"),
        WordPair(english: "Snake",  igbo: "Agwọ",   pronunciation: "ah-GWOH",    emoji: "🐍"),
        WordPair(english: "Fish",   igbo: "Azụ",    pronunciation: "ah-ZOO",     emoji: "🐟"),
        WordPair(english: "Rat",    igbo: "Ọchẹ",   pronunciation: "oh-CHEH",    emoji: "🐀"),
        WordPair(english: "Pig",    igbo: "Ezi",    pronunciation: "EH-zee",     emoji: "🐷"),
        WordPair(english: "Sheep",  igbo: "Atụrụ",  pronunciation: "ah-TOO-roo", emoji: "🐑"),
        WordPair(english: "Monkey", igbo: "Enwe",   pronunciation: "EH-nweh",    emoji: "🐒"),
    ]

    // MARK: - Colours
    static let colours: [WordPair] = [
        WordPair(english: "Red",    igbo: "Ọbara ọbara", pronunciation: "oh-BAH-rah oh-BAH-rah", emoji: "🔴"),
        WordPair(english: "Blue",   igbo: "Ọcha ọcha",   pronunciation: "oh-CHAH oh-CHAH",       emoji: "🔵"),
        WordPair(english: "Green",  igbo: "Ọchịchọ",     pronunciation: "oh-CHEE-choh",          emoji: "🟢"),
        WordPair(english: "White",  igbo: "Ọcha",        pronunciation: "oh-CHAH",               emoji: "⬜"),
        WordPair(english: "Black",  igbo: "Ojii",        pronunciation: "oh-JEE",                emoji: "⬛"),
        WordPair(english: "Yellow", igbo: "Odo",         pronunciation: "OH-doh",                emoji: "🟡"),
        WordPair(english: "Orange", igbo: "Ọchịichọ",   pronunciation: "oh-CHEE-ee-choh",       emoji: "🟠"),
        WordPair(english: "Brown",  igbo: "Ọcha aja",    pronunciation: "oh-CHAH AH-jah",        emoji: "🟤"),
    ]

    // MARK: - Body Parts
    static let bodyParts: [WordPair] = [
        WordPair(english: "Head",   igbo: "Isi",     pronunciation: "ee-SEE",     emoji: "🗣️"),
        WordPair(english: "Eye",    igbo: "Anya",    pronunciation: "AH-nyah",    emoji: "👁️"),
        WordPair(english: "Ear",    igbo: "Nti",     pronunciation: "n-TEE",      emoji: "👂"),
        WordPair(english: "Nose",   igbo: "Imi",     pronunciation: "ee-MEE",     emoji: "👃"),
        WordPair(english: "Mouth",  igbo: "Ọnụ",    pronunciation: "oh-NOO",     emoji: "👄"),
        WordPair(english: "Hand",   igbo: "Aka",     pronunciation: "AH-kah",     emoji: "✋"),
        WordPair(english: "Foot",   igbo: "Ụkwụ",   pronunciation: "oo-KWOO",    emoji: "🦶"),
        WordPair(english: "Heart",  igbo: "Obi",     pronunciation: "OH-bee",     emoji: "❤️"),
        WordPair(english: "Belly",  igbo: "Afọ",     pronunciation: "ah-FOH",     emoji: "🫁"),
        WordPair(english: "Back",   igbo: "Azụ",     pronunciation: "ah-ZOO",     emoji: "🔙"),
        WordPair(english: "Leg",    igbo: "Ụkwụ",   pronunciation: "oo-KWOO",    emoji: "🦵"),
        WordPair(english: "Tooth",  igbo: "Eze",     pronunciation: "EH-zeh",     emoji: "🦷"),
    ]

    // MARK: - Days & Time
    static let daysTime: [WordPair] = [
        WordPair(english: "Monday",    igbo: "Mọnde",        pronunciation: "MOHN-deh",        emoji: "📅"),
        WordPair(english: "Tuesday",   igbo: "Tụzdee",       pronunciation: "TOOZ-deh",        emoji: "📅"),
        WordPair(english: "Wednesday", igbo: "Wenzdee",      pronunciation: "WENZ-deh",        emoji: "📅"),
        WordPair(english: "Thursday",  igbo: "Tọzdee",       pronunciation: "TOHZ-deh",        emoji: "📅"),
        WordPair(english: "Friday",    igbo: "Fraịdee",      pronunciation: "FRAHY-deh",       emoji: "📅"),
        WordPair(english: "Saturday",  igbo: "Satụdee",      pronunciation: "SAH-too-deh",     emoji: "📅"),
        WordPair(english: "Sunday",    igbo: "Ụbọchị Uka",   pronunciation: "oo-BOH-chee OO-kah", emoji: "⛪"),
        WordPair(english: "Today",     igbo: "Taa",          pronunciation: "TAH",             emoji: "📆"),
        WordPair(english: "Tomorrow",  igbo: "Echi",         pronunciation: "EH-chee",         emoji: "📆"),
        WordPair(english: "Yesterday", igbo: "Ụnyaahụ",      pronunciation: "oo-nyah-AH-hoo",  emoji: "📆"),
        WordPair(english: "Morning",   igbo: "Ụtụtụ",        pronunciation: "oo-TOO-too",      emoji: "🌅"),
        WordPair(english: "Night",     igbo: "Abalị",        pronunciation: "ah-BAH-lee",      emoji: "🌙"),
    ]

    // MARK: - Common Phrases
    static let phrases: [WordPair] = [
        WordPair(english: "What is your name?",    igbo: "Kedu aha gị?",         pronunciation: "KEH-doo AH-hah ghee", emoji: "❓"),
        WordPair(english: "My name is…",           igbo: "Aha m bụ…",            pronunciation: "AH-hah mm boo",      emoji: "🏷️"),
        WordPair(english: "I love you",            igbo: "A hụrụ m gị n'anya",   pronunciation: "ah HOO-roo mm ghee n-AH-nyah", emoji: "❤️"),
        WordPair(english: "I am hungry",           igbo: "Agụụ na-atọ m",        pronunciation: "ah-GWOO nah-ah-TOH mm", emoji: "😋"),
        WordPair(english: "I am tired",            igbo: "Arịọ m arịọ",          pronunciation: "ah-REE-oh mm ah-REE-oh", emoji: "😴"),
        WordPair(english: "Come here",             igbo: "Bia ebe a",            pronunciation: "BEE-ah EH-beh AH",   emoji: "👋"),
        WordPair(english: "Where is the toilet?",  igbo: "Ọ dị ebe ọ bụ ụlọ mmiri?", pronunciation: "oh dee EH-beh oh BOO oo-LOH mm-EE-ree", emoji: "🚽"),
        WordPair(english: "How much?",             igbo: "Ole ego?",             pronunciation: "OH-leh EH-goh",      emoji: "💰"),
        WordPair(english: "Help me",               igbo: "Nyere m aka",          pronunciation: "NYEH-reh mm AH-kah", emoji: "🆘"),
        WordPair(english: "I don't understand",    igbo: "Enweghị m nghọta",     pronunciation: "en-WEH-ghee mm n-GHOH-tah", emoji: "🤷"),
        WordPair(english: "Speak slowly",          igbo: "Kwuo nwayọọ",          pronunciation: "KWOO-oh n-WAH-yoh",  emoji: "🐢"),
        WordPair(english: "God bless you",         igbo: "Chukwu gozie gị",      pronunciation: "CHOO-kwoo goh-ZEE ghee", emoji: "🙏"),
    ]
}
