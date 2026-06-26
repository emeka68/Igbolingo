import { useApp } from '../../store/appStore'
import { speak } from '../../services/tts'

export default function WordCard({ word }) {
  const { isSaved, dispatch } = useApp()
  const saved = isSaved(word)

  return (
    <div className="card flex items-center gap-3">
      {word.emoji && <span className="text-3xl w-10 text-center flex-shrink-0">{word.emoji}</span>}
      <div className="flex-1 min-w-0">
        <p className="font-bold text-igbo-green text-lg leading-tight">{word.igbo}</p>
        <p className="text-white/70 text-sm">{word.english}</p>
        <p className="text-white/40 text-xs font-mono mt-0.5">{word.pronunciation}</p>
      </div>
      <div className="flex gap-2 flex-shrink-0">
        <button onClick={() => speak(word.igbo)}
          className="p-2 rounded-lg hover:bg-white/10 text-igbo-green transition text-lg">
          🔊
        </button>
        <button onClick={() => dispatch({ type: 'TOGGLE_SAVED', word })}
          className="p-2 rounded-lg hover:bg-white/10 transition text-lg">
          {saved ? '🔖' : '📑'}
        </button>
      </div>
    </div>
  )
}
