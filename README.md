# Igbolingo

Igbolingo is an Igbo learning app for the web, iOS, and Android. It combines translation, vocabulary practice, games, stories, and proverbs. The current app uses React and Capacitor with a FastAPI backend; the original SwiftUI prototype is archived in `legacy-native-ios/`.

## What works in the current app

- Text, image, and English speech input with Igbo translation. Standard Igbo is the default; Onitsha, Owerri, Nsukka, and Enuani selections are experimental prompt-guided variants.
- Nine vocabulary topics, offline word bank, flashcards, AI-generated quizzes and cultural notes. A topic is credited as complete after practice, rather than on opening it.
- Four mini games: Word Match, Listen & Pick, Memory Flip, and Fill the Blank. Saved words, spaced repetition, streaks, and progression titles are also available.
- 30 stories and 55 proverbs. Story bodies are currently in English, with Igbo titles and vocabulary; the story reader can speak the displayed text. Igbo story narration is a future content and voice task.
- TTS through a server-side ElevenLabs integration with browser speech fallback. Native speaker review of pronunciation and tone is still required.

## Run locally

Requirements: Python 3, Node.js, npm, and API keys for the AI-backed features.

In one terminal:

```bash
cd web/backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
# Put ANTHROPIC_API_KEY and optionally ELEVENLABS_API_KEY in web/backend/.env
uvicorn main:app --reload --port 8001
```

In another terminal:

```bash
cd web/frontend
npm ci
npm run dev
```

Open http://localhost:5173. The Vite development server proxies `/api` to port 8001. If that port is already in use, stop the existing backend before starting another. Never commit `.env` or put provider keys in frontend code.

## Mobile builds

The Capacitor projects are under `web/frontend/ios` and `web/frontend/android`. Set `VITE_API_URL` to a reachable HTTPS backend before a production mobile build; a phone cannot use the development proxy or your computer's `localhost`.

```bash
cd web/frontend
npm run build
npx cap sync ios
npx cap sync android
```

For iOS, open `web/frontend/ios/App/App.xcworkspace` and follow [the iOS setup notes](web/frontend/ios/README.md). For Android, open `web/frontend/android` in Android Studio. Run and verify each build on a real device before release.

## Backend configuration

| Variable | Purpose |
|---|---|
| `ANTHROPIC_API_KEY` | Translation, image identification, cultural notes, and quizzes |
| `ELEVENLABS_API_KEY` | Optional server-side TTS |
| `IGBOLINGO_CORS_ORIGINS` | Comma-separated public web origins, e.g. `https://your-domain.example` |
| `IGBOLINGO_API_REQUESTS_PER_MINUTE` | Per-IP, per-process burst guard; defaults to 20 |

The backend stores generated TTS audio in `web/backend/tts_cache/`, which is ignored by Git. User progress is currently stored in each browser or app WebView's local storage. There are no user accounts or cross-device sync.

## Release gates

- Verify translation, tone marks, dialect choices, stories, and proverbs with native Igbo speakers. Generated answers can be wrong.
- Run web, iOS, and Android device tests, including microphone permissions, image upload, offline behavior, and audio playback.
- Add production rate limits and spend caps at the API gateway before exposing paid AI endpoints publicly. The built-in per-process guard is only a local safety net. Configure HTTPS and the deployed web origin.
- Rotate any provider keys previously shared in chats or terminals before launch.
- Prepare privacy disclosures, support contact, store assets, and accessible screenshots before app-store submission.

## Voice dataset

`voice-training/` contains 180 recording prompts, a guide, and a validator. No recordings are included. The user's own recordings can be published as a separately licensed dataset after consent, transcription, and native-speaker review. Third-party datasets such as WAXAL require their own attribution and license records; do not merge them into the original-recordings release.

## Development checks

```bash
cd web/frontend && npm run build
cd ../../web/backend && python3 -m compileall -q main.py routes
cd ../../voice-training && python3 validate.py
```

## Repository

The only intended remote for this project is [emeka68/Igbolingo](https://github.com/emeka68/Igbolingo). The companion app is a separate repository. Commit messages should not include co-author trailers.
