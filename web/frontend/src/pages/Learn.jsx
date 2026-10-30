import { useState, useEffect, useMemo } from 'react'
import { useApp } from '../store/appStore'
import { WORD_BANK, TOPICS } from '../data/wordBank'
import { api } from '../services/api'
import { speak } from '../services/tts'
import { Link } from 'react-router-dom'
import TitleBadge from '../components/common/TitleBadge'
import WordCard from '../components/common/WordCard'

export default function Learn() {
  const { state, dispatch } = useApp()
  const [view, setView] = useState('topics') // topics | lesson | flashcards | quiz
  const [selectedTopic, setSelectedTopic] = useState(null)
  const [culturalNote, setCulturalNote] = useState('')
  const [noteLoading, setNoteLoading] = useState(false)
  const [quizQuestions, setQuizQuestions] = useState([])

  useEffect(() => { dispatch({ type: 'RECORD_ACTIVITY' }) }, [])

  function openTopic(topic) {
    setSelectedTopic(topic)
    setView('lesson')
    setCulturalNote('')
    // Fetch cultural note in background
    setNoteLoading(true)
    api.culturalNote(topic.topic).then(d => setCulturalNote(d.note)).catch(() => {}).finally(() => setNoteLoading(false))
  }

  function completeTopic(topic) {
    // Credit a lesson only after a completed practice session, once per topic.
    let counted = []
    try { counted = JSON.parse(localStorage.getItem('ig_counted_topics')) || [] } catch {}
    if (!counted.includes(topic.key)) {
      const words = WORD_BANK[topic.key] || []
      localStorage.setItem('ig_counted_topics', JSON.stringify([...counted, topic.key]))
      dispatch({ type: 'ADD_WORDS', count: words.length })
      dispatch({ type: 'ADD_LESSON' })
    }
  }

  async function startQuiz() {
    const words = WORD_BANK[selectedTopic.key] || []
    try {
      const qs = await api.generateQuiz(words.slice(0, 10))
      setQuizQuestions(qs)
      setView('quiz')
    } catch {
      alert('Failed to generate quiz. Check backend.')
    }
  }

  const words = selectedTopic ? (WORD_BANK[selectedTopic.key] || []) : []

  if (view === 'flashcards' && selectedTopic) {
    return <Flashcards words={words} onBack={() => setView('lesson')} onComplete={() => completeTopic(selectedTopic)} />
  }
  if (view === 'quiz' && quizQuestions.length) {
    return <Quiz questions={quizQuestions} onBack={() => setView('lesson')} onComplete={() => completeTopic(selectedTopic)} />
  }

  if (view === 'lesson' && selectedTopic) {
    return (
      <div className="max-w-2xl mx-auto">
        <button onClick={() => setView('topics')} className="btn-ghost mb-4 flex items-center gap-2 pl-0">
          ← {selectedTopic.title}
        </button>
        <div className="flex items-center gap-3 mb-6">
          <span className="text-4xl">{selectedTopic.emoji}</span>
          <h1 className="text-2xl font-black">{selectedTopic.title}</h1>
        </div>

        {(culturalNote || noteLoading) && (
          <div className="card mb-6 bg-igbo-green/10 border-igbo-green/20">
            <p className="text-xs text-igbo-green uppercase font-bold mb-2">🌍 Cultural Context</p>
            {noteLoading ? <p className="text-white/40 animate-pulse text-sm">Loading context…</p>
              : <p className="text-white/80 text-sm leading-relaxed">{culturalNote}</p>}
          </div>
        )}

        <div className="flex gap-3 mb-6">
          <button onClick={() => setView('flashcards')} className="btn-primary flex-1">🃏 Flashcards</button>
          <button onClick={startQuiz} className="flex-1 py-2 px-4 rounded-xl font-semibold bg-igbo-gold/20 text-igbo-gold border border-igbo-gold/30 hover:bg-igbo-gold/30 transition">
            🧠 Quiz
          </button>
        </div>

        <div className="space-y-3">
          {words.map((w, i) => <WordCard key={i} word={w} />)}
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-black mb-4">Learn Igbo</h1>

      <Link to="/games" className="card flex items-center gap-3 mb-4 hover:border-igbo-green/40 transition">
        <span className="text-3xl">🎮</span><span className="flex-1"><strong className="block">Mini games</strong><span className="text-white/60 text-sm">Practice with Word Match, Listen & Pick, Memory Flip, and Fill the Blank</span></span><span aria-hidden="true">›</span>
      </Link>

      <TitleBadge />

      {/* Stats */}
      <div className="grid grid-cols-3 gap-3 mt-4 mb-6">
        <div className="card text-center">
          <p className="text-2xl font-black text-orange-400">{state.streakCount}</p>
          <p className="text-xs text-white/40 mt-1">🔥 day streak</p>
        </div>
        <div className="card text-center">
          <p className="text-2xl font-black text-igbo-green">{state.wordsLearned}</p>
          <p className="text-xs text-white/40 mt-1">📚 words</p>
        </div>
        <div className="card text-center">
          <p className="text-2xl font-black text-igbo-gold">{state.lessonsCompleted}</p>
          <p className="text-xs text-white/40 mt-1">✅ lessons</p>
        </div>
      </div>

      <h2 className="text-sm font-semibold text-white/50 uppercase tracking-wide mb-3">Choose a topic</h2>
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
        {TOPICS.map(topic => (
          <button key={topic.key} onClick={() => openTopic(topic)}
            className="card text-center hover:border-igbo-green/40 hover:bg-igbo-green/5 transition cursor-pointer flex flex-col items-center gap-2 py-5">
            <span className="text-4xl">{topic.emoji}</span>
            <span className="font-semibold text-sm">{topic.title}</span>
            <span className="text-xs text-white/30">{(WORD_BANK[topic.key] || []).length} words</span>
          </button>
        ))}
      </div>
    </div>
  )
}

function Flashcards({ words, onBack, onComplete }) {
  const [index, setIndex] = useState(0)
  const [flipped, setFlipped] = useState(false)
  const [done, setDone] = useState(false)

  const word = words[index]

  function next() {
    if (index + 1 >= words.length) { onComplete(); setDone(true); return }
    setFlipped(false)
    setTimeout(() => setIndex(i => i + 1), 150)
  }
  function prev() {
    if (index === 0) return
    setFlipped(false)
    setTimeout(() => setIndex(i => i - 1), 150)
  }

  if (done) return (
    <div className="max-w-md mx-auto text-center py-20">
      <p className="text-5xl mb-4">🎉</p>
      <h2 className="text-2xl font-black mb-2">All done!</h2>
      <p className="text-white/50 mb-6">You reviewed {words.length} words.</p>
      <div className="flex gap-3 justify-center">
        <button onClick={() => { setIndex(0); setDone(false); setFlipped(false) }} className="btn-primary">Restart</button>
        <button onClick={onBack} className="btn-ghost">Back to Lesson</button>
      </div>
    </div>
  )

  return (
    <div className="max-w-md mx-auto">
      <div className="flex items-center justify-between mb-6">
        <button onClick={onBack} className="btn-ghost pl-0">← Back</button>
        <span className="text-white/40 text-sm">{index + 1} / {words.length}</span>
      </div>
      <div className="w-full h-1.5 bg-white/10 rounded-full mb-8 overflow-hidden">
        <div className="h-full bg-igbo-green rounded-full transition-all" style={{ width: `${((index + 1) / words.length) * 100}%` }} />
      </div>

      {/* Card */}
      <div role="button" tabIndex={0} aria-label={flipped ? `Show English for ${word.igbo}` : `Reveal Igbo for ${word.english}`}
        onKeyDown={e => { if (e.target === e.currentTarget && (e.key === 'Enter' || e.key === ' ')) { e.preventDefault(); e.currentTarget.click() } }}
        onClick={() => { setFlipped(f => !f); if (!flipped) speak(word.igbo) }}
        className="card cursor-pointer min-h-[240px] flex flex-col items-center justify-center gap-4 text-center mb-6 hover:border-igbo-green/30 transition select-none">
        {word.emoji && <span className="text-5xl">{word.emoji}</span>}
        {flipped ? (
          <>
            <p className="text-3xl font-black text-igbo-green">{word.igbo}</p>
            <p className="text-white/50 font-mono">{word.pronunciation}</p>
            <button onClick={e => { e.stopPropagation(); speak(word.igbo) }}
              className="text-igbo-green text-sm flex items-center gap-1 hover:opacity-80">🔊 Listen</button>
          </>
        ) : (
          <>
            <p className="text-2xl font-bold">{word.english}</p>
            <p className="text-white/30 text-sm">Tap to reveal Igbo</p>
          </>
        )}
      </div>

      <div className="flex gap-3">
        <button onClick={prev} disabled={index === 0} className="btn-ghost flex-1 disabled:opacity-30">← Prev</button>
        <button onClick={next} className="btn-primary flex-1">Next →</button>
      </div>
    </div>
  )
}

function Quiz({ questions, onBack, onComplete }) {
  const [index, setIndex] = useState(0)
  const [selected, setSelected] = useState(null)
  const [score, setScore] = useState(0)
  const [done, setDone] = useState(false)

  const q = questions[index]
  // Memoize per question — shuffling in the render body reshuffles the
  // buttons every state change (e.g. while showing answer feedback).
  const answers = useMemo(
    () => q ? [...q.wrongAnswers, q.correctAnswer].sort(() => Math.random() - 0.5) : [],
    [index, questions]
  )

  function pick(answer) {
    if (selected) return
    setSelected(answer)
    if (answer === q.correctAnswer) setScore(s => s + 1)
    setTimeout(() => {
      if (index + 1 >= questions.length) { onComplete(); setDone(true); return }
      setSelected(null); setIndex(i => i + 1)
    }, 1200)
  }

  if (done) return (
    <div className="max-w-md mx-auto text-center py-20">
      <p className="text-5xl mb-4">{score >= questions.length * 0.8 ? '🏆' : score >= questions.length * 0.5 ? '🥈' : '📚'}</p>
      <h2 className="text-2xl font-black mb-1">{score} / {questions.length}</h2>
      <p className="text-white/50 mb-6">{Math.round(score / questions.length * 100)}% correct</p>
      <div className="flex gap-3 justify-center">
        <button onClick={() => { setIndex(0); setScore(0); setDone(false); setSelected(null) }} className="btn-primary">Retry</button>
        <button onClick={onBack} className="btn-ghost">Back</button>
      </div>
    </div>
  )

  return (
    <div className="max-w-md mx-auto">
      <div className="flex items-center justify-between mb-6">
        <button onClick={onBack} className="btn-ghost pl-0">← Back</button>
        <span className="text-white/40 text-sm">{index + 1} / {questions.length}</span>
      </div>
      <div className="w-full h-1.5 bg-white/10 rounded-full mb-8">
        <div className="h-full bg-igbo-green rounded-full transition-all" style={{ width: `${((index + 1) / questions.length) * 100}%` }} />
      </div>
      <div className="card mb-6 text-center">
        <p className="text-lg font-bold">{q.question}</p>
      </div>
      <div className="grid grid-cols-2 gap-3">
        {answers.map((a, i) => {
          let cls = 'card text-center cursor-pointer hover:border-igbo-green/40 transition font-semibold py-4'
          if (selected) cls += a === q.correctAnswer ? ' border-igbo-green bg-igbo-green/20 text-igbo-green'
            : a === selected ? ' border-red-500 bg-red-500/20 text-red-400' : ' opacity-40'
          return <button key={i} onClick={() => pick(a)} className={cls}>{a}</button>
        })}
      </div>
    </div>
  )
}
