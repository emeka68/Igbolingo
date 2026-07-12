# Igbo Speech Dataset — Open Voice Training Data

A cleanly-aligned Igbo (Asụsụ Igbo) speech dataset recorded by a native
speaker, built alongside the [Igbolingo](../README.md) language-learning app.
Released so that anyone building Igbo TTS, ASR, or language tools has a
starting point — Igbo is a severely under-resourced language and every
aligned hour helps.

## What's here

| File | Purpose |
|---|---|
| `prompts.csv` | The reading script: `id,text,english,category`. 180 prompts covering tone minimal pairs, core vocabulary, conversational sentences, 55 proverbs, and unscripted long-form storytelling. |
| `generate_prompts.mjs` | Regenerates `prompts.csv` from the app's live content (`wordBank.js`, `proverbs.json`) so the dataset grows with the app. |
| `validate.py` | Checks recordings against prompts (naming, mono, sample rate, duration), reports coverage, and exports LJSpeech-style `metadata.csv`. |
| `RECORDING_GUIDE.md` | How to record: setup, register per category, file naming. |
| `recordings/` | Audio clips, named `<prompt_id>.wav` (git-ignored; published via Hugging Face, not git). |

## Format

- Audio: WAV, mono, 44.1 kHz (22.05/48 kHz also accepted)
- Alignment: each clip is named after its prompt ID (`proverb_012.wav`), so
  text↔audio pairing is automatic
- Export: `python3 validate.py --export` produces `metadata.csv` in
  LJSpeech format (`id|transcript`) — directly usable by Piper, Coqui,
  VITS-based recipes, and easy to convert to a Hugging Face `datasets` repo

## Categories

- `tone_pair` — minimal pairs (ákwá/àkwà/ákwà/àkwá …) that carry Igbo's
  lexical tone distinctions; the hardest part for non-Igbo voices
- `vocab_*` — the app's offline word bank (greetings, numbers, family, food,
  animals, colours, body parts, time, phrases)
- `sentence` — natural connected speech
- `proverb` — ilu, delivered in the measured register of an elder
- `unscripted` — free storytelling and self-introduction; transcribe after
  recording and replace the placeholder text in `metadata.csv`

## Dialect & speaker notes

Primary register is Standard Igbo (Igbo Izugbe) as spoken by the recording
speaker. Speaker's regional dialect, age range, and recording conditions
should be noted here when the dataset is published:

- Speaker: _(fill in: e.g. male, 30s, Anambra dialect background)_
- Recording: _(fill in: device, room, date range)_

## License

Recommended: **CC BY 4.0** — anyone may use the data (including
commercially, e.g. to train models) with attribution. If you want to force
derivatives to stay open, use CC BY-SA 4.0 instead. Decide before first
publication; add a `LICENSE` file here.

## Publishing checklist

1. Record clips → `recordings/` (see `RECORDING_GUIDE.md`)
2. `python3 validate.py` until coverage is where you want it
3. Transcribe the `unscripted_*` clips (what was actually said)
4. `python3 validate.py --export` → `metadata.csv`
5. Native-speaker pass over `prompts.csv` tone marks (they are machine-drafted)
6. Create a Hugging Face dataset repo (`huggingface-cli repo create igbo-speech --type dataset`),
   upload `recordings/` + `metadata.csv` + this README, pick the license
7. Tag it `igbo`, `ig`, `text-to-speech`, `automatic-speech-recognition`
