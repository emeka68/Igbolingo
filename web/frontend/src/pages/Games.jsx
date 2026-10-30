import { useEffect, useMemo, useState } from 'react'
import { WORD_BANK, TOPICS } from '../data/wordBank'
import { speak, stop } from '../services/tts'

const shuffle = (items) => [...items].sort(() => Math.random() - 0.5)
const choices = (words, answer, field, count = 4) => shuffle([
  answer[field], ...shuffle(words.filter(w => w.english !== answer.english).map(w => w[field]))
    .filter((value, i, all) => all.indexOf(value) === i && value !== answer[field]).slice(0, count - 1)
])

function GameCard({ children, onClick, selected, disabled, ariaLabel }) {
  return <button type="button" onClick={onClick} disabled={disabled} aria-label={ariaLabel}
    className={`card w-full text-center min-h-16 font-semibold transition hover:border-igbo-green/50 disabled:cursor-default ${selected ? 'border-igbo-green bg-igbo-green/20' : ''}`}>
    {children}
  </button>
}

function Finish({ score, total, onAgain, onBack }) {
  return <div className="card text-center py-12 max-w-md mx-auto">
    <p className="text-5xl mb-3">{score === total ? '🏆' : '🌟'}</p>
    <h2 className="text-2xl font-black">Practice complete</h2>
    <p className="text-white/70 my-4">{score} of {total} correct</p>
    <div className="flex justify-center gap-3"><button className="btn-primary" onClick={onAgain}>Play again</button><button className="btn-ghost" onClick={onBack}>Choose another</button></div>
  </div>
}

function Match({ words, onBack, onAgain }) {
  const pairs = useMemo(() => shuffle(words).slice(0, 5), [words])
  const igbo = useMemo(() => shuffle(pairs), [pairs])
  const [englishChoice, setEnglishChoice] = useState(null)
  const [matched, setMatched] = useState([])
  const [mistakes, setMistakes] = useState(0)
  const [feedback, setFeedback] = useState('Select an English word, then its Igbo match.')
  if (matched.length === pairs.length) return <Finish score={Math.max(0, pairs.length - mistakes)} total={pairs.length} onAgain={onAgain} onBack={onBack} />
  return <div className="space-y-4">
    <p className="text-white/70 text-sm" role="status">{feedback} · {matched.length}/{pairs.length} pairs</p>
    <div className="grid grid-cols-2 gap-3">
      <div className="space-y-3">{pairs.map(w => <GameCard key={w.english} selected={englishChoice === w.english} disabled={matched.includes(w.english)} onClick={() => setEnglishChoice(w.english)}>{w.english}</GameCard>)}</div>
      <div className="space-y-3">{igbo.map(w => <GameCard key={w.english} disabled={matched.includes(w.english)} onClick={() => {
        if (!englishChoice) return
        if (englishChoice === w.english) { setMatched(m => [...m, w.english]); setFeedback('Correct!'); speak(w.igbo) }
        else { setMistakes(n => n + 1); setFeedback(`Try again: ${englishChoice} is not ${w.igbo}.`) }
        setEnglishChoice(null)
      }}>{w.igbo}</GameCard>)}</div>
    </div>
  </div>
}

function ListenPick({ words, onBack, onAgain }) {
  const round = useMemo(() => shuffle(words).slice(0, 8), [words])
  const [index, setIndex] = useState(0)
  const [score, setScore] = useState(0)
  const [answer, setAnswer] = useState(null)
  const current = round[index]
  const options = useMemo(() => current ? choices(words, current, 'english') : [], [words, current])
  if (index === round.length) return <Finish score={score} total={round.length} onAgain={onAgain} onBack={onBack} />
  return <div className="space-y-5">
    <p className="text-white/60 text-sm">Word {index + 1} of {round.length}</p>
    <button className="btn-primary w-full py-6 text-lg" onClick={() => speak(current.igbo)} aria-label="Play Igbo word">🔊 Play word</button>
    <p className="text-center text-white/60 text-sm">Which English word did you hear?</p>
    <div className="grid grid-cols-2 gap-3">{options.map(option => <GameCard key={option} selected={answer === option} disabled={answer !== null} onClick={() => {
      setAnswer(option)
      if (option === current.english) setScore(n => n + 1)
    }}>{option}</GameCard>)}</div>
    {answer !== null && <div className="text-center" role="status"><p className="mb-3">{answer === current.english ? 'Correct!' : `It was ${current.english} — ${current.igbo}`}</p><button className="btn-primary" onClick={() => { setAnswer(null); setIndex(n => n + 1) }}>Next →</button></div>}
  </div>
}

function Memory({ words, onBack, onAgain }) {
  const cards = useMemo(() => shuffle(shuffle(words).slice(0, 6).flatMap(w => [
    { id: `${w.english}-en`, pair: w.english, label: w.english, igbo: false },
    { id: `${w.english}-ig`, pair: w.english, label: w.igbo, igbo: true },
  ])), [words])
  const [open, setOpen] = useState([])
  const [matched, setMatched] = useState([])
  const [moves, setMoves] = useState(0)
  useEffect(() => {
    if (open.length !== 2) return
    const [a, b] = open.map(id => cards.find(card => card.id === id))
    if (a.pair === b.pair) { setMatched(m => [...m, a.pair]); speak(a.igbo ? a.label : b.label); setOpen([]); return }
    const timer = setTimeout(() => setOpen([]), 850)
    return () => clearTimeout(timer)
  }, [open, cards])
  if (matched.length === cards.length / 2) return <Finish score={Math.max(0, 12 - moves)} total={12} onAgain={onAgain} onBack={onBack} />
  return <div className="space-y-4">
    <p className="text-white/60 text-sm">Match English and Igbo cards · {moves} moves</p>
    <div className="grid grid-cols-3 sm:grid-cols-4 gap-2">{cards.map((card, i) => {
      const revealed = open.includes(card.id) || matched.includes(card.pair)
      return <GameCard key={card.id} ariaLabel={revealed ? card.label : `Hidden card ${i + 1}`} selected={revealed} disabled={revealed || open.length === 2} onClick={() => { setOpen(o => { const next = [...o, card.id]; if (next.length === 2) setMoves(m => m + 1); return next }) }}>{revealed ? card.label : '❔'}</GameCard>
    })}</div>
  </div>
}

function FillBlank({ words, onBack, onAgain }) {
  const phrases = useMemo(() => shuffle(words.filter(w => w.igbo.trim().split(/\s+/).length > 1)).slice(0, 8), [words])
  const [index, setIndex] = useState(0)
  const [score, setScore] = useState(0)
  const [answer, setAnswer] = useState(null)
  const current = phrases[index]
  const missing = current?.igbo.trim().split(/\s+/).at(-1)
  const options = useMemo(() => current ? shuffle([missing, ...shuffle([...new Set(words.flatMap(w => w.igbo.trim().split(/\s+/)))]).filter(w => w !== missing).slice(0, 3)]) : [], [words, current, missing])
  if (index === phrases.length) return <Finish score={score} total={phrases.length} onAgain={onAgain} onBack={onBack} />
  return <div className="space-y-5">
    <p className="text-white/60 text-sm">Phrase {index + 1} of {phrases.length}</p>
    <div className="card text-center"><p className="text-white/60 mb-3">{current.english}</p><p className="text-2xl font-bold text-igbo-green">{current.igbo.trim().split(/\s+/).slice(0, -1).join(' ')} ___</p></div>
    <div className="grid grid-cols-2 gap-3">{options.map((option, i) => <GameCard key={`${option}-${i}`} selected={answer === option} disabled={answer !== null} onClick={() => { setAnswer(option); if (option === missing) setScore(s => s + 1) }}>{option}</GameCard>)}</div>
    {answer !== null && <div className="text-center" role="status"><p className="mb-3">{answer === missing ? 'Correct!' : `The missing word was ${missing}.`}</p><button className="btn-primary" onClick={() => { setAnswer(null); setIndex(n => n + 1) }}>Next →</button></div>}
  </div>
}

const GAME_TYPES = [
  { id: 'match', name: 'Word Match', emoji: '🔗', detail: 'Pair English and Igbo words', component: Match },
  { id: 'listen', name: 'Listen & Pick', emoji: '👂', detail: 'Hear a word and choose its meaning', component: ListenPick },
  { id: 'memory', name: 'Memory Flip', emoji: '🃏', detail: 'Find matching pairs', component: Memory },
  { id: 'blank', name: 'Fill the Blank', emoji: '✍️', detail: 'Complete an Igbo phrase', component: FillBlank },
]

export default function Games() {
  const [topic, setTopic] = useState('Greetings')
  const [game, setGame] = useState(null)
  const [run, setRun] = useState(0)
  useEffect(() => () => stop(), [])
  const words = WORD_BANK[topic] || []
  const available = GAME_TYPES.filter(type => type.id !== 'blank' || words.filter(w => w.igbo.trim().includes(' ')).length >= 4)
  const selected = available.find(type => type.id === game)
  const Component = selected?.component
  return <div className="max-w-2xl mx-auto">
    <div className="mb-6"><p className="text-igbo-green text-xs font-bold uppercase tracking-widest">Practice what you learned</p><h1 className="text-3xl font-black mt-1">Mini games</h1><p className="text-white/60 text-sm mt-1">A few minutes of play helps words stick.</p></div>
    {Component ? <><button className="btn-ghost mb-4 pl-0" onClick={() => { stop(); setGame(null) }}>← All games</button><h2 className="text-xl font-bold mb-4">{selected.emoji} {selected.name} · {topic}</h2><Component key={`${game}-${topic}-${run}`} words={words} onBack={() => setGame(null)} onAgain={() => setRun(n => n + 1)} /></> : <>
      <label htmlFor="game-topic" className="block text-sm font-semibold text-white/70 mb-2">Choose a lesson topic</label>
      <select id="game-topic" value={topic} onChange={e => setTopic(e.target.value)} className="w-full card text-white mb-6 focus:outline-none">{TOPICS.map(t => <option key={t.key} value={t.key}>{t.emoji} {t.title}</option>)}</select>
      <div className="grid sm:grid-cols-2 gap-3">{available.map(type => <button key={type.id} onClick={() => setGame(type.id)} className="card text-left hover:border-igbo-green/50 transition"><span className="text-3xl">{type.emoji}</span><h2 className="font-bold text-lg mt-2">{type.name}</h2><p className="text-white/60 text-sm mt-1">{type.detail}</p></button>)}</div>
    </>}
  </div>
}
