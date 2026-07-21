# Legacy: native SwiftUI app (superseded)

This was the original Igbolingo build — a pure SwiftUI/UIKit iOS app with
its own copies of the word bank, stories, and proverbs.

**It is no longer the active iOS app.** The Capacitor-wrapped web app in
`../web/frontend/ios/` replaced it, because:

- One codebase now serves web + iOS + Android, instead of maintaining
  duplicate Swift and JS copies of every story/proverb/word.
- Content, TTS, translation, and the dialect toggle all live in
  `web/frontend/src/` and `web/backend/` and are shared across platforms.

Kept here for reference (the SwiftUI flashcard/quiz/games UI patterns are
still worth a look) but not built, tested, or synced with new content going
forward. Safe to delete entirely once you've confirmed you don't need
anything from it — it's fully preserved in git history either way.
