import { useState } from 'react'
import { useApp } from '../../store/appStore'
import { currentTitle, nextTitle, progressToNext, TITLES } from '../../services/progression'

export default function TitleBadge() {
  const { state } = useApp()
  const [open, setOpen] = useState(false)
  const title = currentTitle(state.wordsLearned, state.lessonsCompleted, state.streakCount)
  const next = nextTitle(title)
  const prog = progressToNext(next, state.wordsLearned, state.lessonsCompleted, state.streakCount)

  return (
    <>
      <button onClick={() => setOpen(true)}
        className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl border transition hover:opacity-80"
        style={{ background: `${title.color}18`, borderColor: `${title.color}40` }}>
        <span className="text-2xl">{title.emoji}</span>
        <div className="text-left flex-1">
          <p className="font-bold text-sm leading-tight" style={{ color: title.color }}>{title.igbo}</p>
          <p className="text-white/50 text-xs">{title.english}</p>
        </div>
        <span className="text-white/30 text-xs">›</span>
      </button>

      {open && (
        <div className="fixed inset-0 z-50 flex items-end md:items-center justify-center bg-black/60 p-4" onClick={() => setOpen(false)}>
          <div className="bg-igbo-card rounded-2xl w-full max-w-md max-h-[85vh] overflow-y-auto p-6" onClick={e => e.stopPropagation()}>
            {/* Current title */}
            <div className="text-center mb-6">
              <p className="text-5xl mb-2">{title.emoji}</p>
              <h2 className="text-2xl font-black" style={{ color: title.color }}>{title.igbo}</h2>
              <p className="text-white/60">{title.english}</p>
            </div>

            {/* Progress to next */}
            {next && (
              <div className="bg-white/5 rounded-xl p-4 mb-6">
                <div className="flex justify-between text-sm mb-2">
                  <span className="text-white/60">Next: <strong style={{ color: next.color }}>{next.igbo}</strong></span>
                  <span className="font-bold" style={{ color: next.color }}>{Math.round(prog * 100)}%</span>
                </div>
                <div className="h-2 bg-white/10 rounded-full overflow-hidden">
                  <div className="h-full rounded-full transition-all" style={{ width: `${prog * 100}%`, background: next.color }} />
                </div>
                <div className="flex gap-3 mt-3 text-xs text-white/50">
                  <span>📚 {state.wordsLearned}/{next.wordsRequired} words</span>
                  <span>✅ {state.lessonsCompleted}/{next.lessonsRequired} lessons</span>
                  {next.streakRequired > 0 && <span>🔥 {state.streakCount}/{next.streakRequired} streak</span>}
                </div>
              </div>
            )}

            {/* Ladder */}
            <div className="space-y-1">
              {TITLES.map(t => {
                const unlocked = t.id <= title.id
                return (
                  <div key={t.id} className={`flex items-center gap-3 p-3 rounded-xl ${t.id === title.id ? 'bg-white/10' : ''}`}>
                    <span className="text-xl w-8 text-center">{unlocked ? t.emoji : '🔒'}</span>
                    <div className="flex-1">
                      <p className="font-semibold text-sm" style={{ color: unlocked ? t.color : '#ffffff40' }}>{t.igbo}</p>
                      <p className="text-xs text-white/40">{t.english}</p>
                    </div>
                    {t.id === title.id && (
                      <span className="text-xs font-bold px-2 py-0.5 rounded-full" style={{ color: t.color, background: `${t.color}20` }}>NOW</span>
                    )}
                    {unlocked && t.id !== title.id && <span className="text-green-400 text-sm">✓</span>}
                  </div>
                )
              })}
            </div>

            <button onClick={() => setOpen(false)} className="btn-primary w-full mt-6">Close</button>
          </div>
        </div>
      )}
    </>
  )
}
