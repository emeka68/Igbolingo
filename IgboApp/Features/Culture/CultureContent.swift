import Foundation

// MARK: - Models

struct IgboStory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let emoji: String
    let moralLesson: String
    let paragraphs: [String]
    let igboWords: [WordPair]   // key vocab from the story

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: IgboStory, r: IgboStory) -> Bool { l.id == r.id }

    var fullText: String { paragraphs.joined(separator: "\n\n") }
}

struct CultureArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let category: CultureCategory
    let emoji: String
    let summary: String
    let sections: [ArticleSection]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: CultureArticle, r: CultureArticle) -> Bool { l.id == r.id }
}

struct ArticleSection: Identifiable {
    let id = UUID()
    let heading: String?
    let body: String
}

enum CultureCategory: String, CaseIterable {
    case history     = "History"
    case traditions  = "Traditions"
    case festivals   = "Festivals"
    case food        = "Food & Drink"
    case arts        = "Arts & Music"
    case language    = "Language"

    var emoji: String {
        switch self {
        case .history:    return "🏛️"
        case .traditions: return "🤝"
        case .festivals:  return "🎊"
        case .food:       return "🍛"
        case .arts:       return "🎶"
        case .language:   return "✍️"
        }
    }
}

// MARK: - Stories

let igboFolktales: [IgboStory] = [
    storyTortoiseAndBirds,
    storyWhySkyIsFar,
    storyMrTortoiseSelfishness,
    storyLionAndTortoise,
    storyChiAndDestiny,
]

private let storyTortoiseAndBirds = IgboStory(
    title: "Mbe na Nnụnụ",
    subtitle: "The Tortoise and the Birds",
    emoji: "🐢",
    moralLesson: "Greed and deception will always find you out. Cunning without integrity leads to a great fall.",
    paragraphs: [
        "Long, long ago, when animals still spoke and the sky was full of wonder, the birds of the forest received an invitation. A great feast was being held in the sky, and every bird was welcome. They chattered with excitement — food, music, dancing! Nothing like it had ever been heard of before.",

        "Now Mbe, the tortoise, heard all of this and his belly growled with longing. He had no wings, but he had a tongue as smooth as palm oil. He went to the birds and said: 'My dear friends, I have great experience in the customs of feasts held in the sky. Let me come with you, and I shall speak on your behalf.' The birds, trusting and generous, each gave him one feather, and Mbe fashioned himself a pair of fine wings.",

        "As they flew upward, Mbe spoke again. 'It is the custom up here,' he said cleverly, 'for guests to take new names. My new name shall be: All of You.' The birds thought this was a fine and interesting tradition, so each chose a sky-name for themselves.",

        "When they arrived, the hosts laid out a magnificent feast. 'This food,' announced the host, 'is for all of you.' Mbe immediately stepped forward. 'All of You — that is my name!' he declared, and he sat down and ate nearly everything, leaving the birds with scraps and bones.",

        "The birds were furious. They took back every feather they had lent him. And so Mbe found himself stranded in the sky with no way down. He sent a message to his wife through a passing parrot: 'Bring out all the soft things from the house — the blankets, the mats, the cushions — and pile them in the yard so I may land safely.'",

        "But the parrot, who had watched Mbe's tricks all day, told the wife the opposite: 'Mbe says bring out all the hard things — the hoes, the mortars, the pestles, and the iron pots.' And so when Mbe leapt from the sky, he landed not on softness but on every hard thing in the compound, and his beautiful shell cracked into a hundred pieces.",

        "That is why, to this day, the tortoise's shell is not smooth but marked with many cracks — a reminder that the clever man who tricks his friends will always find the ground harder than expected."
    ],
    igboWords: [
        WordPair(english: "Tortoise", igbo: "Mbe",     pronunciation: "mm-BEH",    emoji: "🐢"),
        WordPair(english: "Bird",     igbo: "Nnụnụ",  pronunciation: "nn-OO-noo", emoji: "🐦"),
        WordPair(english: "Sky",      igbo: "Igwe",    pronunciation: "ee-GWEH",   emoji: "☁️"),
        WordPair(english: "Feast",    igbo: "Oriri",   pronunciation: "oh-REE-ree",emoji: "🍽️"),
        WordPair(english: "Wing",     igbo: "Ìkiikè",  pronunciation: "ee-KEE-keh",emoji: "🪶"),
        WordPair(english: "Name",     igbo: "Aha",     pronunciation: "AH-hah",    emoji: "🏷️"),
    ]
)

private let storyWhySkyIsFar = IgboStory(
    title: "Gịnị mere igwe di anya n'elu",
    subtitle: "Why the Sky is So Far Away",
    emoji: "☁️",
    moralLesson: "Waste and ingratitude push away the very blessings that were freely given. Appreciate what you have.",
    paragraphs: [
        "In the beginning, the sky was not far away. It hung low — so low that a tall man could reach up and touch it. And the sky was not empty air: it was made of the most delicious food anyone had ever tasted, soft and sweet and filling, like the best pounded yam and egusi soup you can imagine.",

        "In those days, no one needed to farm or cook. When you were hungry, you simply reached up and broke off a piece of sky to eat. It was effortless, and the people were happy.",

        "But as with all good things, people began to take it for granted. They would break off great chunks — far more than they could ever eat — and throw the leftovers on the ground. Children played with the sky. Lazy men tore off pieces just to see how far they could throw them. Women broke off more than their families needed and fed it to the goats.",

        "One day, the sky had had enough. It rumbled — not with thunder, but with sadness. 'I have given you everything,' it said, 'and you waste me, you throw me aside, you feel nothing for what I offer.' The people looked up, startled. They had never heard the sky speak before.",

        "'From this day,' said the sky, 'I will go up — far up — where you cannot reach me without work, without earning it.' And the sky began to rise, slowly at first, then faster and faster, until it was where it is today — high, distant, unreachable by hand.",

        "And that is why, from that day on, the people of the earth have had to farm the soil, cook their food, and work for every meal. The sky still gives — rain, sunlight, air — but it will never again let itself be taken for granted."
    ],
    igboWords: [
        WordPair(english: "Sky",    igbo: "Igwe",    pronunciation: "ee-GWEH",  emoji: "☁️"),
        WordPair(english: "Food",   igbo: "Nri",     pronunciation: "n-REE",    emoji: "🍽️"),
        WordPair(english: "Earth",  igbo: "Ala",     pronunciation: "AH-lah",   emoji: "🌍"),
        WordPair(english: "Rain",   igbo: "Mmiri ozuzo", pronunciation: "mm-EE-ree oh-ZOO-zoh", emoji: "🌧️"),
        WordPair(english: "Work",   igbo: "Ọrụ",    pronunciation: "oh-ROO",   emoji: "💪"),
        WordPair(english: "Waste",  igbo: "Ifu",     pronunciation: "ee-FOO",   emoji: "🗑️"),
    ]
)

private let storyMrTortoiseSelfishness = IgboStory(
    title: "Mbe na Ọ bụ onye ọchịchọ",
    subtitle: "Tortoise and the Famine",
    emoji: "🌾",
    moralLesson: "A community that shares survives. Selfishness in a time of need brings only shame.",
    paragraphs: [
        "There came a year when the rains refused to fall. The yam harvest failed, the cassava shrivelled, and even the mango trees gave no fruit. A great hunger fell across the land like a heavy cloth, and the animals gathered together in desperation.",

        "'We must share what little we have,' said the elephant gravely. 'Whoever has food must bring it to the common store so that all may eat a little rather than some eating nothing at all.' The animals agreed, and one by one they brought what they had.",

        "All except Mbe. Mbe had a large pot of yam and a jar of palm wine hidden beneath his shell, but he said nothing and brought nothing. 'I have nothing,' he told the assembly, and sighed deeply to show his suffering.",

        "At night, when the other animals slept, Mbe crept out and ate in secret, smacking his lips in the dark. But Ekwensu, the trickster spirit, was watching. And so was the moonlight.",

        "In the morning, the other animals noticed that Mbe's belly was rounder than any hungry belly should be. The elephant said nothing but watched. The dog sniffed the air near Mbe's shell. The parrot said, very clearly and very loudly: 'The one who ate last night knows who he is.'",

        "Mbe said nothing, but from that day forward, whenever there was a gathering, the animals moved away from him. Not with anger — but with memory. And Mbe, who had eaten in secret, found that eating alone, even with a full belly, was the loneliest thing in the world."
    ],
    igboWords: [
        WordPair(english: "Hunger",    igbo: "Agụụ",   pronunciation: "ah-GWOO",  emoji: "😔"),
        WordPair(english: "Share",     igbo: "Kee",     pronunciation: "KEH",      emoji: "🤝"),
        WordPair(english: "Yam",       igbo: "Ji",      pronunciation: "JEE",      emoji: "🍠"),
        WordPair(english: "Secret",    igbo: "Ihe ọkpọ",pronunciation: "ee-HEH oh-KPOH", emoji: "🤫"),
        WordPair(english: "Community", igbo: "Obodo",   pronunciation: "oh-BOH-doh",emoji: "🏘️"),
        WordPair(english: "Shame",     igbo: "Ihere",   pronunciation: "ee-HEH-reh",emoji: "😔"),
    ]
)

private let storyLionAndTortoise = IgboStory(
    title: "Odum na Mbe",
    subtitle: "The Lion and the Tortoise",
    emoji: "🦁",
    moralLesson: "Wisdom outweighs strength. The cleverest solution is often the simplest one.",
    paragraphs: [
        "Odum the lion was the strongest animal in the forest, and he knew it. He also knew it far too well. Every day he would walk through the trees bellowing: 'Who is stronger than Odum? No one! Who is braver? No one!' And the other animals would scatter out of his path.",

        "One afternoon, Odum came across Mbe the tortoise sitting very still in the middle of the path. 'Move, small thing,' said Odum. 'I do not move for lions,' said Mbe, without looking up. Odum blinked. He had never heard such words.",

        "'I will crush you,' said Odum. 'Try,' said Mbe.",

        "Now Odum raised his great paw and brought it down — but Mbe had pulled inside his shell. The paw hit rock-hard shell and Odum howled in pain. He tried again with the other paw. Same result. He bit at the shell. His teeth found no purchase. He rolled Mbe over — but Mbe's legs were safely tucked inside.",

        "After a long time, sweating and frustrated, Odum sat down. 'What manner of creature are you?' he asked. 'I am one who does not need to run,' said Mbe, finally poking his head out, 'because I already carry my home and my protection with me. Strength that cannot find a gap is wasted strength.'",

        "Odum walked away quietly. He still roared — he was, after all, still a lion — but he never again stopped to threaten the tortoise. And Mbe sat in the path for a while longer, blinking slowly, in no hurry at all."
    ],
    igboWords: [
        WordPair(english: "Lion",      igbo: "Odum",    pronunciation: "OH-doom",   emoji: "🦁"),
        WordPair(english: "Strength",  igbo: "Ike",     pronunciation: "ee-KEH",    emoji: "💪"),
        WordPair(english: "Wisdom",    igbo: "Aghụghọ", pronunciation: "ah-GHOO-ghoh",emoji: "🧠"),
        WordPair(english: "Shell",     igbo: "Ogodo",   pronunciation: "oh-GOH-doh",emoji: "🐚"),
        WordPair(english: "Home",      igbo: "Ụlọ",    pronunciation: "oo-LOH",    emoji: "🏠"),
        WordPair(english: "Forest",    igbo: "Ọhịa",   pronunciation: "oh-HEE-ah", emoji: "🌳"),
    ]
)

private let storyChiAndDestiny = IgboStory(
    title: "Chi na Ọ dị adị",
    subtitle: "The Chi and What Is Meant to Be",
    emoji: "✨",
    moralLesson: "Your chi — your personal spirit — walks with you always. Hard work and a good heart align you with your destiny.",
    paragraphs: [
        "The Igbo say that before a person is born, they kneel before Chukwu — the Great God — and choose the kind of life they will live. They choose their chi — their personal guardian spirit, the divine part of themselves that will walk beside them all their days. Then they step into the world and forget what they chose, and the journey begins.",

        "There was once a young man named Obi who was born in a poor household. His chi, invisible but present, walked beside him every morning as he tended goats, and every evening as he studied by the light of a kerosene lamp.",

        "People would see Obi's poverty and say, 'His chi is weak.' But Obi's chi was not weak. It simply knew what it was doing. It guided Obi's hands to work hard and his mind to stay honest even when easier roads appeared.",

        "Years passed. Obi grew into a man of great skill and greater character. The things he built with his hands were sought by everyone in the village. His counsel was asked by elders twice his age. Slowly, without drama, his life filled with abundance.",

        "'How did you do it?' a friend asked him one day. Obi thought for a long time. 'I did not do it alone,' he said at last. 'My chi has been beside me every step. When I was tempted to be lazy, something in me pushed back. When I was tempted to be dishonest, something in me felt sick. I think that was my chi, keeping me on the path we agreed on before I was born.'",

        "The Igbo say: Onye kwe, chi ya ekwe — When a person agrees, their chi agrees also. Your chi cannot carry you further than you are willing to walk."
    ],
    igboWords: [
        WordPair(english: "Personal spirit", igbo: "Chi",      pronunciation: "CHEE",      emoji: "✨"),
        WordPair(english: "God / Creator",   igbo: "Chukwu",  pronunciation: "CHOO-kwoo", emoji: "🙏"),
        WordPair(english: "Destiny",         igbo: "Ọ dị adị",pronunciation: "oh dee ah-DEE", emoji: "🌟"),
        WordPair(english: "Hard work",       igbo: "Ọrụ ike", pronunciation: "oh-ROO ee-KEH", emoji: "💪"),
        WordPair(english: "Heart",           igbo: "Obi",     pronunciation: "OH-bee",     emoji: "❤️"),
        WordPair(english: "Path / Way",      igbo: "Ụzọ",    pronunciation: "oo-ZOH",     emoji: "🛤️"),
    ]
)

// MARK: - Culture Articles

let cultureArticles: [CultureArticle] = [
    articleIgboHistory,
    articleNewYamFestival,
    articleOzoTitle,
    articleIgboLanguage,
    articleIgboMusic,
    articleIgboFood,
    articleIgboMarriage,
    articleIgboUkwu,
]

private let articleIgboHistory = CultureArticle(
    title: "The Igbo People — Origins & History",
    category: .history,
    emoji: "🏛️",
    summary: "One of Africa's largest ethnic groups, with a history stretching back thousands of years.",
    sections: [
        ArticleSection(heading: "Who are the Igbo?", body: "The Igbo people are one of the largest ethnic groups in Africa, numbering over 40 million people. They are predominantly found in southeastern Nigeria, in states including Anambra, Enugu, Imo, Abia, and Ebonyi — a region often called Igboland or Ala Igbo."),
        ArticleSection(heading: "Ancient Origins", body: "Archaeological evidence from Igbo-Ukwu, a town in Anambra State, shows that a sophisticated Igbo civilisation existed as far back as the 9th century AD. Excavations in the 1950s uncovered thousands of bronze artefacts of remarkable artistry — bowls, vessels, and ceremonial objects — all made without contact with North African or European craftsmen. This was one of the earliest examples of bronze casting in sub-Saharan Africa."),
        ArticleSection(heading: "Decentralised Society", body: "Unlike many of their neighbours, the Igbo traditionally lived in a largely decentralised, republican society. There was no single king or emperor over all Igboland. Instead, villages were governed by councils of elders, age-grade associations, and title societies. The Igbo proverb 'Igbo enwe eze' — the Igbo have no king — captures this fiercely independent spirit."),
        ArticleSection(heading: "The Slave Trade & Its Impact", body: "The transatlantic slave trade devastated Igboland between the 17th and 19th centuries. Millions of Igbo people were enslaved and transported to the Americas and Caribbean. In places like Trinidad, Jamaica, and parts of the American South, Igbo cultural practices — including spiritual beliefs and language echoes — can still be detected in local traditions today."),
        ArticleSection(heading: "Modern Nigeria", body: "The Igbo played a central role in the development of modern Nigeria, producing leaders, writers, and thinkers of global influence. The novelist Chinua Achebe, whose book 'Things Fall Apart' is the most widely read African novel in history, was Igbo. The devastating Biafra War (1967–1970), in which the Igbo-majority southeast attempted to secede from Nigeria, remains a defining and deeply painful chapter in Igbo collective memory.")
    ]
)

private let articleNewYamFestival = CultureArticle(
    title: "Ịwa Ji — The New Yam Festival",
    category: .festivals,
    emoji: "🍠",
    summary: "The most important Igbo festival, celebrating the harvest and giving thanks to the earth.",
    sections: [
        ArticleSection(heading: "What is Ịwa Ji?", body: "The New Yam Festival — Ịwa Ji in Igbo — is the most important annual celebration in Igbo culture. It marks the beginning of the yam harvest season and is a time of thanksgiving, community, and joy. No one may eat the new yam until the festival has been performed."),
        ArticleSection(heading: "Why Yam?", body: "The yam is not merely a food in Igbo culture — it is a symbol of masculinity, wealth, and prestige. A man's status was historically measured partly by the size of his yam barn. The Igbo say 'Ji bụ eze ji' — yam is the king of crops. Farming yam required great skill and patience, and a successful yam farmer was deeply respected."),
        ArticleSection(heading: "The Ceremony", body: "On the day of Ịwa Ji, the oldest man of the community — or the head of the household — performs a ritual offering. He cuts the first yam, offers pieces to the earth goddess Ala, to the ancestors, and to the gods of harvest. Only after this offering may the rest of the community eat. The rest of the day is filled with feasting, masquerade performances, music, and dancing."),
        ArticleSection(heading: "Ala — The Earth Goddess", body: "Central to the festival is Ala (also spelled Ana), the goddess of the earth, fertility, and morality. She is one of the most important deities in Igbo traditional religion. The land itself is sacred — crimes committed against community members were said to be crimes against Ala, polluting the earth. She demands justice and communal harmony."),
        ArticleSection(heading: "Today", body: "Ịwa Ji is still celebrated widely across Igboland and in Igbo diaspora communities around the world. In some towns, it is an elaborate multi-day affair with cultural displays, wrestling matches, and the return of people from cities to their home villages. It is a powerful reminder of the bond between the Igbo people and their ancestral land.")
    ]
)

private let articleOzoTitle = CultureArticle(
    title: "Ọzọ — The Igbo Title System",
    category: .traditions,
    emoji: "👑",
    summary: "How the Igbo honour achievement, wisdom, and service through their ancient title societies.",
    sections: [
        ArticleSection(heading: "A Society Without Kings", body: "Because most Igbo communities had no hereditary king, status and leadership were earned, not inherited. The Igbo developed sophisticated title societies — structured systems through which men (and sometimes women) could rise in prestige by demonstrating wealth, wisdom, generosity, and good character."),
        ArticleSection(heading: "The Ọzọ Title", body: "The Ọzọ title is one of the highest honours a man can achieve in many Igbo communities. Taking the title involves elaborate ceremonies, feasting for the entire community, and significant financial contribution. A titled man is expected to be a pillar of society — a mediator of disputes, a patron of the arts, and a keeper of tradition. He takes a new name and earns the right to wear certain regalia — eagle feathers, a staff of office, and anklets that jingle as he walks."),
        ArticleSection(heading: "Women's Titles", body: "Women also had their own title societies. The 'Lolo' title, for instance, honoured women of exceptional achievement and virtue. A titled woman commanded great respect and had specific roles in community governance and ceremonial life."),
        ArticleSection(heading: "Titles Today", body: "The Igbo title system remains vibrant today. Taking a title is still a major life event, often coinciding with professional success. Nigerian business leaders, academics, and public figures frequently take Igbo titles as a way of rooting their modern success in ancestral values. The ceremony itself — which can last days and involve hundreds of guests — is a magnificent spectacle of culture, music, and oratory.")
    ]
)

private let articleIgboLanguage = CultureArticle(
    title: "Asụsụ Igbo — The Igbo Language",
    category: .language,
    emoji: "✍️",
    summary: "A tonal language of extraordinary richness, with over 20 dialects and a deep proverb tradition.",
    sections: [
        ArticleSection(heading: "A Tonal Language", body: "Igbo is a tonal language — meaning the pitch at which you say a word changes its meaning entirely. There are two primary tones: high (marked with an acute accent: á) and low (marked with a grave accent: à). A word said with the wrong tone can mean something completely different — or nonsense. This is why pronunciation matters so much, and why we emphasise it in Igbolingo."),
        ArticleSection(heading: "Dialects", body: "Igbo is not one uniform language — it is a family of over 20 dialects, some mutually intelligible and some quite distinct. The 'Standard Igbo' used in schools and broadcasting is largely based on the Owerri and Umuahia dialects. But a speaker from Nsukka and a speaker from Nnewi may find each other's Igbo quite different in vocabulary and pronunciation."),
        ArticleSection(heading: "Proverbs — Ilu", body: "Perhaps nowhere is the Igbo language more alive than in its proverbs. The Igbo use proverbs — called ilu — constantly in daily speech, especially among elders. Chinua Achebe wrote: 'Among the Igbo the art of conversation is regarded very highly, and proverbs are the palm oil with which words are eaten.' A well-placed proverb in conversation signals wisdom, age, and cultural knowledge. Learning even a few proverbs will earn you enormous respect from Igbo elders."),
        ArticleSection(heading: "Famous Igbo Proverbs", body: "• Onye wetara oji wetara ndụ — He who brings kola nut brings life.\n• Egbe bere, ugo bere, nke si ibe ya ebena nku kwaa ya — Let the kite perch, let the eagle perch; whichever says the other should not perch, let its wing break. (On peaceful coexistence)\n• Onye aghana nwanne ya — Do not abandon your brother.\n• Otu onye tuo izu, o gbue ochu — If one person makes a plan alone, it amounts to nothing. (On community)"),
        ArticleSection(heading: "Writing System", body: "Igbo was first written down by European missionaries in the 19th century using the Latin alphabet, modified with special characters to represent Igbo sounds (ị, ụ, ọ, ẹ, ṅ). A standardised orthography was established in 1961. Today, Igbo is taught in schools across southeastern Nigeria, though like many African languages it faces pressure from English in urban environments.")
    ]
)

private let articleIgboMusic = CultureArticle(
    title: "Egwu — Igbo Music & Dance",
    category: .arts,
    emoji: "🎶",
    summary: "From the talking drum to highlife, Igbo music runs through every ceremony, season, and celebration.",
    sections: [
        ArticleSection(heading: "Music in Every Moment", body: "In traditional Igbo society, music was not separate from life — it was woven through every significant moment. There was music for birth, for harvest, for burial, for the installation of a chief, for wrestling matches, for planting season, and for welcoming strangers. To understand Igbo music is to understand Igbo life."),
        ArticleSection(heading: "Instruments", body: "The most important traditional instruments include:\n\n• Ogene — a double-bell iron gong struck with a stick, producing a distinctive clang that carries across distances\n• Udu — a clay pot played by striking the opening with the palm, producing deep resonant tones\n• Ekwe — a wooden slit drum carved from a log, used for long-distance communication as well as music\n• Opi — a flute made from bamboo\n• Ichaka — a gourd rattle filled with seeds"),
        ArticleSection(heading: "Masquerade — Mmanwu", body: "The masquerade — Mmanwu — is one of the most spectacular forms of Igbo cultural expression. Masquerades are believed to be the spirits of ancestors returning to the land of the living. They appear at festivals, funerals, and important ceremonies, dressed in elaborate costumes of raffia, cloth, and carved wooden masks. The identity of the masquerade's performer is sacred and must never be revealed. Masquerades can sing, dance, acrobat, deliver community judgements, and bring both fear and celebration."),
        ArticleSection(heading: "Highlife", body: "In the 20th century, the Igbo were central to the development of highlife music — a genre that blended traditional Igbo rhythms with jazz, palm-wine music, and brass band sounds brought by the British. Artists like Chief Stephen Osita Osadebe and Oriental Brothers International became beloved voices of Igbo experience, singing of love, loss, community, and pride in the Igbo language.")
    ]
)

private let articleIgboFood = CultureArticle(
    title: "Nri Igbo — Igbo Food & Cooking",
    category: .food,
    emoji: "🍛",
    summary: "Rich soups, sacred yam, palm wine, and the kola nut — food is ceremony in Igbo culture.",
    sections: [
        ArticleSection(heading: "The Sacred Kola Nut — Oji", body: "Before any food is served at a gathering, before any serious conversation begins, the kola nut — oji — is presented. A small, bitter nut divided into lobes, the kola nut is broken by the eldest or most honoured person present, offered first to the gods and ancestors, then shared among the gathering. The Igbo say: 'Onye wetara oji wetara ndụ' — He who brings kola nut brings life. To refuse kola nut is a serious insult; to offer it is the highest form of welcome."),
        ArticleSection(heading: "Ofe Onugbu — Bitter Leaf Soup", body: "One of the most beloved Igbo soups, Ofe Onugbu is made with bitter leaf (onugbu), cocoyam paste, palm oil, crayfish, and various meats or fish. The bitterness of the leaf is carefully washed and massaged out to achieve the right balance. It is rich, dark, and deeply satisfying — a Sunday staple in many Igbo homes."),
        ArticleSection(heading: "Ofe Oha — Oha Soup", body: "Another iconic soup made with oha leaves, which have a mild, slightly sweet flavour. Combined with cocoyam as a thickener and palm oil, this is considered one of the finest Igbo soups. It is eaten with pounded yam (ji ị tụọ), fufu, or eba (garri)."),
        ArticleSection(heading: "Palm Wine — Mmanya Ngwo", body: "Tapped fresh from the raffia or oil palm tree, palm wine is the traditional drink of the Igbo. Fresh palm wine is sweet and mildly fermented; left to sit, it becomes strong and sour. It is present at every ceremony — weddings, title-taking, funerals — and is offered to guests alongside kola nut. The palm wine tapper (onye ame mmanya) was an important figure in traditional village life."),
        ArticleSection(heading: "Pepper Soup — Ofe Ose", body: "Pepper soup is eaten medicinally and celebratorially. Made with a blend of special spices (ehuru, uziza, crayfish), it is believed to cleanse the body, aid digestion, and warm the blood. It is a staple at post-birth celebrations — the first meal served to a new mother — as well as at parties and social gatherings.")
    ]
)

private let articleIgboMarriage = CultureArticle(
    title: "Ị lụọ nwanyị — Igbo Marriage Traditions",
    category: .traditions,
    emoji: "💍",
    summary: "Marriage in Igbo culture is a union between families, marked by ceremony, joy, and respect.",
    sections: [
        ArticleSection(heading: "Marriage as a Community Event", body: "In Igbo tradition, marriage is not merely a contract between two individuals — it is an alliance between two families, and by extension, two communities. The process of getting married is a series of ceremonies that can span several visits and months, each with its own rituals, negotiations, and celebrations."),
        ArticleSection(heading: "Iku Aka — Knocking on the Door", body: "The first formal step is 'iku aka' — knocking on the door. The groom's family visits the bride's family to formally introduce themselves and express their son's interest. This visit is always accompanied by gifts: kola nuts, alligator pepper, palm wine, and often schnapps. If the bride's family is pleased, they welcome the guests and conversation begins."),
        ArticleSection(heading: "Bride Price — Ime Ego", body: "The bride price — 'ime ego' or dowry — is a payment from the groom's family to the bride's family. It is not a purchase of the woman, as is sometimes misunderstood, but a symbol of value, gratitude, and the formalisation of the union between families. The amount is negotiated respectfully and varies by family and tradition. Importantly, the bride's own consent is central — a woman cannot be married against her will in traditional Igbo custom."),
        ArticleSection(heading: "The Wine-Carrying Ceremony", body: "One of the most beautiful moments in an Igbo traditional wedding is when the bride, holding a calabash of palm wine, walks through the crowd of gathered guests. She must find her husband among them and offer him the wine. When she kneels and offers the cup to him, and he drinks — the marriage is made. The cheering that follows is enormous."),
        ArticleSection(heading: "Colours & Dress", body: "Igbo weddings are a riot of colour. The bride typically wears the traditional George wrapper — a heavily embroidered silk fabric — with a matching blouse and elaborate headgear. Coral beads, which are symbols of royalty and femininity, are worn around the neck, wrists, and waist. The groom wears a white or ivory isiagu (lion-head fabric) top with a red or striped wrapper and a distinctive red cap — the Igbo chiefs' cap.")
    ]
)

private let articleIgboUkwu = CultureArticle(
    title: "Igbo-Ukwu — Ancient Civilisation",
    category: .history,
    emoji: "⚱️",
    summary: "The 9th-century bronze artworks that changed how the world understood African history.",
    sections: [
        ArticleSection(heading: "The Discovery", body: "In 1938, a man named Isaiah Anozie was digging a cistern in his compound in Igbo-Ukwu, a small town in present-day Anambra State, when his spade struck something metallic. What he uncovered would eventually rewrite African history. He had found bronze objects of extraordinary sophistication, dating back to at least the 9th century AD."),
        ArticleSection(heading: "The Excavations", body: "Formal archaeological excavations were carried out in 1959 and 1964 by the British archaeologist Thurstan Shaw, in collaboration with Nigerian scholars. They uncovered three sites: a burial chamber of a high-status individual surrounded by artefacts, a storehouse of bronzes, and a burial pit containing thousands of objects including bronze vessels, copper objects, textiles, and ivory."),
        ArticleSection(heading: "The Bronzes", body: "The Igbo-Ukwu bronzes are technically and artistically astounding. The craftsmen used a 'lost-wax' casting technique — in which a wax model is made, surrounded by clay, the wax is melted out, and molten bronze is poured in — producing objects of incredible intricacy. Bowls decorated with insects, roped pots covered in thousands of tiny dots, and ceremonial vessels shaped like shells reveal a level of artistry that had no equal in Africa at that time."),
        ArticleSection(heading: "Why it Matters", body: "Before Igbo-Ukwu, many Western historians had argued that sophisticated metalworking and complex social organisation in sub-Saharan Africa were either absent or imported from North Africa or Europe. Igbo-Ukwu proved decisively that an advanced, indigenous Igbo civilisation existed centuries before sustained contact with Arabs or Europeans. It is a point of enormous pride for the Igbo people and for all Africans."),
        ArticleSection(heading: "Where are the Bronzes?", body: "The majority of the Igbo-Ukwu bronzes are held at the National Museum in Lagos and the National Commission for Museums and Monuments in Igbo-Ukwu itself. Some pieces are in the British Museum in London, which has been called upon to return them to Nigeria.")
    ]
)
