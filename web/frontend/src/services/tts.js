// TTS service: backend ElevenLabs first, falls back to Web Speech API
import { API_BASE } from './api.js'

let selectedVoice = null

function pickVoice() {
  if (!('speechSynthesis' in window)) return null
  const voices = speechSynthesis.getVoices()
  return voices.find(v => v.lang === 'en-NG')
    || voices.find(v => v.lang === 'en-GB')
    || voices.find(v => v.lang.startsWith('en'))
    || null
}

if ('speechSynthesis' in window) {
  speechSynthesis.addEventListener('voiceschanged', () => { selectedVoice = pickVoice() })
}

let currentAudio = null
let currentUrl = null
let pendingRequest = null
let playbackToken = 0

export async function speak(text, language = 'ig') {  // Default to Igbo for this app
  if (!text) return

  // Stop any currently playing audio
  stop()
  const token = playbackToken
  const request = new AbortController()
  pendingRequest = request

  try {
    // Server-side TTS: ElevenLabs multilingual (Ugochukwu Igbo voice), disk-cached
    const response = await fetch(`${API_BASE}/tts/synthesize`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text, language }),
      signal: request.signal
    })

    if (response.ok) {
      const blob = await response.blob()
      if (request.signal.aborted || token !== playbackToken) return
      pendingRequest = null
      const audioUrl = URL.createObjectURL(blob)
      currentUrl = audioUrl
      currentAudio = new Audio(audioUrl)
      currentAudio.onended = () => stop()
      currentAudio.play().catch(() => {
        // If audio play fails, fall back to Web Speech API
        if (!request.signal.aborted && token === playbackToken) fallbackToWebSpeech(text)
      })
      return
    }
  } catch (err) {
    // Network error or backend unavailable, use fallback
  }

  if (request.signal.aborted || token !== playbackToken) return
  pendingRequest = null
  // Fallback to Web Speech API if backend fails
  fallbackToWebSpeech(text)
}

function fallbackToWebSpeech(text) {
  if (!('speechSynthesis' in window)) return

  speechSynthesis.cancel()
  const utt = new SpeechSynthesisUtterance(text)
  utt.voice = selectedVoice || pickVoice()
  utt.rate = 0.85
  utt.pitch = 1.05
  speechSynthesis.speak(utt)
}

export function stop() {
  playbackToken += 1
  if (pendingRequest) {
    pendingRequest.abort()
    pendingRequest = null
  }
  if (currentAudio) {
    currentAudio.pause()
    currentAudio.currentTime = 0
    currentAudio = null
  }
  if (currentUrl) {
    URL.revokeObjectURL(currentUrl)
    currentUrl = null
  }
  if ('speechSynthesis' in window) speechSynthesis.cancel()
}
