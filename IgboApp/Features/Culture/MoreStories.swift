import Foundation

// 20 additional Igbo folktales — animal tales, origin stories, historical narratives,
// and modern adaptations. Added to igboFolktales array via extension below.

extension Array where Element == IgboStory {
    static var additionalStories: [IgboStory] {
        [
            storyDogAndMan,
            storyCockAtDawn,
            storyElephantAndRiver,
            storyKolaNutSacred,
            storyGreedyVulture,
            storyGreetElders,
            storyMonkeyReflection,
            storyFireInVillage,
            storyGirlAndWind,
            storyIkenga,
            storyTwoBrothers,
            storyPalmTree,
            storySpiderWisdom,
            storyFoundingNri,
            storyBoyWhoDidntGreet,
            storyWomenAndBabies,
            storyTraderRiverSpirit,
            storyDrumThatSpoke,
            storyBatNight,
            storyIrokoTree,
        ]
    }
}

// MARK: - Animal Folktales

private let storyDogAndMan = IgboStory(
    title: "Gịnị mere nkịta bi na ụlọ mmadụ",
    subtitle: "Why the Dog Lives with Man",
    emoji: "🐕",
    moralLesson: "Loyalty freely given is worth more than any treasure. The one who stays when it is hard will always have a home.",
    paragraphs: [
        "In the time before time, the dog did not live with man. He lived in the forest with the other animals — the leopard, the monkey, the goat — and they all kept to themselves, each going about their own business, each looking after only their own belly.",

        "One dry season, hunger fell on the forest so heavily that even the insects hid. The leopard prowled but found nothing. The monkey searched the treetops and came down with empty hands. One by one, the animals slipped away to look for food elsewhere, and the forest grew quiet.",

        "Only the dog stayed. He had been hunting with man's son — a young boy who had been kind to him, who had once shared his roasted yam without being asked. The dog thought of this kindness now and felt something he could not name. It sat in his chest like a warm coal.",

        "He found the boy's family struggling — the father sick, the mother exhausted, the children thin. The dog went out before dawn and found a hare. He carried it back and lay it at the door of the compound. He did this again the next day. And the next.",

        "The boy's mother saw him and wept. She called her husband. 'This animal has been feeding us,' she said. The father rose from his mat and called to the dog: 'Come in. You are not a stranger here. This compound is yours.'",

        "And from that day, the dog came inside. Not because he was told to, not because he was chained — but because he had chosen it. The forest animals watched from a distance and did not understand. But the dog understood perfectly. He had found something worth more than freedom without love: a family that called him home."
    ],
    igboWords: [
        WordPair(english: "Dog",      igbo: "Nkịta",   pronunciation: "n-KEE-tah",   emoji: "🐕"),
        WordPair(english: "Forest",   igbo: "Ọhịa",   pronunciation: "oh-HEE-ah",   emoji: "🌳"),
        WordPair(english: "Loyalty",  igbo: "Ikwesị", pronunciation: "ee-KWEH-see", emoji: "🤝"),
        WordPair(english: "Home",     igbo: "Ụlọ",   pronunciation: "oo-LOH",       emoji: "🏠"),
        WordPair(english: "Kindness", igbo: "Mmadụ ọma", pronunciation: "mm-AH-doo oh-MAH", emoji: "💚"),
        WordPair(english: "Hunger",   igbo: "Agụụ",   pronunciation: "ah-GWOO",     emoji: "😔"),
    ]
)

private let storyCockAtDawn = IgboStory(
    title: "Gịnị mere ọkụkọ na-ẹkọ n'ụtụtụ",
    subtitle: "Why the Cock Crows at Dawn",
    emoji: "🐓",
    moralLesson: "Every creature is given one great purpose. The one who discovers theirs and does it faithfully — even without applause — keeps the whole world turning.",
    paragraphs: [
        "Long ago, the sun did not know when to rise. He slept whenever he liked and woke whenever he wished — and on some mornings he refused to come at all, leaving the world cold and confused, the farmers unable to find their fields, the children unable to see their food.",

        "Chukwu, the Great God, saw that this was trouble. The world needed order. He called all the animals together and said: 'Who will be the keeper of the dawn? Who will call the sun each morning so that the world wakes in time?'",

        "The eagle said: 'I will do it — I am the greatest bird.' But the eagle's cry was too proud, too sharp; it frightened small children and made the sky tremble. The lion said: 'I will do it.' But his roar was too heavy — it caused people to run and hide rather than rise and work.",

        "One by one the animals tried and failed. Then the cock stepped forward — small, red-combed, ordinary. The other animals laughed. But the cock opened his beak and sang: 'Koo-koo-roo-koo!' And something remarkable happened. The sun stirred. The horizon blushed pink. The world breathed.",

        "Chukwu smiled. 'It is you,' he said to the cock. 'Your voice is not frightening — it is inviting. You do not command the sun; you welcome it.' The cock puffed his chest with quiet pride.",

        "And so every morning, before the rest of the world is awake, the cock rises first — always the first — and he calls out in the darkness, not knowing for certain whether the sun will answer, but calling anyway. And every morning, so far, it has."
    ],
    igboWords: [
        WordPair(english: "Cock/Rooster", igbo: "Ọkụkọ oke",  pronunciation: "oh-KOO-koh OH-keh", emoji: "🐓"),
        WordPair(english: "Sun",          igbo: "Anyanwụ",    pronunciation: "ah-nyah-NWOO",     emoji: "☀️"),
        WordPair(english: "Dawn/Morning", igbo: "Ụtụtụ",      pronunciation: "oo-TOO-too",        emoji: "🌅"),
        WordPair(english: "God",          igbo: "Chukwu",     pronunciation: "CHOO-kwoo",         emoji: "🙏"),
        WordPair(english: "Purpose",      igbo: "Ọrụ ya",    pronunciation: "oh-ROO yah",        emoji: "⭐"),
        WordPair(english: "Voice",        igbo: "Olu",        pronunciation: "OH-loo",            emoji: "🔊"),
    ]
)

private let storyElephantAndRiver = IgboStory(
    title: "Enyi na Mmiri",
    subtitle: "The Elephant and the River",
    emoji: "🐘",
    moralLesson: "Strength without gratitude is dangerous. Remember those who helped you when you were small.",
    paragraphs: [
        "When the elephant was still a calf — small and uncertain on his wide, clumsy feet — he came to the river's edge one terrible afternoon. He was burning with fever, his skin grey with dust, his legs shaking. He had wandered away from his herd and could not find them, and the sun was merciless.",

        "The river saw him and took pity. She pushed her cool water toward his feet, let him drink deeply, let him stand in her shallows until the fever broke. She sang to him quietly through the night — a sound like stones turning — and in the morning he was well.",

        "'I will never forget this,' said the calf, and he meant it with every heavy bone in his body.",

        "Years passed. The calf became enormous — the largest elephant anyone had seen in three generations. He was strong, magnificent, sure of himself. One dry season he walked to the river's edge to drink and found her running low — thin and struggling between cracked banks.",

        "'Move aside,' he said without thinking, and began to dig at her banks with his tusks to redirect her water toward the new crop of sugar cane he had been growing on the far bank. The river said nothing — rivers rarely do — but she grew quieter.",

        "That night, a terrible thirst woke the elephant. He walked back to the river and found her almost still, her voice barely a whisper. He stood in the mud and remembered the night she had sung to him. He lowered his great head. Without another word, he filled her banks back in — all of them — and walked away from the sugar cane forever. The river rose again by morning, and the elephant drank, and said nothing, because some gratitude is too large for words."
    ],
    igboWords: [
        WordPair(english: "Elephant", igbo: "Enyi",      pronunciation: "EH-nyee",      emoji: "🐘"),
        WordPair(english: "River",    igbo: "Mmiri ọsọ", pronunciation: "mm-EE-ree OH-soh", emoji: "🌊"),
        WordPair(english: "Strength", igbo: "Ike",       pronunciation: "ee-KEH",        emoji: "💪"),
        WordPair(english: "Gratitude",igbo: "Ekele",     pronunciation: "eh-KEH-leh",    emoji: "🙏"),
        WordPair(english: "Memory",   igbo: "Echiche",   pronunciation: "eh-CHEE-cheh",  emoji: "💭"),
        WordPair(english: "Water",    igbo: "Mmiri",     pronunciation: "mm-EE-ree",     emoji: "💧"),
    ]
)

// MARK: - Origin Stories

private let storyKolaNutSacred = IgboStory(
    title: "Gịnị mere oji dị nsọ",
    subtitle: "How Kola Nut Became Sacred",
    emoji: "🌰",
    moralLesson: "The things we share in truth and peace carry a holiness that no ceremony can manufacture. The kola nut is sacred because the first gift always is.",
    paragraphs: [
        "In the time when the earth was still learning its own name, Chukwu looked down and saw that his children — the people — were scattered and afraid. They did not know how to speak to one another across distance. They did not know how to begin.",

        "He plucked a small, bitter nut from the tree he had grown at the centre of the world and sent it down with a messenger, a young man named Oji. 'Give this to the first person you meet,' Chukwu said, 'and tell them what I told you: whoever shares this shares life itself.'",

        "Oji walked until he found a village. He was a stranger there — dusty, hungry, uncertain. But he walked to the compound of the eldest man, knelt, and offered the nut with both hands, just as he had been instructed. 'This is for you and your people,' he said.",

        "The old man looked at the nut and at the young stranger. He could have kept it for himself. Instead, he called his family, then his neighbours, then the whole village — and he broke the nut open and shared each lobe, praying aloud over each person as he placed a piece in their palm.",

        "When the last lobe was given, the young man Oji felt something pass through him — warmth, belonging, something he had no word for. The old man felt it too. So did everyone in the circle. They had been strangers and were now, in some small permanent way, connected.",

        "Chukwu saw all of this and declared: 'From this day, no gathering shall begin without the kola nut. No stranger shall be a stranger once it is offered. No prayer shall go unwitnessed if it is said over these lobes.' And that is why, to this day, the Igbo do not begin anything of importance — a meal, a meeting, a marriage, a birth — without first lifting the oji and speaking to the living and the dead."
    ],
    igboWords: [
        WordPair(english: "Kola nut",   igbo: "Oji",      pronunciation: "OH-jee",       emoji: "🌰"),
        WordPair(english: "Sacred/Holy",igbo: "Nsọ",     pronunciation: "n-SOH",         emoji: "✨"),
        WordPair(english: "Stranger",   igbo: "Onye ọbịa", pronunciation: "oh-NYEH oh-BEE-ah", emoji: "👤"),
        WordPair(english: "Prayer",     igbo: "Ọfọ",     pronunciation: "oh-FOH",        emoji: "🙏"),
        WordPair(english: "Share",      igbo: "Kee",      pronunciation: "KEH",           emoji: "🤲"),
        WordPair(english: "Life",       igbo: "Ndụ",     pronunciation: "n-DOO",         emoji: "🌱"),
    ]
)

private let storyGreedyVulture = IgboStory(
    title: "Ụgụ onye ọ chọrọ ikarị ihe niile",
    subtitle: "The Greedy Vulture",
    emoji: "🦅",
    moralLesson: "Greed disguised as cleverness still reveals itself in the end. The one who takes more than their share always ends up with less.",
    paragraphs: [
        "Among the birds of the sky, the vulture had always been gifted with sharp eyes — sharper than any eagle, sharper than any hawk. He could spot a fallen animal from heights that made lesser birds dizzy. This was his gift, and for many years he used it wisely.",

        "But the vulture was also a keeper of a secret: he knew where the clouds stored the rain. He had found the hiding place during a long flight — a great hollow in the tallest cloud, filled to the brim with water for the whole dry season. He told no one.",

        "When the rains did not come one year, the animals and birds gathered in worry. 'Where is the water?' they asked. The vulture said nothing, but he flew up alone each evening and drank his fill from the secret hollow, while the others thirsted below.",

        "What the vulture did not know was that the hollow was not bottomless. By taking more than he needed, by taking alone, he was draining it. One morning he flew up and found it empty — every last drop gone, and nothing to show for it but his own reflection on the bare floor of the cloud.",

        "Below, the other birds had found a spring that had always been there — small, steady, enough for all of them — because they had looked together. The vulture flew down and tried to drink from it too, but the other birds moved aside and let him see his own face in the water.",

        "'You may drink,' they said, 'but you will always know what you cost us.' And from that day the vulture ate alone, at a distance from the others — not because he was told to, but because that is where greed always leaves you in the end: at the edge, looking in."
    ],
    igboWords: [
        WordPair(english: "Vulture",    igbo: "Ụgụ",     pronunciation: "oo-GOO",       emoji: "🦅"),
        WordPair(english: "Greed",      igbo: "Ọchịchọ", pronunciation: "oh-CHEE-choh", emoji: "💰"),
        WordPair(english: "Rain",       igbo: "Mmiri ozuzo", pronunciation: "mm-EE-ree oh-ZOO-zoh", emoji: "🌧️"),
        WordPair(english: "Secret",     igbo: "Ihe ọkpọ", pronunciation: "ee-HEH oh-KPOH", emoji: "🤫"),
        WordPair(english: "Together",   igbo: "Ọnụ",    pronunciation: "OH-noo",       emoji: "🤝"),
        WordPair(english: "Alone",      igbo: "Naanị onwe ya", pronunciation: "nah-AH-nyee on-WEH yah", emoji: "😔"),
    ]
)

private let storyGreetElders = IgboStory(
    title: "Gịnị mere anyị na-ekele okenye tupu ndị ọzọ",
    subtitle: "Why We Greet Elders First",
    emoji: "🙏",
    moralLesson: "Respect for those who have walked further is not submission — it is wisdom. Their years are a road map freely offered to anyone willing to look.",
    paragraphs: [
        "There was once a village that had a curious problem: nobody greeted anyone. Not because the people were unkind — they simply had never been taught. Young men walked past old women without a word. Children ran past grandmothers without looking up. And so the village felt, despite its noise and activity, oddly hollow.",

        "A traveller arrived one day — old, quiet, walking with a staff carved from iroko wood. He had been to many places and noticed immediately what was missing. He asked to speak at the evening gathering.",

        "'I will tell you something I have seen in every village that thrives,' he said. 'The road behind is longer than the road ahead. Every elder in this compound has already walked the path you are walking now. They have stumbled where you will stumble. They know where the soft ground is. When you walk past them without a word, you refuse a map.'",

        "The village was quiet. A young man in the back called out: 'But why must we greet them first? Are we lower than them?' The old traveller smiled. 'When you enter a forest,' he said, 'you watch your feet, yes — but you also look up at the trees that have been standing long before you arrived. Not because you are beneath them, but because they know where the wind is coming from.'",

        "The next morning, a small boy — perhaps five years old — walked out of his father's compound and saw the oldest woman in the village sitting in her doorway. He stopped. He did not know why, exactly. He simply said: 'Nne, ụtụtụ ọma.' Good morning, grandmother.",

        "The old woman looked at him for a long moment. Then she smiled — the kind of smile that has lived long enough to mean something — and she said: 'Nwa m, ka chi gọzie gị.' My child, may God bless you. And from that morning, the village woke up differently."
    ],
    igboWords: [
        WordPair(english: "Elder",      igbo: "Okenye",  pronunciation: "oh-KEH-nyeh",  emoji: "👴"),
        WordPair(english: "Greet",      igbo: "Kele",    pronunciation: "KEH-leh",      emoji: "👋"),
        WordPair(english: "Respect",    igbo: "Ndere",   pronunciation: "n-DEH-reh",    emoji: "🙇"),
        WordPair(english: "Wisdom",     igbo: "Aghụghọ",pronunciation: "ah-GHOO-ghoh", emoji: "🧠"),
        WordPair(english: "Grandmother",igbo: "Nnenna",  pronunciation: "nn-EH-nn-AH",  emoji: "👵"),
        WordPair(english: "Village",    igbo: "Obodo",   pronunciation: "oh-BOH-doh",   emoji: "🏘️"),
    ]
)

private let storyMonkeyReflection = IgboStory(
    title: "Enwe na onyinyo ya",
    subtitle: "The Monkey and His Reflection",
    emoji: "🐒",
    moralLesson: "Jealousy is the art of suffering over something that was never yours. What you have is always enough — until you start looking at what others have instead.",
    paragraphs: [
        "There was a monkey who lived very happily — good trees, plenty of fruit, a comfortable branch for sleeping — until one morning he discovered the river. He swung down to drink and looked into the still water. There, staring back at him, was another monkey. And this monkey, he was certain, had better fruit.",

        "He could not explain how he knew this. He could not even see the fruit in the reflection. But he felt it, deeply and absolutely, the way you sometimes feel a thing is true before you can prove it. He became convinced that the monkey below the water had everything he lacked.",

        "He spent every day at the river's edge, watching. He stopped eating his own fruit — it seemed inferior now. He stopped playing — play seemed pointless. He just sat and stared at the other monkey, who stared back with equal intensity.",

        "The other animals noticed. The tortoise came to look. 'What are you watching?' he asked. 'My enemy,' the monkey said, pointing. The tortoise leaned over carefully — he had learned to be careful near rivers — and looked into the water. He saw his own face looking back.",

        "'Ah,' said the tortoise. 'I see.' He sat back. 'That is not your enemy. That is you. And whatever that monkey has — he has exactly what you have. No more, no less.' The monkey looked again. The reflection looked back with its same sad eyes.",

        "It took him a long time. But one morning the wind blew and the river rippled, and for a moment the reflection shattered into a hundred small monkeys, none of them frightening, all of them ordinary. And the real monkey laughed — really laughed, for the first time in weeks — and went back to his trees and ate his fruit and found, somewhat to his surprise, that it tasted wonderful."
    ],
    igboWords: [
        WordPair(english: "Monkey",      igbo: "Enwe",     pronunciation: "EH-nweh",      emoji: "🐒"),
        WordPair(english: "Reflection",  igbo: "Onyinyo",  pronunciation: "oh-NYEE-nyoh", emoji: "🪞"),
        WordPair(english: "Jealousy",    igbo: "Ịwa obi",  pronunciation: "ee-WAH OH-bee",emoji: "😒"),
        WordPair(english: "River",       igbo: "Mmiri ọsọ",pronunciation: "mm-EE-ree OH-soh", emoji: "🌊"),
        WordPair(english: "Happiness",   igbo: "Obi ụtọ", pronunciation: "OH-bee oo-TOH",emoji: "😊"),
        WordPair(english: "Enough",      igbo: "Ọzụzụ",  pronunciation: "oh-ZOO-zoo",   emoji: "✅"),
    ]
)

private let storyFireInVillage = IgboStory(
    title: "Ọ bụ otú ọkụ bịara n'obodo",
    subtitle: "How Fire Came to the Village",
    emoji: "🔥",
    moralLesson: "The most dangerous things — fire, truth, power — are not good or bad in themselves. They become what the hands that hold them make them.",
    paragraphs: [
        "In the beginning, the village was cold. Not the pleasant coolness of harmattan morning, but a deep, sunless cold that settled into the bones and did not leave. People ate their food raw, wrapped themselves in all the cloth they owned, and went to sleep early because the dark was too cold to sit in.",

        "Fire existed — it lived in the sky, in the lightning — but it had never come down to stay. The sky kept it carefully, believing that the people below were not ready for something so alive and unpredictable.",

        "One rainy season, a bolt of lightning struck an iroko tree at the edge of the village and the tree began to burn. The people ran away. All except one woman — an old woman named Adaeze, who had lived too long to be easily frightened. She stood and watched the tree burn with calm, curious eyes.",

        "She came close — close enough to feel the warmth on her face. And she felt something she had not felt in many years: the memory of comfort. She reached out and, using a long stick, she coaxed a small portion of the flame onto a bundle of dry leaves and carried it carefully, carefully, back to the compound.",

        "The whole village gathered around her. Some said: throw it away, it will burn us. Some said: keep it, it is a gift. Adaeze said nothing. She placed a pot of water over the fire and waited. When the water boiled, she poured it over yam and made the first hot meal the village had ever known.",

        "After that, the argument about fire was settled — not by words, but by the smell of cooked food. And Adaeze became the keeper of fire for the village, the one who taught them: keep it low when cooking, keep it contained when resting, keep it never unattended. Fire is a guest that must always be treated with respect."
    ],
    igboWords: [
        WordPair(english: "Fire",     igbo: "Ọkụ",     pronunciation: "oh-KOO",       emoji: "🔥"),
        WordPair(english: "Cold",     igbo: "Oyi",     pronunciation: "OH-yee",       emoji: "🥶"),
        WordPair(english: "Lightning",igbo: "Ọkụ igwe",pronunciation: "oh-KOO ee-GWEH", emoji: "⚡"),
        WordPair(english: "Warmth",   igbo: "Oyi ọma", pronunciation: "OH-yee oh-MAH",emoji: "☀️"),
        WordPair(english: "Cook",     igbo: "Sie nri", pronunciation: "SEE-yeh n-REE",emoji: "👩‍🍳"),
        WordPair(english: "Gift",     igbo: "Onyinye", pronunciation: "oh-NYEE-nyeh", emoji: "🎁"),
    ]
)

// MARK: - Modern Adaptations

private let storyGirlAndWind = IgboStory(
    title: "Ada na ikuku",
    subtitle: "The Girl Who Listened to the Wind",
    emoji: "🌬️",
    moralLesson: "The world speaks constantly to those who are quiet enough to hear it. Stillness is not emptiness — it is the beginning of understanding.",
    paragraphs: [
        "There was a girl named Adaeze who was different from the other children in one particular way: she was always listening. While the other children played and shouted and argued, Adaeze sat very still and turned her face toward wherever the wind was coming from.",

        "Her mother worried. 'You are too quiet,' she said. 'People will think something is wrong with you.' Adaeze smiled but said nothing. She had learned that the wind had different voices depending on where it had been. The wind from the north was dry and old-smelling, like dust from far roads. The wind from the river carried a coolness and the faintest sound of water. The wind before rain smelled of wet earth long before the first drop fell.",

        "One dry season, the millet crop was ready for harvest and her father planned to begin cutting the next morning. That evening, Adaeze sat in the doorway of the compound and listened. She heard something in the wind — a particular thickness, a heaviness that sat low and warm.",

        "'Nna,' she said. 'There will be rain tonight. A big one.' Her father looked at the sky. It was clear. He almost laughed. But something in his daughter's still, certain face made him pause. He said to her brothers: 'Cover the grain, just in case.'",

        "In the night, the rain came — enormous, heavy, sudden — and all across the village, grain that had been left uncovered was ruined. The family's was safe. In the morning, her father looked at her across the compound for a long time.",

        "'How did you know?' he asked finally. She thought about how to explain the weight in the air, the particular warmth that comes before water falls from a certain direction. But in the end she just said: 'I listened, Nna.' He nodded slowly. From that day he called her his weather-reader. She thought that was a very fine thing to be."
    ],
    igboWords: [
        WordPair(english: "Wind",      igbo: "Ikuku",   pronunciation: "ee-KOO-koo",  emoji: "🌬️"),
        WordPair(english: "Listen",    igbo: "Nụ ụda",  pronunciation: "NOO oo-DAH",  emoji: "👂"),
        WordPair(english: "Rain",      igbo: "Mmiri ozuzo", pronunciation: "mm-EE-ree oh-ZOO-zoh", emoji: "🌧️"),
        WordPair(english: "Quiet",     igbo: "Ụdara",   pronunciation: "oo-DAH-rah",  emoji: "🤫"),
        WordPair(english: "Daughter",  igbo: "Ada",     pronunciation: "AH-dah",      emoji: "👧"),
        WordPair(english: "Morning",   igbo: "Ụtụtụ",  pronunciation: "oo-TOO-too",  emoji: "🌅"),
    ]
)

// MARK: - Historical / Cultural

private let storyIkenga = IgboStory(
    title: "Ikenga — Chi ike mmadụ",
    subtitle: "Ikenga — The Spirit of Personal Achievement",
    emoji: "🗿",
    moralLesson: "Your achievements are not separate from you — they are made of the same material as your character. The Ikenga is not a lucky charm; it is a mirror.",
    paragraphs: [
        "Every Igbo man who amounted to something kept one on his shelf: a carved wooden figure, roughly human in form but abstracted, with horns curving upward from its head and hands gripping implements of achievement — sometimes a sword, sometimes a hoe, sometimes a staff. This was the Ikenga. And it was unlike any other object in Igboland.",

        "The Ikenga represented the chi ike of a man — the force of his right hand, the energy of his personal achievement, the accumulated result of everything he had worked toward. It was not a god to be worshipped exactly; it was more like a second self, a physical home for the part of a person that strove and competed and built.",

        "When a man succeeded — when he took a title, harvested a great crop, won a wrestling match, raised a fine family — he brought gifts to his Ikenga: palm wine, kola nut, sometimes the blood of a goat. Not because the Ikenga had done these things for him, but because he and his Ikenga had done them together, and a partner deserves to be acknowledged.",

        "There was a man named Okafor who had an Ikenga that was very old — passed down from his grandfather, then his father. It was dark with years of palm oil and ceremony. When Okafor fell into debt and lost nearly everything, he put the Ikenga away in a cloth and hid it in the rafters.",

        "His young son found it and asked: 'Why is this hidden?' Okafor said: 'I have nothing to offer it.' His son unwrapped it and set it back on the shelf. 'You are still alive,' the boy said. 'You are still your father's son. You still have your right hand.' Okafor looked at the carved figure for a long time.",

        "He began again the next morning. Small work, honest work, one day at a time. And every evening he sat near the Ikenga — not to beg from it, but to remind himself of what it represented: not luck, not fate, but the patient accumulation of a man's own effort. Years later, when people asked how he had rebuilt, he pointed to the figure on the shelf and said: 'I remembered what I already was.'"
    ],
    igboWords: [
        WordPair(english: "Achievement", igbo: "Ọrụ ike",  pronunciation: "oh-ROO ee-KEH",  emoji: "🏆"),
        WordPair(english: "Right hand",  igbo: "Aka nri",  pronunciation: "AH-kah n-REE",   emoji: "✋"),
        WordPair(english: "Carving",     igbo: "Ịkwa osisi", pronunciation: "ee-KWAH oh-SEE-see", emoji: "🗿"),
        WordPair(english: "Effort",      igbo: "Ọrụ",      pronunciation: "oh-ROO",         emoji: "💪"),
        WordPair(english: "Character",   igbo: "Agwa",     pronunciation: "AH-gwah",        emoji: "⭐"),
        WordPair(english: "Ancestor",    igbo: "Nna ochie", pronunciation: "nn-AH oh-CHEE-yeh", emoji: "👴"),
    ]
)

private let storyTwoBrothers = IgboStory(
    title: "Ụmụnne abụọ na obodo ukwu",
    subtitle: "Two Brothers and the City",
    emoji: "🌆",
    moralLesson: "You can go far and still belong to where you came from. The roots do not stop a tree from growing tall — they are why it can.",
    paragraphs: [
        "Two brothers left their village on the same morning — Emeka in a sharp shirt, carrying a bag with a school certificate inside, and Chidi carrying only a rolled mat and a pot his mother had pressed into his hands. They were going to the city, the same city, but to entirely different futures, or so everyone in the village said.",

        "Emeka found work quickly. He wore the sharp shirt every day, learned to talk fast, to eat things wrapped in plastic, to move through crowds without looking at anyone. He sent money home and felt that this was enough. He told himself he would go back to visit soon, and then later, and then eventually.",

        "Chidi struggled. He did not talk fast. He looked at people in the market too long. He asked too many questions. He found a small job at a carpenter's shop and spent his evenings cooking the same soups his mother cooked, filling the small room with smells that made him ache and glad at the same time.",

        "One evening, Emeka passed by Chidi's room unannounced and stopped in the doorway. He could smell ofe onugbu — bitter leaf soup — cooking on a small stove. He stood there and felt something move in him that he had been carefully not feeling for two years. 'You cook that here?' he said.",

        "Chidi looked up. 'Every week. Sit down.' Emeka sat. He ate the soup. He said nothing for a long time. Then he said, very quietly: 'I forgot what it tasted like.' Chidi said: 'You forgot a lot of things.' Not cruelly — just as a fact, the way you point to a road someone has drifted off.",

        "That night, Emeka called his mother for the first time in months. The next Sunday, both brothers took the bus back to the village together. They did not stay long — the city was their life now, and that was fine. But Chidi understood something Emeka was only beginning to learn: you do not have to choose between where you are going and where you came from. The soil travels in your shoes."
    ],
    igboWords: [
        WordPair(english: "Brother",     igbo: "Nwanne nwoke", pronunciation: "n-WAHN-neh n-WOH-keh", emoji: "👦"),
        WordPair(english: "City",        igbo: "Obodo ukwu",  pronunciation: "oh-BOH-doh oo-KWOO", emoji: "🌆"),
        WordPair(english: "Village",     igbo: "Obodo",       pronunciation: "oh-BOH-doh",        emoji: "🏘️"),
        WordPair(english: "Mother",      igbo: "Nne",         pronunciation: "nn-EH",             emoji: "👩"),
        WordPair(english: "Home / Root", igbo: "Ụlọ",        pronunciation: "oo-LOH",            emoji: "🏠"),
        WordPair(english: "Remember",    igbo: "Echeta",      pronunciation: "eh-CHEH-tah",       emoji: "💭"),
    ]
)

private let storyPalmTree = IgboStory(
    title: "Gịnị mere ọha osisi nkwụ di elu",
    subtitle: "Why Palm Trees Grow So Tall",
    emoji: "🌴",
    moralLesson: "Those who serve many grow beyond themselves. Generosity is its own form of height.",
    paragraphs: [
        "At the beginning, the palm tree was short — no taller than a man, its fronds brushing the ground like a broom held upside down. It was a useful tree, even then. But it was humble and low, and no one gave it much thought beyond what it produced.",

        "The palm tree gave everything. It gave oil for cooking and for the rite of kola. It gave wine — the sweet sap that tapped from its neck and made celebrations possible. It gave leaves for roof-thatching, for weaving baskets, for fanning fires. It gave its kernel, hard and bitter-sweet, which healers used for medicine.",

        "One day Chukwu walked through the forest and paused under the small, generous tree. He had been watching it for many seasons and noticed something: every creature that came to it left with something. The people took oil. The birds nested in its fronds. The insects drank its pollen. Even the wind had an easier time moving through its supple branches than through the rigid iroko.",

        "Chukwu said to the palm tree: 'What do you keep for yourself?' The palm tree thought for a moment. 'My roots,' it said. 'My roots are entirely mine. They hold me in place and find the deep water when the dry season comes. Everything else I give away.'",

        "Chukwu was moved by this. He put his hand on the tree's slender trunk and said: 'Then you will grow.' And the palm tree grew — slowly, over seasons, stretching upward as though reaching for something above the canopy. The taller it grew, the more it gave — its fruit now visible and reachable, its fronds shading wider ground, its wine sweeter with height.",

        "Today you can see it above all the other trees in the compound — not because it pushed anyone aside, but because that is what happens to things that give without counting. They simply become too full not to rise."
    ],
    igboWords: [
        WordPair(english: "Palm tree",  igbo: "Nkwụ",       pronunciation: "n-KWOO",       emoji: "🌴"),
        WordPair(english: "Palm oil",   igbo: "Mmanyị nri", pronunciation: "mm-AH-nyee n-REE", emoji: "🫒"),
        WordPair(english: "Palm wine",  igbo: "Mmanya ngwo",pronunciation: "mm-AH-nyah n-GWOH", emoji: "🥤"),
        WordPair(english: "Tall",       igbo: "Dị elu",     pronunciation: "dee EH-loo",    emoji: "📏"),
        WordPair(english: "Generous",   igbo: "Obi ọhụrụ",  pronunciation: "OH-bee oh-HOO-roo", emoji: "💚"),
        WordPair(english: "Root",       igbo: "Mgbọ osisi", pronunciation: "m-GBOH oh-SEE-see", emoji: "🌱"),
    ]
)

private let storySpiderWisdom = IgboStory(
    title: "Udene na ihe omuma ya",
    subtitle: "The Spider's Web of Wisdom",
    emoji: "🕷️",
    moralLesson: "Wisdom collected selfishly cannot hold its own weight. Knowledge only stays strong when it is shared.",
    paragraphs: [
        "There was a spider — not ordinary, but the wisest creature in the forest — who spent many years collecting wisdom the way other creatures collected food. Every time he heard a piece of knowledge, a truth, a proverb, a lesson, he stored it carefully inside a great clay pot he kept in his web.",

        "He gathered wisdom about weather, about planting, about healing, about building, about how to read the faces of people when they were lying. He gathered wisdom about when to speak and when to stay silent. After many years, the pot was nearly full, and the spider was very pleased with himself.",

        "One day he decided to carry his pot to the top of the tallest tree — so that no one else could reach it and steal what he had collected. He tied the pot to his front and began to climb. But the pot was large and round, and it kept bumping against the trunk, making it impossible to get a grip.",

        "He tried again. And again. His small legs scrambled and slipped. A child sitting beneath the tree watched. Finally the child said: 'Old father, if the pot is in front, it blocks your path. Why not hang it behind you?' The spider stopped. He looked at the child. He looked at the pot. He tried it, and climbed the tree in moments.",

        "At the top, he sat for a long time. Then he opened the pot — and began to let the wisdom fall. Down it drifted, piece by piece, like seeds on the wind, each piece settling somewhere in the forest below. Some reached the farmers, some the healers, some the children, some the old women sitting in doorways.",

        "When the pot was empty, the spider felt lighter than he ever had. And he realised that the child below — who had taught him the one thing his full pot could not hold — had given him more wisdom in one sentence than he had collected in all his years. He had been gathering wisdom about the world and missing the world entirely."
    ],
    igboWords: [
        WordPair(english: "Spider",    igbo: "Udene",    pronunciation: "oo-DEH-neh",   emoji: "🕷️"),
        WordPair(english: "Wisdom",    igbo: "Aghụghọ", pronunciation: "ah-GHOO-ghoh", emoji: "🧠"),
        WordPair(english: "Knowledge", igbo: "Ihe ọmụma",pronunciation: "ee-HEH oh-MOO-mah", emoji: "📚"),
        WordPair(english: "Share",     igbo: "Kee",      pronunciation: "KEH",          emoji: "🤲"),
        WordPair(english: "Tree",      igbo: "Osisi",    pronunciation: "oh-SEE-see",   emoji: "🌳"),
        WordPair(english: "Child",     igbo: "Nwa",      pronunciation: "n-WAH",        emoji: "👶"),
    ]
)

private let storyFoundingNri = IgboStory(
    title: "Ọmalị Nri — Obodo mbụ",
    subtitle: "The Sacred Kingdom of Nri",
    emoji: "👑",
    moralLesson: "True leadership begins with service, not dominance. The most enduring kingdoms are built on peace, not conquest.",
    paragraphs: [
        "Among all the kingdoms of Igboland, Nri was the strangest and the most sacred — not because it was the largest or the most powerful by force of arms, but because it was the only kingdom in the history of the Igbo where the king held no army and conquered no land, yet whose authority was recognised across a vast territory for over a thousand years.",

        "The Eze Nri — the king of Nri — was not a warrior. He was a priest, a cleaner of abominations, a restorer of peace. When a community committed a taboo — when blood was shed where blood should not be shed, when sacred laws were broken — the Eze Nri's representatives would come, perform purification rites, and restore harmony. For this they were paid in tribute, in gratitude, in the acknowledgement that some power runs deeper than armies.",

        "The founding of Nri begins, in oral tradition, with a man named Eri — sent down from the sky by Chukwu himself, like the kola nut before him. Eri and his wife had divine gifts but no food to eat — the land was waterlogged and uncultivable. He prayed to Chukwu, who sent workers to drain the land and teach the people to farm yam and cocoyam.",

        "From Eri descended the Nri clan, and their role was always spiritual: they alone could perform certain rituals, install certain titles, resolve certain disputes. No blood was to be shed in Nri. Slaves who reached Nri were free. Criminals who fled to Nri could not be pursued. It was, in a sense, the original sanctuary.",

        "The Nri kingdom flourished for centuries — their bronzesmiths produced some of the most extraordinary metalwork in Africa, found now in museum collections around the world as the Igbo-Ukwu bronzes. These were not weapons. They were ceremonial bowls, roped vessels, intricate containers for palm wine — objects made entirely for beauty and ritual.",

        "The kingdom declined under colonial disruption in the 19th and 20th centuries, but the memory of Nri — a place where authority came not from force but from moral standing, where the king's greatest power was the ability to make things clean again — remains one of the most remarkable political experiments in African history."
    ],
    igboWords: [
        WordPair(english: "King/Title", igbo: "Eze",      pronunciation: "EH-zeh",       emoji: "👑"),
        WordPair(english: "Kingdom",    igbo: "Alaeze",   pronunciation: "ah-lah-EH-zeh",emoji: "🏰"),
        WordPair(english: "Sacred",     igbo: "Nsọ",     pronunciation: "n-SOH",         emoji: "✨"),
        WordPair(english: "Peace",      igbo: "Udo",      pronunciation: "OO-doh",       emoji: "☮️"),
        WordPair(english: "Bronze",     igbo: "Ọla",      pronunciation: "oh-LAH",       emoji: "⚱️"),
        WordPair(english: "Authority",  igbo: "Ọchịchọ eze", pronunciation: "oh-CHEE-choh EH-zeh", emoji: "⚖️"),
    ]
)

private let storyBoyWhoDidntGreet = IgboStory(
    title: "Nwa nwoke nke jụrụ ikele",
    subtitle: "The Boy Who Would Not Greet",
    emoji: "🙅",
    moralLesson: "The small courtesies — the morning greetings, the respectful pauses — are the threads that hold a community together. Pull enough of them and things unravel.",
    paragraphs: [
        "There was a boy named Tobenna who came back from school in the city with many things: new clothes, new words, new ways of walking. He walked fast now — head down, earphones in, eyes on his phone — the way the city boys walked. He passed elders in the compound without a word. He walked through the market without greeting.",

        "The elders said nothing at first. The old women who had known him since he was learning to walk just watched. His grandmother pulled him aside one evening and said: 'Tobenna, when you walk past Mama Ngozi without greeting, what do you think she feels?' He shrugged. 'She doesn't mind,' he said. 'She knows I'm busy.'",

        "His grandmother said: 'Let me show you something.' She took him to the oldest man in the village — a man so old his age was counted in stories, not years. She said: 'Tell Tobenna what you did this morning.' The old man smiled and said: 'I greeted the sunrise. I greeted my ancestors at the shrine. I greeted my wife. I greeted the iroko tree at the gate, because it has been standing here longer than anyone alive and deserves acknowledgement.'",

        "Tobenna stared. 'Why would you greet a tree?' The old man said: 'Because I am not the centre of the world, and greeting things reminds me of that. The moment I stop greeting, I start to forget.'",

        "Tobenna thought about this for days. He did not have an answer to it. But something shifted — the way things do when a true thought enters and does not leave easily. The next morning he walked out of the compound and saw Mama Ngozi at her doorway.",

        "He stopped. He met her eyes. He said: 'Mama Ngozi, ụtụtụ ọma.' She looked at him for a moment with the measuring look of someone who has seen things come and go. Then her whole face changed. She said: 'Tobenna m! Ka chi gọzie gị.' My Tobenna. May God bless you. And something about the way she said his name — fully, warmly, like a word she had been saving — made him feel more real than he had felt in a long time."
    ],
    igboWords: [
        WordPair(english: "Greet",       igbo: "Kele",       pronunciation: "KEH-leh",     emoji: "👋"),
        WordPair(english: "Respect",     igbo: "Ndere",      pronunciation: "n-DEH-reh",   emoji: "🙇"),
        WordPair(english: "Community",   igbo: "Obodo",      pronunciation: "oh-BOH-doh",  emoji: "🏘️"),
        WordPair(english: "Sunrise",     igbo: "Ọwụwa anyanwụ", pronunciation: "oh-WOOW-ah ah-nyah-NWOO", emoji: "🌅"),
        WordPair(english: "Remember",    igbo: "Echeta",     pronunciation: "eh-CHEH-tah", emoji: "💭"),
        WordPair(english: "Ancestor",    igbo: "Nna ochie",  pronunciation: "nn-AH oh-CHEE-yeh", emoji: "👴"),
    ]
)

private let storyWomenAndBabies = IgboStory(
    title: "Gịnị mere ndị inyom ji ebu ụmụ ha n'azụ",
    subtitle: "Why Women Carry Babies on Their Back",
    emoji: "👶",
    moralLesson: "The safest place for the most precious things is close to the heart — and the heart has a back as well as a front.",
    paragraphs: [
        "When the first children came into the world, no one knew how to carry them. They were slippery and warm and surprisingly heavy for their size. The fathers tried first — they held the babies out in front with both arms, which worked for a time, but left the hands useless for working and the back aching by evening.",

        "The mothers watched the fathers struggle and thought. They watched how the children slept — best when warm, best when they could hear the heartbeat, best when the movement of another body rocked them gently. They noticed that the children cried least when held against a chest, against the warmth of skin.",

        "But then a mother noticed something else: when she tied her child to her back with a long strip of cloth, the child settled immediately into the rhythm of her walk. Every step she took rocked the baby. When she bent to pound yam, the movement soothed it. When she stirred the pot, it slept. And her hands — her hands were free.",

        "She showed the other women. They tried it and marvelled. Not only did the babies calm, but the mothers could feel every movement the child made — a fuss, a turn, a hunger signal — without looking. The back, they discovered, is as sensitive as any other part of a mother.",

        "Chukwu saw this and smiled. He had made the human back strong — strong enough to carry loads, to bear pressure, to support — but he had not imagined that it would become a cradle. 'This is better than what I planned,' he said, which is the highest compliment a creator can pay to the created.",

        "And so it remains to this day. The baby on the back hears the mother's heartbeat through the cloth. It feels every step. It travels with her through the world, close but with the whole world opening up in front of it. When it is old enough to walk, she will set it down. But it will always know how it felt to travel with someone, carried by a back strong enough for both of them."
    ],
    igboWords: [
        WordPair(english: "Baby",       igbo: "Nwa ọhụrụ", pronunciation: "n-WAH oh-HOO-roo", emoji: "👶"),
        WordPair(english: "Mother",     igbo: "Nne",        pronunciation: "nn-EH",           emoji: "👩"),
        WordPair(english: "Back",       igbo: "Azụ",       pronunciation: "ah-ZOO",          emoji: "🔙"),
        WordPair(english: "Carry",      igbo: "Ebu",        pronunciation: "EH-boo",          emoji: "🤲"),
        WordPair(english: "Heartbeat",  igbo: "Ọkụ obi",   pronunciation: "oh-KOO OH-bee",   emoji: "❤️"),
        WordPair(english: "Cloth",      igbo: "Akwa",       pronunciation: "AH-kwah",         emoji: "🧵"),
    ]
)

private let storyTraderRiverSpirit = IgboStory(
    title: "Onye ahịa na mmụọ mmiri",
    subtitle: "The Trader and the River Spirit",
    emoji: "🌊",
    moralLesson: "Some agreements cannot be broken just because they become inconvenient. Integrity is not a fair-weather commitment.",
    paragraphs: [
        "Okeke was a cloth trader who travelled the same river road every market week, his canoe heavy with blue and orange fabric from the north. He was prosperous, practical, and in a hurry — always in a hurry. He did not believe in spirits, though he was careful not to say so aloud near the water.",

        "One rainy season the river rose without warning while he was crossing. His canoe filled and he was sinking when something — a current, a hand, he could not say — guided him to a shallow bank. His cloth was wet but salvageable. He himself was shaking but alive.",

        "A woman sat on the bank watching him. She was too still, too dry, too unhurried to be ordinary. 'You were in the river's mouth,' she said. 'I asked it to let you pass.' Okeke, still trembling, said: 'What do you want in return?' The woman said: 'Come back next market and give the river your first sale — put the money in the water.'",

        "He agreed immediately. What else would he do? He was alive. He went home, dried his cloth, sold it at a fine profit. Next market came. He loaded his canoe. The sky was clear. The river was low and calm and businesslike. He looked at it and thought: I do not need to do this. It is just a river.",

        "He did not put the money in the water. Business was good, he told himself. He crossed safely, sold more cloth, came back richer. Then the third week, in the middle of the crossing, the canoe stopped — not by wind or current, but by stillness. An absolute, absolute stillness. The water held him like a hand.",

        "He sat there for a long time in the middle of the river. Then he took the money from his pouch — not just this week's first sale but two weeks' worth — and he placed it in the water carefully, both hands. 'I am sorry,' he said, quietly, feeling slightly foolish and entirely sincere. The canoe moved. He never crossed the river late again, and he was never caught in a flood again either, though he lived to cross that river three hundred more times."
    ],
    igboWords: [
        WordPair(english: "Trader",      igbo: "Onye ahịa", pronunciation: "oh-NYEH ah-HEE-ah", emoji: "🛒"),
        WordPair(english: "River spirit",igbo: "Mmụọ mmiri",pronunciation: "mm-OO-oh mm-EE-ree", emoji: "🌊"),
        WordPair(english: "Promise",     igbo: "Nkwa",      pronunciation: "n-KWAH",          emoji: "🤝"),
        WordPair(english: "Canoe",       igbo: "Ụgbọ mmiri",pronunciation: "oo-GBOH mm-EE-ree", emoji: "🛶"),
        WordPair(english: "Integrity",   igbo: "Ezi omume", pronunciation: "EH-zee oh-MOO-meh", emoji: "⭐"),
        WordPair(english: "Return",      igbo: "Laghachi",  pronunciation: "lah-GHAH-chee",   emoji: "🔄"),
    ]
)

private let storyDrumThatSpoke = IgboStory(
    title: "Igba nke kwuru okwu",
    subtitle: "The Drum That Spoke",
    emoji: "🥁",
    moralLesson: "A voice that serves its community — not its own ambition — will be heard long after it falls silent.",
    paragraphs: [
        "There was once a drum maker who carved his finest drum from the heart of an iroko tree that had been struck by lightning and yet survived. The tree, he felt, had something extra in it — something stubborn and enduring — and this he put into the drum. He called it Igba Ndụ: the Drum of Life.",

        "The drum passed through many hands. Its first owner used it to call the village to meetings — three slow beats for gathering, five fast beats for emergency. People learned to hear it even in sleep. Even the children, who had never been told the code, somehow understood it by instinct, the way you understand a mother's voice even before you understand her words.",

        "One year, when the colonial officers came and banned the use of village drums — claiming they were used to coordinate resistance, which was partly true and partly a lie — the drum was buried. The man who buried it was not young. He did not know if he would live to dig it up again.",

        "His granddaughter found it forty years later, when the ban was long gone and the old systems were being revived. She was a teacher by then. She dug it out of the earth and found it intact — the wood hard and dense, the face tight, the carved ridges still sharp. She struck it once in the empty compound and the sound filled the street and startled every elder who heard it into stillness.",

        "Three of them came out of their houses, independently, without speaking to each other. They had not heard that sound in four decades. They stood in the compound and did not say a word for a long moment. Then the oldest said: 'It still knows how to call.'",

        "The granddaughter began to teach her students the old codes. Three slow beats. Five fast beats. The language of the drum that someone had trusted to the ground and the ground had kept faithfully until it was time."
    ],
    igboWords: [
        WordPair(english: "Drum",        igbo: "Igba",      pronunciation: "ee-GBAH",      emoji: "🥁"),
        WordPair(english: "Voice/Sound",  igbo: "Olu",       pronunciation: "OH-loo",       emoji: "🔊"),
        WordPair(english: "Community",   igbo: "Obodo",      pronunciation: "oh-BOH-doh",  emoji: "🏘️"),
        WordPair(english: "Memory",      igbo: "Echiche",    pronunciation: "eh-CHEE-cheh",emoji: "💭"),
        WordPair(english: "Ancestor",    igbo: "Nna ochie",  pronunciation: "nn-AH oh-CHEE-yeh", emoji: "👴"),
        WordPair(english: "Teach",       igbo: "Nkuzi",      pronunciation: "n-KOO-zee",   emoji: "📖"),
    ]
)

private let storyBatNight = IgboStory(
    title: "Gịnị mere ụtọ na-afọ n'abalị",
    subtitle: "Why the Bat Flies at Night",
    emoji: "🦇",
    moralLesson: "Trying to belong to every side leaves you belonging to none. Choose who you are and live it fully.",
    paragraphs: [
        "A long time ago, the bat was the most confused creature in existence. He had wings like a bird, so the birds welcomed him. But he had fur like a mammal and fed his young with milk, so the animals of the ground also claimed him. He went to bird meetings and animal meetings and smiled at everyone and committed to no one.",

        "One year, the birds and the ground animals went to war — a petty war, as most wars are, over who owned the right to eat from a particular fig tree. Both sides called on the bat to fight with them. He told the birds he was really an animal. He told the animals he was really a bird. He told both sides he would think about it.",

        "When the war ended in an uneasy truce — the fig tree was split down the middle and declared common ground — both sides compared notes. They discovered what the bat had told each of them. They were furious. Not at his cowardice, exactly — they understood cowardice. They were furious at his pretending.",

        "'He is neither bird nor animal,' said the eagle. 'He is whatever is convenient,' said the elephant. 'Then he belongs with neither of us,' they agreed.",

        "The bat was banned from the bird meetings. He was banned from the animal gatherings. He found himself alone for the first time in his life, which is a particular kind of alone — the kind that comes from having many acquaintances and no real friends.",

        "He took to flying at night, when no one could see him clearly enough to argue about what he was. And in the darkness, something unexpected happened: he found he could see better than any other creature. His ears picked up frequencies the others missed. In trying to belong everywhere, he had missed that he belonged somewhere no one else could go — the night sky, the between-time, the hour of neither day nor dark. He was not a bird or an animal. He was a bat. And that, it turned out, was enough."
    ],
    igboWords: [
        WordPair(english: "Bat",         igbo: "Ụtọ",       pronunciation: "oo-TOH",       emoji: "🦇"),
        WordPair(english: "Night",       igbo: "Abalị",     pronunciation: "ah-BAH-lee",   emoji: "🌙"),
        WordPair(english: "Wings",       igbo: "Ìkiikè",    pronunciation: "ee-KEE-keh",   emoji: "🪶"),
        WordPair(english: "Bird",        igbo: "Nnụnụ",    pronunciation: "nn-OO-noo",    emoji: "🐦"),
        WordPair(english: "Identity",    igbo: "Onwe ya",   pronunciation: "on-WEH yah",   emoji: "🪞"),
        WordPair(english: "Alone",       igbo: "Naanị onwe ya", pronunciation: "nah-AH-nyee on-WEH yah", emoji: "😔"),
    ]
)

private let storyIrokoTree = IgboStory(
    title: "Osisi Oji Ochie",
    subtitle: "The Wise Old Iroko Tree",
    emoji: "🌳",
    moralLesson: "The oldest things in a community are not obstacles — they are archives. Lose them carelessly and you lose what cannot be written down.",
    paragraphs: [
        "At the edge of the village there had been an iroko tree for longer than anyone could remember. It was so old that the elders' grandparents had sat in its shade as children. Its trunk was massive — three men with arms extended could not circle it. Its roots had grown into and under everything nearby: the path, the old shrine, the corner where the oldest women brought their disputes to sit out.",

        "When a new road was planned — the tarmac kind, straight and modern — the surveyor's line ran directly through the iroko. His assistant marked it with an orange flag on a stick. 'The tree will have to come down,' he said, in the matter-of-fact tone of someone who has never tried to remove something that has been alive for six centuries.",

        "The oldest woman in the village — a woman so old she remembered things the official histories had forgotten — came and sat under the tree the next morning. She did not protest, exactly. She just sat there with her eyes open, the way she always did when something needed to be witnessed.",

        "People came to ask her: why are you sitting there? She said: 'I am listening to what the tree knows before it forgets.' Someone said: 'Trees don't know things.' She looked at them with a patience that was very close to pity. 'This tree has been here since before the Nri kingdom sent its priests through this road. It has been here since the slavers came and the people hid children in its roots. It has been here through drought and flood and war and peace. What do you think it has absorbed?'",

        "The argument about the road went on for months. Eventually the road curved — slightly, expensively, inconveniently — around the iroko. The surveyor muttered. The old woman said nothing. She had not expected to win; she had simply expected to be heard, which is a different kind of victory.",

        "The iroko still stands. Children still climb it. At certain times of year, the oldest residents still come and sit at its base, not quite praying, not quite remembering — something in between, the way you sit with a very old person whose stories you know but whose presence still tells you something the stories cannot."
    ],
    igboWords: [
        WordPair(english: "Iroko tree",  igbo: "Oji",       pronunciation: "OH-jee",       emoji: "🌳"),
        WordPair(english: "Old",         igbo: "Ochie",     pronunciation: "oh-CHEE-yeh",  emoji: "👴"),
        WordPair(english: "Memory",      igbo: "Echiche",   pronunciation: "eh-CHEE-cheh", emoji: "💭"),
        WordPair(english: "Roots",       igbo: "Mgbọ osisi",pronunciation: "m-GBOH oh-SEE-see", emoji: "🌱"),
        WordPair(english: "Village",     igbo: "Obodo",     pronunciation: "oh-BOH-doh",   emoji: "🏘️"),
        WordPair(english: "History",     igbo: "Akụkọ ihe mere eme", pronunciation: "ah-KOO-koh ee-HEH meh-REH EH-meh", emoji: "📜"),
    ]
)
