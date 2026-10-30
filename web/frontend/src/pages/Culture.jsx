import { useState } from 'react'
import { speak, stop } from '../services/tts'
import { todaysProverb, PROVERBS } from '../data/proverbs'
import { STORIES, STORY_CATEGORIES as CATEGORIES } from '../data/stories'

export default function Culture() {
  const [tab, setTab] = useState('stories')
  const [story, setStory] = useState(null)

  if (story) return <StoryReader story={story} onBack={() => { setStory(null); stop() }} />

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-3xl font-black mb-1">Omenala — Culture</h1>
      <p className="text-white/60 text-sm mb-5">Stories, words, and wisdom from Igbo culture.</p>

      <ProverbCard />

      <div className="flex gap-2 mb-6 mt-4 bg-white/5 p-1 rounded-xl">
        <button onClick={() => setTab('stories')}
          className={`flex-1 py-2 rounded-lg text-sm font-semibold transition ${tab === 'stories' ? 'bg-igbo-green text-white' : 'text-white/50'}`}>
          📖 Stories
        </button>
        <button onClick={() => setTab('proverbs')}
          className={`flex-1 py-2 rounded-lg text-sm font-semibold transition ${tab === 'proverbs' ? 'bg-igbo-green text-white' : 'text-white/50'}`}>
          💬 Proverbs
        </button>
      </div>

      {tab === 'stories' && <StoriesList stories={STORIES} onSelect={setStory} />}
      {tab === 'proverbs' && <ProverbsList />}
    </div>
  )
}

function ProverbCard() {
  const [expanded, setExpanded] = useState(false)
  const proverb = todaysProverb()
  return (
    <div className="card border border-igbo-gold/30 bg-igbo-gold/5">
      <div className="flex justify-between items-center mb-3">
        <span className="text-xs font-bold text-igbo-gold uppercase tracking-wide">💛 Ilu Ụbọchị — Proverb of the Day</span>
        <button onClick={() => speak(proverb.igbo)} aria-label="Listen to today's proverb" className="text-igbo-gold text-sm hover:opacity-70">🔊</button>
      </div>
      <p className="text-igbo-green font-bold italic mb-1">"{proverb.igbo}"</p>
      <p className="text-white/60 text-sm">"{proverb.english}"</p>
      {expanded && <p className="text-white/70 text-sm mt-3 leading-relaxed">{proverb.meaning}</p>}
      <button onClick={() => setExpanded(e => !e)} className="text-igbo-green text-xs font-bold mt-3 hover:opacity-70">
        {expanded ? 'Show less ▲' : 'What does it mean? ▼'}
      </button>
    </div>
  )
}

function StoriesList({ stories, onSelect }) {
  const [filter, setFilter] = useState('All')
  const filtered = filter === 'All' ? stories : stories.filter(s => s.category === filter)
  return (
    <div>
      <div className="flex gap-2 overflow-x-auto pb-2 mb-4 scrollbar-hide">
        {CATEGORIES.map(c => (
          <button key={c} onClick={() => setFilter(c)}
            className={`chip flex-shrink-0 ${filter === c ? 'bg-igbo-green border-igbo-green text-white' : 'border-white/20 text-white/50 hover:border-igbo-green/50'}`}>
            {c}
          </button>
        ))}
      </div>
      <p className="text-white/30 text-xs mb-3">{filtered.length} stor{filtered.length === 1 ? 'y' : 'ies'}</p>
      <div className="space-y-3">
        {filtered.map(story => (
          <button key={story.id} onClick={() => onSelect(story)}
            className="card w-full text-left flex items-center gap-4 hover:border-igbo-green/30 transition">
            <span className="text-4xl flex-shrink-0">{story.emoji}</span>
            <div className="flex-1 min-w-0">
              <span className="text-xs text-igbo-green font-bold">{story.category}</span>
              <p className="font-bold text-igbo-green leading-tight truncate">{story.title}</p>
              <p className="text-white/70 text-sm truncate">{story.subtitle}</p>
              <p className="text-white/30 text-xs mt-0.5">{story.paragraphs.length} parts · {story.igboWords.length} words</p>
            </div>
            <span className="text-white/30 flex-shrink-0">›</span>
          </button>
        ))}
      </div>
    </div>
  )
}

function StoryReader({ story, onBack }) {
  const [mode, setMode] = useState('paginated')
  const [pageIndex, setPageIndex] = useState(0)
  const [speaking, setSpeaking] = useState(false)
  const [showVocab, setShowVocab] = useState(false)
  const [fontSize, setFontSize] = useState(16)

  function readAloud(text) {
    setSpeaking(true); speak(text)
    setTimeout(() => setSpeaking(false), text.length * 80)
  }

  return (
    <div className="max-w-2xl mx-auto">
      <div className="flex items-center justify-between mb-6">
        <button onClick={onBack} className="btn-ghost pl-0">← Stories</button>
        <div className="flex gap-2">
          <button onClick={() => setShowVocab(v => !v)} className="chip border-white/20 text-white/50 hover:border-igbo-green/50">📚 Vocab</button>
          <button onClick={() => setFontSize(s => Math.max(13, s - 2))} className="chip border-white/20 text-white/50">A-</button>
          <button onClick={() => setFontSize(s => Math.min(24, s + 2))} className="chip border-white/20 text-white/50">A+</button>
        </div>
      </div>

      <div className="flex items-center gap-3 mb-4">
        <span className="text-4xl">{story.emoji}</span>
        <div>
          <h1 className="font-black text-igbo-green text-xl">{story.title}</h1>
          <p className="text-white/60 text-sm">{story.subtitle}</p>
        </div>
      </div>
      <p className="text-xs text-white/60 mb-4">Story text in English · Igbo vocabulary below</p>

      <div className="flex gap-2 mb-6 bg-white/5 p-1 rounded-xl">
        {['paginated', 'scroll'].map(m => (
          <button key={m} onClick={() => setMode(m)}
            className={`flex-1 py-1.5 rounded-lg text-sm font-semibold transition capitalize ${mode === m ? 'bg-igbo-green text-white' : 'text-white/40'}`}>
            {m === 'paginated' ? '📄 Paginated' : '📜 Scroll'}
          </button>
        ))}
      </div>

      {showVocab && (
        <div className="card mb-4 space-y-2">
          <p className="text-xs text-igbo-green font-bold uppercase mb-3">Key Words in This Story</p>
          {story.igboWords.map((w, i) => (
            <div key={i} className="flex items-center gap-3">
              {w.emoji && <span>{w.emoji}</span>}
              <div className="flex-1">
                <span className="font-bold text-igbo-green text-sm">{w.igbo}</span>
                <span className="text-white/40 text-xs ml-2">— {w.english}</span>
              </div>
              <button onClick={() => speak(w.igbo)} className="text-igbo-green hover:opacity-70">🔊</button>
            </div>
          ))}
        </div>
      )}

      {mode === 'paginated' ? (
        <div>
          <div className="flex justify-center gap-1 mb-4">
            {story.paragraphs.map((_, i) => (
              <div key={i} className={`h-1.5 rounded-full transition-all ${i === pageIndex ? 'w-6 bg-igbo-green' : 'w-1.5 bg-white/20'}`} />
            ))}
          </div>
          <div className="card min-h-[200px] flex flex-col justify-between">
            <p style={{ fontSize }} className="text-white/90 leading-relaxed">
              {story.paragraphs[pageIndex]}
            </p>
            {pageIndex === story.paragraphs.length - 1 && (
              <div className="mt-4 p-3 bg-igbo-green/10 rounded-xl border border-igbo-green/20">
                <p className="text-xs text-igbo-green font-bold mb-1">🌿 Moral</p>
                <p className="text-white/70 text-sm italic">{story.moralLesson}</p>
              </div>
            )}
          </div>
          <div className="flex gap-3 mt-4">
            <button onClick={() => setPageIndex(i => Math.max(0, i - 1))} disabled={pageIndex === 0}
              className="btn-ghost flex-1 disabled:opacity-30">← Prev</button>
            <button onClick={() => readAloud(story.paragraphs[pageIndex])} aria-label="Read this story page aloud"
              className={`p-3 rounded-xl transition ${speaking ? 'bg-igbo-green text-white' : 'bg-white/10 text-igbo-green hover:bg-white/20'}`}>
              🔊
            </button>
            <button onClick={() => setPageIndex(i => Math.min(story.paragraphs.length - 1, i + 1))}
              disabled={pageIndex === story.paragraphs.length - 1} className="btn-primary flex-1 disabled:opacity-30">
              Next →
            </button>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          <button onClick={() => readAloud(story.paragraphs.join(' '))}
            className={`btn-primary w-full ${speaking ? 'opacity-70' : ''}`}>
            {speaking ? '🔊 Reading…' : '🔊 Read Full Story Aloud'}
          </button>
          {story.paragraphs.map((p, i) => (
            <p key={i} style={{ fontSize }} className="text-white/90 leading-relaxed card">{p}</p>
          ))}
          <div className="card bg-igbo-green/10 border-igbo-green/20">
            <p className="text-xs text-igbo-green font-bold mb-1">🌿 Moral</p>
            <p className="text-white/70 italic">{story.moralLesson}</p>
          </div>
        </div>
      )}
    </div>
  )
}

function ProverbsList() {
  const [search, setSearch] = useState('')
  const [expanded, setExpanded] = useState(null)
  const today = todaysProverb()
  const filtered = PROVERBS.filter(p =>
    !search || p.igbo.toLowerCase().includes(search.toLowerCase()) || p.english.toLowerCase().includes(search.toLowerCase())
  )
  return (
    <div>
      <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Search proverbs…"
        className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white placeholder:text-white/30 mb-4 outline-none focus:border-igbo-green/50" />
      <p className="text-white/30 text-xs mb-3">{filtered.length} proverbs</p>
      <div className="space-y-2">
        {filtered.map((p, i) => (
          <div key={i} className={`card cursor-pointer hover:border-igbo-green/20 transition ${p === today ? 'border-igbo-gold/40' : ''}`}
            onClick={() => setExpanded(expanded === i ? null : i)}>
            {p === today && <span className="text-xs text-igbo-gold font-bold mb-1 block">⭐ Today's Proverb</span>}
            <div className="flex justify-between items-start gap-3">
              <div className="flex-1">
                <p className="font-bold text-igbo-green italic text-sm">"{p.igbo}"</p>
                <p className="text-white/50 text-xs mt-0.5">"{p.english}"</p>
              </div>
              <button onClick={e => { e.stopPropagation(); speak(p.igbo) }} className="text-igbo-green hover:opacity-70 flex-shrink-0">🔊</button>
            </div>
            {expanded === i && <p className="text-white/70 text-sm mt-3 leading-relaxed">{p.meaning}</p>}
          </div>
        ))}
      </div>
    </div>
  )
}
