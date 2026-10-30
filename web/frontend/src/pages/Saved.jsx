import { useState } from 'react'
import { useApp } from '../store/appStore'
import { speak } from '../services/tts'

export default function Saved() {
  const { state, dispatch, dueWords, isSaved } = useApp()
  const [search, setSearch] = useState('')
  const [view, setView] = useState('words') // words | review
  const [reviewIndex, setReviewIndex] = useState(0)
  const [reviewFlipped, setReviewFlipped] = useState(false)
  const [reviewDone, setReviewDone] = useState(false)
  const [easyCount, setEasyCount] = useState(0)
  const [hardCount, setHardCount] = useState(0)
  const [sessionWords, setSessionWords] = useState([])

  const filtered = state.savedWords.filter(w =>
    !search || w.english.toLowerCase().includes(search.toLowerCase()) || w.igbo.toLowerCase().includes(search.toLowerCase())
  )

  function startReview() {
    // Snapshot the due list: the live `dueWords` shrinks as words are rated
    // (they stop being due), which would skip words / end the session early.
    setSessionWords([...dueWords])
    setReviewIndex(0); setReviewFlipped(false); setReviewDone(false)
    setEasyCount(0); setHardCount(0); setView('review')
  }

  function rate(easy) {
    const word = sessionWords[reviewIndex]
    dispatch({ type: easy ? 'SR_EASY' : 'SR_HARD', wordID: word.english })
    if (easy) setEasyCount(c => c + 1); else setHardCount(c => c + 1)
    setReviewFlipped(false)
    if (reviewIndex + 1 >= sessionWords.length) { setReviewDone(true); return }
    setTimeout(() => setReviewIndex(i => i + 1), 100)
  }

  if (view === 'review') {
    if (reviewDone) return (
      <div className="max-w-md mx-auto text-center py-20">
        <p className="text-5xl mb-4">🎉</p>
        <h2 className="text-2xl font-black mb-2">Review Complete!</h2>
        <div className="flex justify-center gap-8 my-4">
          <div><p className="text-3xl font-black text-igbo-green">{easyCount}</p><p className="text-white/40 text-sm">Easy</p></div>
          <div><p className="text-3xl font-black text-red-400">{hardCount}</p><p className="text-white/40 text-sm">Hard</p></div>
        </div>
        <p className="text-white/50 text-sm mb-6">{hardCount === 0 ? 'Perfect! All solid. 🏆' : 'Hard words come back tomorrow.'}</p>
        <button onClick={() => setView('words')} className="btn-primary">Done</button>
      </div>
    )

    const word = sessionWords[reviewIndex]
    if (!word) { setView('words'); return null }
    return (
      <div className="max-w-md mx-auto">
        <div className="flex items-center justify-between mb-4">
          <button onClick={() => setView('words')} className="btn-ghost pl-0">← Back</button>
          <span className="text-white/40 text-sm">{reviewIndex + 1} / {sessionWords.length}</span>
        </div>
        <div className="w-full h-1.5 bg-white/10 rounded-full mb-8">
          <div className="h-full bg-igbo-green rounded-full transition-all"
            style={{ width: `${((reviewIndex + 1) / sessionWords.length) * 100}%` }} />
        </div>
        <div role="button" tabIndex={0} aria-label={reviewFlipped ? `Show English for ${word.igbo}` : `Reveal Igbo for ${word.english}`}
          onKeyDown={e => { if (e.target === e.currentTarget && (e.key === 'Enter' || e.key === ' ')) { e.preventDefault(); e.currentTarget.click() } }}
          onClick={() => { setReviewFlipped(f => !f); if (!reviewFlipped) speak(word.igbo) }}
          className="card min-h-[220px] flex flex-col items-center justify-center gap-4 text-center cursor-pointer hover:border-igbo-green/30 transition mb-6 select-none">
          {word.emoji && <span className="text-5xl">{word.emoji}</span>}
          {reviewFlipped ? (
            <>
              <p className="text-3xl font-black text-igbo-green">{word.igbo}</p>
              <p className="text-white/50 font-mono text-sm">{word.pronunciation}</p>
            </>
          ) : (
            <>
              <p className="text-2xl font-bold">{word.english}</p>
              <p className="text-white/30 text-sm">Tap to reveal Igbo</p>
            </>
          )}
        </div>
        {reviewFlipped ? (
          <div className="grid grid-cols-2 gap-3">
            <button onClick={() => rate(false)}
              className="py-4 rounded-xl font-bold text-red-400 bg-red-400/10 border border-red-400/30 hover:bg-red-400/20 transition">
              ✕ Hard<br/><span className="text-xs font-normal opacity-60">Review tomorrow</span>
            </button>
            <button onClick={() => rate(true)}
              className="py-4 rounded-xl font-bold text-igbo-green bg-igbo-green/10 border border-igbo-green/30 hover:bg-igbo-green/20 transition">
              ✓ Easy<br/><span className="text-xs font-normal opacity-60">Interval extends</span>
            </button>
          </div>
        ) : (
          <p className="text-center text-white/30 text-sm">Tap the card to reveal</p>
        )}
      </div>
    )
  }

  return (
    <div className="max-w-2xl mx-auto">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-black">Saved Words</h1>
        <span className="text-white/40 text-sm">{state.savedWords.length} words</span>
      </div>

      {dueWords.length > 0 && (
        <button onClick={startReview}
          className="w-full flex items-center gap-3 p-4 rounded-2xl mb-4 bg-igbo-green text-white hover:bg-igbo-green/90 transition">
          <span className="text-2xl">🧠</span>
          <div className="text-left">
            <p className="font-bold">{dueWords.length} word{dueWords.length !== 1 ? 's' : ''} due for review</p>
            <p className="text-white/70 text-xs">Tap to start your spaced repetition session</p>
          </div>
          <span className="ml-auto">›</span>
        </button>
      )}

      {state.savedWords.length === 0 ? (
        <div className="card text-center py-16">
          <p className="text-4xl mb-3">🔖</p>
          <p className="font-bold mb-1">No saved words yet</p>
          <p className="text-white/40 text-sm">Tap the bookmark icon on any word in a lesson to save it here.</p>
        </div>
      ) : (
        <>
          <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Search saved words…"
            className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white placeholder:text-white/30 mb-4 outline-none focus:border-igbo-green/50" />
          <div className="space-y-2">
            {filtered.map((w, i) => (
              <div key={i} className="card flex items-center gap-3">
                {w.emoji && <span className="text-2xl w-8 text-center">{w.emoji}</span>}
                <div className="flex-1 min-w-0">
                  <p className="font-bold text-igbo-green">{w.igbo}</p>
                  <p className="text-white/60 text-sm">{w.english}</p>
                  <p className="text-white/30 text-xs font-mono">{w.pronunciation}</p>
                </div>
                <div className="flex gap-2 flex-shrink-0">
                  {state.srRecords[w.english] && (
                    <span className={`text-xs px-2 py-0.5 rounded-full ${new Date(state.srRecords[w.english].nextReview) <= new Date() ? 'bg-igbo-green/20 text-igbo-green' : 'bg-white/10 text-white/30'}`}>
                      {new Date(state.srRecords[w.english].nextReview) <= new Date() ? 'Due' : '✓'}
                    </span>
                  )}
                  <button onClick={() => speak(w.igbo)} className="p-1.5 text-igbo-green hover:bg-white/10 rounded-lg">🔊</button>
                  <button onClick={() => dispatch({ type: 'TOGGLE_SAVED', word: w })} className="p-1.5 hover:bg-white/10 rounded-lg text-white/50">✕</button>
                </div>
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  )
}
