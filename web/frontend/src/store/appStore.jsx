import { createContext, useContext, useReducer, useEffect } from 'react'

const KEYS = {
  savedWords: 'ig_saved_words',
  streak: 'ig_streak',
  lastActive: 'ig_last_active',
  wordsLearned: 'ig_words_learned',
  lessonsCompleted: 'ig_lessons_completed',
  srRecords: 'ig_sr_records',
}

function load(key, fallback) {
  try { return JSON.parse(localStorage.getItem(key)) ?? fallback }
  catch { return fallback }
}

const initialState = {
  savedWords: load(KEYS.savedWords, []),       // array of WordPair objects
  streakCount: load(KEYS.streak, 0),
  wordsLearned: load(KEYS.wordsLearned, 0),
  lessonsCompleted: load(KEYS.lessonsCompleted, 0),
  srRecords: load(KEYS.srRecords, {}),         // {wordID: {intervalIndex, nextReview}}
}

const SR_INTERVALS = [1, 3, 7, 14, 30, 60, 120]

function daysFromNow(days) {
  const d = new Date()
  d.setDate(d.getDate() + days)
  return d.toISOString()
}

function reducer(state, action) {
  switch (action.type) {
    case 'TOGGLE_SAVED': {
      const word = action.word
      const exists = state.savedWords.some(w => w.english === word.english)
      const savedWords = exists
        ? state.savedWords.filter(w => w.english !== word.english)
        : [...state.savedWords, word]
      // Enroll / unenroll SR
      const srRecords = { ...state.srRecords }
      if (!exists) {
        srRecords[word.english] = { intervalIndex: 0, nextReview: daysFromNow(1) }
      } else {
        delete srRecords[word.english]
      }
      return { ...state, savedWords, srRecords }
    }
    case 'SR_EASY': {
      const rec = state.srRecords[action.wordID]
      if (!rec) return state
      const nextIdx = Math.min(rec.intervalIndex + 1, SR_INTERVALS.length - 1)
      return { ...state, srRecords: {
        ...state.srRecords,
        [action.wordID]: { intervalIndex: nextIdx, nextReview: daysFromNow(SR_INTERVALS[nextIdx]) }
      }}
    }
    case 'SR_HARD': {
      return { ...state, srRecords: {
        ...state.srRecords,
        [action.wordID]: { intervalIndex: 0, nextReview: daysFromNow(1) }
      }}
    }
    case 'RECORD_ACTIVITY': {
      const today = new Date().toDateString()
      const last = load(KEYS.lastActive, '')
      const streak = last === today ? state.streakCount
        : last === new Date(Date.now() - 86400000).toDateString() ? state.streakCount + 1
        : 1
      localStorage.setItem(KEYS.lastActive, JSON.stringify(today))
      return { ...state, streakCount: streak }
    }
    case 'ADD_WORDS': {
      return { ...state, wordsLearned: state.wordsLearned + action.count }
    }
    case 'ADD_LESSON': {
      return { ...state, lessonsCompleted: state.lessonsCompleted + 1 }
    }
    default: return state
  }
}

const AppContext = createContext(null)

export function AppProvider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState)

  useEffect(() => { localStorage.setItem(KEYS.savedWords, JSON.stringify(state.savedWords)) }, [state.savedWords])
  useEffect(() => { localStorage.setItem(KEYS.streak, JSON.stringify(state.streakCount)) }, [state.streakCount])
  useEffect(() => { localStorage.setItem(KEYS.wordsLearned, JSON.stringify(state.wordsLearned)) }, [state.wordsLearned])
  useEffect(() => { localStorage.setItem(KEYS.lessonsCompleted, JSON.stringify(state.lessonsCompleted)) }, [state.lessonsCompleted])
  useEffect(() => { localStorage.setItem(KEYS.srRecords, JSON.stringify(state.srRecords)) }, [state.srRecords])

  const isSaved = (word) => state.savedWords.some(w => w.english === word.english)
  const dueWords = state.savedWords.filter(w => {
    const rec = state.srRecords[w.english]
    return rec && new Date(rec.nextReview) <= new Date()
  })

  return (
    <AppContext.Provider value={{ state, dispatch, isSaved, dueWords }}>
      {children}
    </AppContext.Provider>
  )
}

export const useApp = () => useContext(AppContext)
