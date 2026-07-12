// Generates voice-training/prompts.csv from the app's own content
// (wordBank.js + proverbs.json) plus tone-pair and sentence sets below.
//
// Run:  node voice-training/generate_prompts.mjs
//
// Each prompt gets a stable ID. Recordings must be named <id>.wav so that
// validate.py can align text <-> audio automatically (LJSpeech-style).

import { writeFileSync, readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const here = dirname(fileURLToPath(import.meta.url))
const dataDir = join(here, '..', 'web', 'frontend', 'src', 'data')

const { WORD_BANK } = await import(join(dataDir, 'wordBank.js'))
const proverbs = JSON.parse(readFileSync(join(dataDir, 'proverbs.json'), 'utf8'))

const rows = []
const pad = (n) => String(n).padStart(3, '0')

// ---------------------------------------------------------------------------
// 1. Tone minimal pairs — the heart of Igbo tonality training.
//    NOTE FOR NATIVE SPEAKER: please correct any tone marks before recording.
// ---------------------------------------------------------------------------
const tonePairs = [
  ['ákwá', 'cry / weeping'],
  ['àkwà', 'bed / bridge'],
  ['ákwà', 'cloth'],
  ['àkwá', 'egg'],
  ['ísí', 'head'],
  ['ísì', 'smell'],
  ['ìsì', 'blindness'],
  ['ọ́kụ́', 'fire'],
  ['ànụ̀', 'bee'],
  ['ánụ́', 'meat'],
  ['égbé', 'kite (bird)'],
  ['égbè', 'gun'],
  ['óké', 'rat'],
  ['òkè', 'boundary / share'],
]
tonePairs.forEach(([igbo, english], i) => {
  rows.push({ id: `tone_${pad(i + 1)}`, text: igbo, english, category: 'tone_pair' })
})

// ---------------------------------------------------------------------------
// 2. Vocabulary — every word in the app's offline word bank.
// ---------------------------------------------------------------------------
const slug = (s) => s.toLowerCase().replace(/[^a-z]+/g, '_').replace(/^_|_$/g, '')
for (const [topic, words] of Object.entries(WORD_BANK)) {
  words.forEach((w, i) => {
    rows.push({
      id: `vocab_${slug(topic)}_${pad(i + 1)}`,
      text: w.igbo,
      english: w.english,
      category: `vocab_${slug(topic)}`,
    })
  })
}

// ---------------------------------------------------------------------------
// 3. Conversational sentences — connected speech, natural rhythm.
//    NOTE FOR NATIVE SPEAKER: adjust to how you actually speak.
// ---------------------------------------------------------------------------
const sentences = [
  ['Ụtụtụ ọma, nne m. Kedu ka ị boola?', 'Good morning, my mother. How did you wake?'],
  ['Kedu ka ọ dị? Ọ dị mma, daalụ.', 'How is it? It is fine, thank you.'],
  ['Aha m bụ Ugochukwu. Kedụ aha gị?', 'My name is Ugochukwu. What is your name?'],
  ['Nwa m na-amụ asụsụ Igbo.', 'My child is learning the Igbo language.'],
  ['Bịa ka anyị gaa ahịa.', 'Come, let us go to the market.'],
  ['Anyị ga-eri nri n\'oge ehihie.', 'We will eat in the afternoon.'],
  ['Biko, kwuo ya ọzọ nwayọọ.', 'Please, say it again slowly.'],
  ['A hụrụ m gị n\'anya, nwa m.', 'I love you, my child.'],
  ['Chukwu gozie gị na ezinụlọ gị.', 'God bless you and your family.'],
  ['Ka chi foo. Ka anyị hụ echi.', 'Good night. See you tomorrow.'],
  ['Mmiri na-ezo taa, kpachara anya.', 'It is raining today, be careful.'],
  ['Ji na ofe onugbu dị ụtọ.', 'Yam and bitter-leaf soup are delicious.'],
  ['Ndewo nu! Nnọọ n\'ụlọ anyị.', 'Hello everyone! Welcome to our home.'],
  ['Ege m ntị mgbe okenye na-ekwu okwu.', 'I listen when an elder is speaking.'],
  ['Echi ka anyị ga-aga ahịa Eke.', 'Tomorrow we will go to Eke market.'],
]
sentences.forEach(([igbo, english], i) => {
  rows.push({ id: `sentence_${pad(i + 1)}`, text: igbo, english, category: 'sentence' })
})

// ---------------------------------------------------------------------------
// 4. Proverbs — measured, weighty register. Pulled from the app.
// ---------------------------------------------------------------------------
proverbs.forEach((p, i) => {
  rows.push({ id: `proverb_${pad(i + 1)}`, text: p.igbo, english: p.english, category: 'proverb' })
})

// ---------------------------------------------------------------------------
// 5. Unscripted long-form — highest-value data. Record freely, then
//    transcribe what was actually said into metadata later.
// ---------------------------------------------------------------------------
const unscripted = [
  ['Tell the story of Mbe na Nnụnụ (Tortoise and the Birds) freely in Igbo, 2-3 minutes, animated storytelling voice.'],
  ['Tell any folktale you heard growing up, 2-3 minutes, in your own words.'],
  ['Introduce yourself and your family in Igbo, 1-2 minutes, natural conversational tone.'],
  ['Describe how to cook a favourite Igbo dish, 1-2 minutes.'],
  ['Explain why the Igbo language matters to you, 1-2 minutes.'],
]
unscripted.forEach(([instruction], i) => {
  rows.push({ id: `unscripted_${pad(i + 1)}`, text: '(transcribe after recording)', english: instruction, category: 'unscripted' })
})

// ---------------------------------------------------------------------------
// Write CSV
// ---------------------------------------------------------------------------
const esc = (s) => `"${String(s).replace(/"/g, '""')}"`
const csv = ['id,text,english,category']
for (const r of rows) csv.push([r.id, esc(r.text), esc(r.english), r.category].join(','))
writeFileSync(join(here, 'prompts.csv'), csv.join('\n') + '\n')

const byCat = rows.reduce((m, r) => ((m[r.category.split('_')[0]] = (m[r.category.split('_')[0]] || 0) + 1), m), {})
console.log(`Wrote ${rows.length} prompts to prompts.csv`)
console.log('Breakdown:', byCat)
