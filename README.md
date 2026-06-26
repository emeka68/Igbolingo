# Igbolingo — Learn Igbo Language

A native iOS app to teach Igbo language through interactive learning, cultural immersion, and fun games. Built for learners of all ages — from kids discovering their heritage to adults diving deep into Igbo culture.

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0%2B-blue" alt="iOS 17+" />
  <img src="https://img.shields.io/badge/SwiftUI-Native-blue" alt="SwiftUI" />
  <img src="https://img.shields.io/badge/Python%2FLLM-Claude-blueviolet" alt="Claude API" />
</p>

---

## Features

### 🗣️ **Three-Mode Translator**
- **Text Translation**: English → Igbo with pronunciation and tone marks
- **Image Translation**: Point your camera at objects to learn their Igbo names in real-time
- **Voice Translation**: Speak English phrases and hear Igbo responses — perfect for conversational practice

### 📚 **Learning Hub** (9 structured topics)
- Greetings, Numbers, Family, Food & Drink, Animals, Colours, Body Parts, Days & Time, Common Phrases
- Offline word bank: 300+ essential words with pronunciation guides
- Lessons pull in cultural context via Claude API for richer learning
- Flashcard & quiz modes for active recall
- Mini phrase builder for sentence construction

### 🎮 **Four Mini Games**
- **Word Match** (Easy): Pair English ↔ Igbo cards — 5 pairs, 60-second timer
- **Listen & Pick** (Medium): Hear an Igbo word, select the matching English option
- **Memory Flip** (Medium): Classic memory game with Igbo vocabulary — auto-speaks words on match
- **Fill the Blank** (Hard): Complete Igbo phrases by selecting missing words

### 🏆 **Progression System** (10 Igbo titles)
Unlock titles as you progress:
1. **Onye Ọhụrụ** — The Newcomer (start)
2. **Onye Ọmụmụ** — The Student (10 words)
3. **Onye Chọọ Ihe** — The Seeker (30 words, 5 lessons)
4. **Onye Asụsụ** — The Speaker (60 words, 10 lessons)
5. **Okorobia** — The Young Brave (100 words, 20 lessons, 7-day streak)
6. **Odogwu** — The Champion (150 words, 30 lessons, 14-day streak) ⭐ Fan favorite
7. **Dibia** — The Wise One (200 words, 50 lessons)
8. **Ichie** — The Title Holder (300 words, 75 lessons, 30-day streak)
9. **Ọzọ** — The Elder (400 words, 100 lessons)
10. **Eze Igbo** — The Igbo Master (500 words, 150 lessons, 90-day streak) 👑

Earn level-ups with full-screen celebrations, particle bursts, and TTS announcements.

### 🧠 **Spaced Repetition Review**
- Save words from lessons → automatically enrolled in spaced repetition
- SM-2 algorithm: intervals scale 1 → 3 → 7 → 14 → 30 → 60 → 120 days
- Daily review badge on the Saved tab — rate each word Easy or Hard to adjust next review date
- Keeps vocabulary retention sharp without burnout

### 📖 **Culture & Stories** (25 folktales + proverbs)

#### Akụkọ Ifo — 25 Igbo Folktales
- **5 Original stories** from the opening version
- **20 New stories** across 4 categories:
  - 🐾 **Animal Tales** (8): Greedy Vulture, Monkey's Reflection, Spider's Wisdom, Dog & Man, Cock at Dawn, Elephant & River, Bat at Night, etc.
  - 🌍 **Origin Stories** (5): How Kola Nut Became Sacred, Fire in the Village, Why the Cock Crows at Dawn, Why Palm Trees Grow Tall, Why Women Carry Babies
  - 🏛️ **History & Culture** (5): Ikenga, Founding of Nri, The Drum That Spoke, The Old Iroko Tree, etc.
  - 🌆 **Modern Adaptations** (4): Girl Who Listened to the Wind, Two Brothers & the City, Trader & the River Spirit, Boy Who Wouldn't Greet

Each story includes:
- Full text in English with Igbo title and moral lesson
- 5–7 paragraphs of narrative
- 6 key Igbo vocabulary words with pronunciation
- **Full TTS readback** — paginated mode (read per paragraph) or scroll mode (full story)
- Filterable by category in the app

#### Ilu — Proverbs of the Day (30 proverbs)
- One proverb rotates daily based on day-of-year
- Each proverb includes Igbo text, English translation, and deeper cultural meaning
- Listen button with TTS
- Browse all 30 proverbs with search
- Card shown daily in Culture tab

#### Culture & History Articles (8 articles)
- Igbo kingdoms, traditions, festivals, food, arts, and language
- Filterable by category

### 🎯 **Mode Toggle**
- **Kid Mode**: Larger fonts, emoji-dense UI, celebration animations every 3 flashcards, simplified buttons
- **Adult Mode**: Compact layout, detailed cultural notes, longer reading sessions

### 📊 **User Stats & Streaks**
- Day streak counter (maintained via daily activity check)
- Words learned, lessons completed
- Visible on Learn tab and Settings
- Current title displayed in Settings with level indicator

---

## Getting Started

### Requirements
- iOS 17.0 or later
- Xcode 15.0+ (for building)
- Claude API key (for translator, lesson generation, cultural notes)
- Optional: ElevenLabs API key (for high-quality TTS)

### Installation

1. **Clone the repo**:
   ```bash
   git clone https://github.com/emeka68/Igbolingo.git
   cd Igbolingo
   ```

2. **Generate Xcode project**:
   ```bash
   xcodegen generate
   ```

3. **Open in Xcode**:
   ```bash
   open Igbolingo.xcodeproj
   ```

4. **Build and run**:
   - Select target: **Igbolingo**
   - Destination: iPhone 17 (or your preferred simulator)
   - Press Cmd+R to build and run

5. **On first launch**:
   - Onboarding flow: choose learner profile (Child / Adult / Both)
   - Enter Claude API key (stored securely in UserDefaults)
   - Optionally add ElevenLabs key for premium TTS

### API Keys

**Claude API**: Get yours at [console.anthropic.com](https://console.anthropic.com)
- Used for: text/image/speech translation, lesson generation, quiz creation, cultural notes
- Model: `claude-sonnet-4-6`
- Keys stored on-device only; never transmitted except to Claude API

**ElevenLabs (Optional)**: Get at [elevenlabs.io](https://elevenlabs.io)
- Used for: higher-quality Igbo TTS
- Voice: EXAVITQu4vr4xnSDxMaL (multilingual V2)
- Falls back to iOS native AVSpeechSynthesizer if not configured

---

## Architecture

### Stack
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI (iOS 17 `@Observable` macro)
- **Data Persistence**: UserDefaults (app-wide state), UserDefaults (spaced repetition intervals)
- **Build System**: xcodegen v2.45.4
- **External APIs**: Anthropic Claude, ElevenLabs (optional)
- **Speech**: AVSpeechSynthesizer (fallback), SFSpeechRecognizer (voice input)
- **Media**: Photos picker, Camera access via UIImagePickerController

### Project Structure

```
IgboApp/
├── App/
│   ├── IgboApp.swift           # Entry point
│   └── ContentView.swift        # Root nav + tab bar
├── Models/
│   ├── LearnerProfile.swift     # Profile enum + AppState (@Observable singleton)
│   ├── ProgressionSystem.swift  # Title tiers + progression engine
│   └── QuizQuestion.swift       # Quiz data model
├── Services/
│   ├── ClaudeService.swift      # LLM calls (translate, lessons, etc.)
│   ├── AudioService.swift       # TTS (AVSpeech + ElevenLabs)
│   ├── SpeechService.swift      # Speech recognition (SFSpeechRecognizer)
│   ├── OfflineWordBank.swift    # 300+ word bank (9 categories)
│   └── SpacedRepetition.swift   # SM-2 review scheduling
├── Features/
│   ├── Onboarding/
│   │   └── OnboardingView.swift # Profile + API key setup
│   ├── Translator/
│   │   ├── TranslatorView.swift
│   │   ├── TextTranslatorView.swift
│   │   ├── ImageTranslatorView.swift
│   │   └── VoiceTranslatorView.swift
│   ├── Learn/
│   │   ├── LearnView.swift      # Topics grid + stats
│   │   ├── LessonView.swift     # Lesson content + word cards
│   │   ├── FlashcardView.swift  # 3D flip cards
│   │   ├── QuizView.swift       # Multiple choice
│   │   ├── SavedWordsView.swift # Bookmarked words + review badge
│   │   ├── ReviewView.swift     # Spaced rep review session
│   │   └── PhraseBuilderView.swift # 5 phrase categories
│   ├── Games/
│   │   ├── GamesMenuView.swift
│   │   ├── WordMatchGame.swift
│   │   ├── ListenPickGame.swift
│   │   ├── MemoryFlipGame.swift
│   │   ├── FillBlankGame.swift
│   │   └── GameResultView.swift # Shared results screen
│   ├── Culture/
│   │   ├── CultureView.swift    # Stories + Culture tabs
│   │   ├── StoriesListView.swift # 25 stories with category filters
│   │   ├── StoryReaderView.swift # Paginated + scroll modes + TTS
│   │   ├── CultureHistoryView.swift # 8 articles + category chips
│   │   ├── ProverbView.swift    # POTD card + proverb browser
│   │   ├── CultureContent.swift # Story data + proverb data
│   │   └── MoreStories.swift    # 20 new stories
│   ├── Progression/
│   │   ├── TitleCardView.swift  # Title badge + detail sheet
│   │   └── LevelUpView.swift    # Full-screen celebration + particle burst
│   └── Settings/
│       └── SettingsView.swift   # Profile, keys, stats, reset
└── Resources/
    └── Info.plist               # Permissions (camera, mic, speech)
```

### Key Patterns

**State Management**:
- `@Observable` AppState singleton for user progress, profile, saved words, streak
- SpacedRepetitionStore (@Observable) for review scheduling
- Per-view @State for UI state (isFlipped, showDetail, etc.)

**Authentication**:
- Claude API key stored in UserDefaults "claude_api_key"
- Validated on onboarding (live translation test)
- No remote auth; keys are device-only

**Offline-First**:
- 300+ word bank embedded in app
- All lessons, flashcards, games work without API
- Claude called only for: translations, lesson cultural notes, quiz generation, image analysis

**Progression**:
- Calculated from `wordsLearned`, `lessonsCompleted`, `streakCount`
- Level-up detected via `.onChange` modifiers on these properties
- Full-screen celebration with particles and TTS announcement

---

## Usage Walkthrough

### For Kids
1. Launch → Onboarding (select "Child" profile)
2. Kid Mode ON (hare icon on Learn tab)
3. Select a topic → large emoji, large fonts
4. Flashcards → celebration every 3 cards
5. Games → instant feedback with emoji (✅/❌)
6. Streak & progress visible on Learn tab

### For Adults
1. Launch → Onboarding (select "Adult" profile)
2. Kid Mode OFF (tortoise icon) for compact view
3. Select a topic → compact cards, cultural context
4. Flashcards or Quiz → focus on retention
5. Save words → scheduled for review
6. Check Culture tab for proverb + stories
7. Review session → Easy/Hard ratings

### Typical Day
- Open app → see title badge + stats + review badge (if due)
- Do a lesson (5–10 min) → words learned, streak maintained
- Quick review (3–5 min) — rate saved words
- Read a story (paginated) — listen to Igbo
- Check proverb of the day
- Close → streak extends by 1 day

---

## Customization & Extension

### Add More Stories
Edit `IgboApp/Features/Culture/MoreStories.swift`:
```swift
private let storyMyStory = IgboStory(
    title: "Igbo Title",
    subtitle: "English Title",
    emoji: "🐾",
    moralLesson: "...",
    paragraphs: [...],
    igboWords: [...]
)
```
Then add to `additionalStories` array.

### Adjust Progression Tiers
Edit `IgboApp/Models/ProgressionSystem.swift` — modify `igboTitles` array:
```swift
IgboTitle(
    id: 10,
    igbo: "New Title",
    wordsRequired: 500, // your threshold
    ...
)
```

### Change Review Intervals
Edit `IgboApp/Services/SpacedRepetition.swift`:
```swift
private let intervals: [Int] = [1, 3, 7, 14, 30, 60, 120]
```
Adjust the day counts as desired.

---

## Known Limitations & Future Work

- **TTS Igbo**: iOS has no native Igbo voice; app uses `en-NG` (Nigerian English) at 0.38x rate as approximation, with optional ElevenLabs upgrade
- **Offline Vocab**: Limited to 300+ words; exotic terms require Claude API call
- **AI Limitations**: Claude occasionally mixes tone marks or generates imperfect pronunciations — always verify with a native speaker

**Roadmap**:
- Live Igbo chatbot for conversational practice
- User-submitted stories and proverbs
- Push notifications for daily reminders + streaks
- Export/print lessons for offline study
- Speech assessment (tone & pronunciation feedback)

---

## Contributing

Found a bug? Have a story to contribute? Spotted a pronunciation error?

Please open an issue or reach out. This app is for the Igbo community — contributions that deepen cultural authenticity are especially welcome.

---

## License

Igbolingo is open-source and available under the MIT License.

---

## Credits & Gratitude

**Daalụ!** to:
- The Anthropic team for Claude API — the backbone of dynamic content generation
- iOS developers building with SwiftUI + Observation
- Igbo linguists, storytellers, and elders whose wisdom fills these pages
- My family, for the stories and language passed down

---

## Contact

Built with ❤️ by emeka68 for anyone learning or reconnecting with the Igbo language.

Questions? Open an issue on GitHub or reach out directly.

---

**Ọ bu mma. Kwa chi!** — It is good. Thank you, God.
