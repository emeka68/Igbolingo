// Unified speech-to-text: uses the native Capacitor plugin inside the
// mobile shell (iOS/Android webviews have no Web Speech API at all), and
// falls back to the browser's Web Speech API when running in a normal
// browser tab. Callers don't need to know which one is active.
import { Capacitor } from '@capacitor/core'

const isNative = Capacitor.isNativePlatform()

let nativeModulePromise = null
function loadNative() {
  if (!nativeModulePromise) {
    nativeModulePromise = import('@capacitor-community/speech-recognition')
      .then(m => m.SpeechRecognition)
  }
  return nativeModulePromise
}

export function isSpeechSupported() {
  if (isNative) return true
  return 'webkitSpeechRecognition' in window || 'SpeechRecognition' in window
}

/**
 * Listen for a single utterance.
 * @param {(text: string) => void} onResult
 * @param {(err?: Error) => void} onEnd - called whether it succeeded or not
 * @returns {() => void} stop function
 */
export async function listenOnce(onResult, onEnd) {
  if (isNative) {
    const SpeechRecognition = await loadNative()

    const perm = await SpeechRecognition.checkPermissions()
    if (perm.speechRecognition !== 'granted') {
      const req = await SpeechRecognition.requestPermissions()
      if (req.speechRecognition !== 'granted') {
        onEnd(new Error('Microphone/speech permission denied'))
        return () => {}
      }
    }

    let completed = false
    let listener
    const finish = (err) => {
      if (completed) return
      completed = true
      listener?.remove()
      SpeechRecognition.stop().catch(() => {})
      onEnd(err)
    }
    listener = await SpeechRecognition.addListener('partialResults', (data) => {
      const text = data?.matches?.[0]
      if (text && !completed) {
        onResult(text)
        finish()
      }
    })

    try {
      await SpeechRecognition.start({ language: 'en-US', partialResults: true, popup: false })
    } catch (e) {
      finish(e)
      return () => {}
    }

    const stop = () => finish()
    // The plugin doesn't reliably fire a distinct "end" event across
    // platforms, so the caller (UI) drives onEnd via stop()/timeout.
    return stop
  }

  // Web fallback
  const SR = window.SpeechRecognition || window.webkitSpeechRecognition
  const rec = new SR()
  rec.lang = 'en-US'
  rec.continuous = false
  rec.interimResults = false
  rec.onresult = (e) => onResult(e.results[0][0].transcript)
  rec.onerror = (e) => onEnd(new Error(e.error || 'speech recognition error'))
  rec.onend = () => onEnd()
  rec.start()
  return () => rec.stop()
}
