export const TITLES = [
  { id: 0, igbo: 'Onye Ọhụrụ',     english: 'The Newcomer',    emoji: '🌱', color: '#6b7280', wordsRequired: 0,   lessonsRequired: 0,   streakRequired: 0  },
  { id: 1, igbo: 'Onye Ọmụmụ',     english: 'The Student',     emoji: '📖', color: '#60a5fa', wordsRequired: 10,  lessonsRequired: 1,   streakRequired: 0  },
  { id: 2, igbo: 'Onye Chọọ Ihe',  english: 'The Seeker',      emoji: '🔍', color: '#2dd4bf', wordsRequired: 30,  lessonsRequired: 5,   streakRequired: 2  },
  { id: 3, igbo: 'Onye Asụsụ',     english: 'The Speaker',     emoji: '🗣️', color: '#34d399', wordsRequired: 60,  lessonsRequired: 10,  streakRequired: 5  },
  { id: 4, igbo: 'Okorobia',        english: 'The Young Brave', emoji: '⚡', color: '#fbbf24', wordsRequired: 100, lessonsRequired: 20,  streakRequired: 7  },
  { id: 5, igbo: 'Odogwu',          english: 'The Champion',    emoji: '🏆', color: '#f97316', wordsRequired: 150, lessonsRequired: 30,  streakRequired: 14 },
  { id: 6, igbo: 'Dibia',           english: 'The Wise One',    emoji: '🧠', color: '#a855f7', wordsRequired: 200, lessonsRequired: 50,  streakRequired: 21 },
  { id: 7, igbo: 'Ichie',           english: 'The Title Holder',emoji: '🦅', color: '#219057', wordsRequired: 300, lessonsRequired: 75,  streakRequired: 30 },
  { id: 8, igbo: 'Ọzọ',            english: 'The Elder',       emoji: '👑', color: '#ef4444', wordsRequired: 400, lessonsRequired: 100, streakRequired: 60 },
  { id: 9, igbo: 'Eze Igbo',        english: 'The Igbo Master', emoji: '🌟', color: '#E8B021', wordsRequired: 500, lessonsRequired: 150, streakRequired: 90 },
]

export function currentTitle(words, lessons, streak) {
  for (let i = TITLES.length - 1; i >= 0; i--) {
    const t = TITLES[i]
    if (words >= t.wordsRequired && lessons >= t.lessonsRequired && streak >= t.streakRequired)
      return t
  }
  return TITLES[0]
}

export function nextTitle(current) {
  return TITLES[current.id + 1] || null
}

export function progressToNext(next, words, lessons, streak) {
  if (!next) return 1
  const scores = []
  if (next.wordsRequired > 0)   scores.push(Math.min(1, words   / next.wordsRequired))
  if (next.lessonsRequired > 0) scores.push(Math.min(1, lessons / next.lessonsRequired))
  if (next.streakRequired > 0)  scores.push(Math.min(1, streak  / next.streakRequired))
  return scores.length ? scores.reduce((a, b) => a + b) / scores.length : 1
}
