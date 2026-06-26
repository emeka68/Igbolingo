// Web Speech API TTS — uses en-NG voice if available, falls back to en-GB/en-US
let selectedVoice = null

function pickVoice() {
  const voices = speechSynthesis.getVoices()
  return voices.find(v => v.lang === 'en-NG')
    || voices.find(v => v.lang === 'en-GB')
    || voices.find(v => v.lang.startsWith('en'))
    || null
}

speechSynthesis.onvoiceschanged = () => { selectedVoice = pickVoice() }

export function speak(text, rate = 0.85) {
  if (!text || !('speechSynthesis' in window)) return
  speechSynthesis.cancel()
  const utt = new SpeechSynthesisUtterance(text)
  utt.voice = selectedVoice || pickVoice()
  utt.rate = rate
  utt.pitch = 1.05
  speechSynthesis.speak(utt)
}

export function stop() {
  speechSynthesis.cancel()
}
