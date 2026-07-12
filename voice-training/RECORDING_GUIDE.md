# Recording Guide

## Setup (once)
- Quiet room, soft furnishings if possible (curtains/cushions kill echo)
- Mic or phone **15–20 cm** from your mouth, same position every session
- Record WAV if you can; if your recorder makes `.m4a`, convert later:
  `ffmpeg -i clip.m4a -ar 44100 -ac 1 clip.wav`
- Do a 10-second test, listen back on headphones: no hum, no clipping, no echo

## Session workflow
1. Open `prompts.csv` (Numbers/Excel/Sheets is fine)
2. Work through one category per sitting (e.g. all proverbs in one session)
3. One prompt = one file, named exactly by its ID: `proverb_012.wav`
4. Fluffed a line? Just re-record the file — last take wins
5. After each session: `python3 validate.py` shows coverage and any bad files

## Delivery per category
| Category | Register |
|---|---|
| `tone_pair` | Slow and deliberate first, then repeat at natural speed in the same take. The tone contrast is the entire point. |
| `vocab_*` | Clear, natural citation form — how you'd say the word to a learner. |
| `sentence` | Normal conversational pace and warmth, as if talking to family. |
| `proverb` | Measured, weighty — an elder at a gathering. Let it breathe. |
| `unscripted` | Follow the instruction in the `english` column. Don't read — *tell*. Vary pitch, do character voices, laugh where it's funny. This is the most valuable audio in the whole dataset. |

## Amounts
- **Minimum useful:** tone pairs + proverbs + unscripted (~20 min) — enough for an ElevenLabs Professional clone
- **Good:** everything once (~45–60 min)
- **Great:** everything + extra unscripted storytelling sessions over time

## Native-speaker edits welcome
The prompt text (especially tone marks on `tone_*` rows) was machine-drafted.
You are the authority — fix anything in `prompts.csv` that isn't how you
speak **before** recording it, so text and audio always match. If you edit a
prompt after recording it, re-record that clip.

## Using it with ElevenLabs (the app's voice)
1. Record at least the "minimum useful" set
2. ElevenLabs → Voices → Add Voice → **Professional Voice Clone** → upload the WAVs (Creator plan or above)
3. When training finishes, copy the new voice ID into
   `web/backend/routes/tts.py` → `IGBO_VOICE_ID`, restart the backend
4. Delete `web/backend/tts_cache/` so old audio regenerates with your voice
