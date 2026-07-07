import { useState, useRef } from 'react'
import { api, DIALECTS } from '../services/api'
import { speak } from '../services/tts'

const TABS = ['Text', 'Image', 'Voice']

export default function Translator() {
  const [tab, setTab] = useState('Text')
  const [dialect, setDialect] = useState('izugbe')

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-black mb-6">Translate</h1>
      <div className="flex gap-2 mb-4 bg-white/5 p-1 rounded-xl">
        {TABS.map(t => (
          <button key={t} onClick={() => setTab(t)}
            className={`flex-1 py-2 rounded-lg text-sm font-semibold transition
              ${tab === t ? 'bg-igbo-green text-white' : 'text-white/50 hover:text-white'}`}>
            {t === 'Text' ? '✍️' : t === 'Image' ? '📷' : '🎙️'} {t}
          </button>
        ))}
      </div>

      {/* Dialect selector — applies to Text and Voice translation */}
      {tab !== 'Image' && <DialectSelector dialect={dialect} setDialect={setDialect} />}

      {tab === 'Text'  && <TextTranslator dialect={dialect} />}
      {tab === 'Image' && <ImageTranslator />}
      {tab === 'Voice' && <VoiceTranslator dialect={dialect} />}
    </div>
  )
}

function DialectSelector({ dialect, setDialect }) {
  const current = DIALECTS.find(d => d.id === dialect) || DIALECTS[0]
  return (
    <div className="mb-6">
      <div className="flex gap-1.5 overflow-x-auto pb-1">
        {DIALECTS.map(d => (
          <button key={d.id} onClick={() => setDialect(d.id)}
            className={`chip flex-shrink-0 text-xs ${dialect === d.id
              ? 'bg-igbo-green border-igbo-green text-white'
              : 'border-white/20 text-white/50 hover:border-igbo-green/50'}`}>
            {d.label}
          </button>
        ))}
      </div>
      <p className="text-white/30 text-xs mt-1.5">
        {current.note}{dialect !== 'izugbe' && ' — dialect output is best-effort'}
      </p>
    </div>
  )
}

function TextTranslator({ dialect }) {
  const [input, setInput] = useState('')
  const [result, setResult] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  async function translate() {
    if (!input.trim()) return
    setLoading(true); setError(''); setResult(null)
    try {
      const data = await api.translateText(input.trim(), dialect)
      setResult(data)
      speak(data.igbo)
    } catch { setError('Translation failed. Check the backend is running.') }
    finally { setLoading(false) }
  }

  return (
    <div className="space-y-4">
      <div className="card">
        <label className="text-xs text-white/40 uppercase font-semibold tracking-wide">English</label>
        <textarea value={input} onChange={e => setInput(e.target.value)}
          onKeyDown={e => e.key === 'Enter' && !e.shiftKey && (e.preventDefault(), translate())}
          placeholder="Type something to translate…"
          className="w-full bg-transparent text-white mt-2 resize-none outline-none text-lg min-h-[80px] placeholder:text-white/20"
          rows={3} />
      </div>
      <button onClick={translate} disabled={loading || !input.trim()} className="btn-primary w-full">
        {loading ? 'Translating…' : 'Translate → Igbo'}
      </button>
      {error && <p className="text-red-400 text-sm text-center">{error}</p>}
      {result && (
        <div className="card space-y-4">
          <div className="flex items-start justify-between gap-4">
            <div>
              <label className="text-xs text-white/40 uppercase font-semibold tracking-wide">Igbo</label>
              <p className="text-3xl font-black text-igbo-green mt-1">{result.igbo}</p>
            </div>
            <button onClick={() => speak(result.igbo)} className="p-2 rounded-xl hover:bg-white/10 text-igbo-green text-2xl">🔊</button>
          </div>
          {result.pronunciation && (
            <div>
              <label className="text-xs text-white/40 uppercase font-semibold tracking-wide">Pronunciation</label>
              <p className="text-white/80 font-mono mt-1">{result.pronunciation}</p>
            </div>
          )}
          {result.tones && (
            <div>
              <label className="text-xs text-white/40 uppercase font-semibold tracking-wide">Tones</label>
              <p className="text-white/60 text-sm mt-1">{result.tones}</p>
            </div>
          )}
          {result.example && (
            <div className="bg-white/5 rounded-xl p-3">
              <label className="text-xs text-white/40 uppercase font-semibold tracking-wide">Example</label>
              <p className="text-igbo-green mt-1 italic">"{result.example}"</p>
              {result.exampleTranslation && <p className="text-white/50 text-sm mt-0.5">"{result.exampleTranslation}"</p>}
            </div>
          )}
        </div>
      )}
    </div>
  )
}

function ImageTranslator() {
  const [words, setWords] = useState([])
  const [loading, setLoading] = useState(false)
  const [preview, setPreview] = useState(null)
  const [error, setError] = useState('')
  const fileRef = useRef()

  async function handleFile(file) {
    if (!file) return
    setPreview(URL.createObjectURL(file))
    setLoading(true); setError(''); setWords([])
    try {
      const data = await api.translateImage(file)
      setWords(data)
    } catch { setError('Image translation failed.') }
    finally { setLoading(false) }
  }

  return (
    <div className="space-y-4">
      <div className="card border-2 border-dashed border-white/10 text-center cursor-pointer hover:border-igbo-green/50 transition"
        onClick={() => fileRef.current?.click()}
        onDrop={e => { e.preventDefault(); handleFile(e.dataTransfer.files[0]) }}
        onDragOver={e => e.preventDefault()}>
        {preview ? (
          <img src={preview} alt="uploaded" className="max-h-48 mx-auto rounded-xl object-cover" />
        ) : (
          <div className="py-12">
            <p className="text-4xl mb-3">📷</p>
            <p className="text-white/50">Drop an image or tap to upload</p>
            <p className="text-white/30 text-sm mt-1">Point at objects to learn their Igbo names</p>
          </div>
        )}
        <input ref={fileRef} type="file" accept="image/*" className="hidden" onChange={e => handleFile(e.target.files[0])} />
      </div>
      {loading && <p className="text-center text-igbo-green animate-pulse">Identifying objects…</p>}
      {error && <p className="text-red-400 text-sm text-center">{error}</p>}
      {words.map((w, i) => (
        <div key={i} className="card flex items-center gap-3">
          {w.emoji && <span className="text-2xl">{w.emoji}</span>}
          <div className="flex-1">
            <p className="font-bold text-igbo-green">{w.igbo}</p>
            <p className="text-white/60 text-sm">{w.english}</p>
            <p className="text-white/30 text-xs font-mono">{w.pronunciation}</p>
          </div>
          <button onClick={() => speak(w.igbo)} className="p-2 text-igbo-green hover:bg-white/10 rounded-lg text-lg">🔊</button>
        </div>
      ))}
    </div>
  )
}

function VoiceTranslator({ dialect }) {
  const [listening, setListening] = useState(false)
  const [transcript, setTranscript] = useState('')
  const [result, setResult] = useState(null)
  const [loading, setLoading] = useState(false)
  const recognitionRef = useRef(null)

  function toggleListen() {
    if (!('webkitSpeechRecognition' in window || 'SpeechRecognition' in window)) {
      alert('Speech recognition not supported in this browser. Try Chrome.')
      return
    }
    if (listening) {
      recognitionRef.current?.stop()
      setListening(false)
      return
    }
    const SR = window.SpeechRecognition || window.webkitSpeechRecognition
    const rec = new SR()
    rec.lang = 'en-US'; rec.continuous = false; rec.interimResults = false
    rec.onresult = async (e) => {
      const text = e.results[0][0].transcript
      setTranscript(text); setListening(false); setLoading(true)
      try {
        const data = await api.translateSpeech(text, dialect)
        setResult(data); speak(data.igbo)
      } catch {}
      finally { setLoading(false) }
    }
    rec.onerror = () => setListening(false)
    rec.onend = () => setListening(false)
    recognitionRef.current = rec
    rec.start(); setListening(true)
  }

  return (
    <div className="space-y-6 text-center">
      <div className="py-8">
        <button onClick={toggleListen}
          className={`w-28 h-28 rounded-full text-4xl font-bold transition-all shadow-lg mx-auto flex items-center justify-center
            ${listening ? 'bg-red-500 animate-pulse scale-110' : 'bg-igbo-green hover:scale-105'}`}>
          {listening ? '⏹' : '🎙️'}
        </button>
        <p className="text-white/50 mt-4 text-sm">
          {listening ? 'Listening… speak now' : 'Tap to speak English'}
        </p>
      </div>
      {transcript && (
        <div className="card text-left">
          <label className="text-xs text-white/40 uppercase font-semibold">You said</label>
          <p className="text-white mt-1">"{transcript}"</p>
        </div>
      )}
      {loading && <p className="text-igbo-green animate-pulse">Translating…</p>}
      {result && (
        <div className="card text-left">
          <div className="flex justify-between items-start">
            <div>
              <label className="text-xs text-white/40 uppercase font-semibold">In Igbo</label>
              <p className="text-2xl font-black text-igbo-green mt-1">{result.igbo}</p>
              {result.pronunciation && <p className="text-white/50 font-mono text-sm mt-1">{result.pronunciation}</p>}
            </div>
            <button onClick={() => speak(result.igbo)} className="text-igbo-green text-2xl p-2 hover:bg-white/10 rounded-lg">🔊</button>
          </div>
        </div>
      )}
    </div>
  )
}
