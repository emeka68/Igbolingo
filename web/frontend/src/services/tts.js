// TTS service: tries backend espeak-ng first (better Igbo), falls back to Web Speech API
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

export async function speak(text, language = 'en') {
  if (!text) return

  // Stop any currently playing audio
  stop()

  try {
    // Try server-side TTS (espeak-ng with Igbo support)
    const response = await fetch('/api/tts/synthesize', {
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
