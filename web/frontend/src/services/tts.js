// TTS service: backend ElevenLabs first, falls back to Web Speech API
import { API_BASE } from './api.js'

let selectedVoice = null

function pickVoice() {
  const voices = speechSynthesis.getVoices()
  return voices.find(v => v.lang === 'en-NG')
    || voices.find(v => v.lang === 'en-GB')
    || voices.find(v => v.lang.startsWith('en'))
    || null
}

speechSynthesis.onvoiceschanged = () => { selectedVoice = pickVoice() }

let currentAudio = null

export async function speak(text, language = 'ig') {  // Default to Igbo for this app
  if (!text) return

  // Stop any currently playing audio
  stop()

  try {
    // Server-side TTS: ElevenLabs multilingual (Ugochukwu Igbo voice), disk-cached
    const response = await fetch(`${API_BASE}/tts/synthesize`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text, language })
    })

    if (response.ok) {
      const blob = await response.blob()
      const audioUrl = URL.createObjectURL(blob)
      currentAudio = new Audio(audioUrl)
      currentAudio.play().catch(() => {
        // If audio play fails, fall back to Web Speech API
        fallbackToWebSpeech(text)
      })
      return
    }
  } catch (err) {
    // Network error or backend unavailable, use fallback
  }

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
  if (currentAudio) {
    currentAudio.pause()
    currentAudio.currentTime = 0
    currentAudio = null
  }
  speechSynthesis.cancel()
}
