const BASE = '/api'

async function post(path, body) {
  const res = await fetch(`${BASE}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
  if (!res.ok) throw new Error(`API error ${res.status}`)
  return res.json()
}

export const DIALECTS = [
  { id: 'izugbe',  label: 'Standard',  note: 'Igbo Izugbe — central literary standard' },
  { id: 'onitsha', label: 'Onitsha',   note: 'Anambra riverine (experimental)' },
  { id: 'owerri',  label: 'Owerri',    note: 'Imo / central (experimental)' },
  { id: 'nsukka',  label: 'Nsukka',    note: 'Enugu / Waawa (experimental)' },
  { id: 'enuani',  label: 'Enuani',    note: 'Delta / West Niger (experimental)' },
]

export const api = {
  translateText: (text, dialect = 'izugbe') => post('/translate/text', { text, dialect }),
  translateSpeech: (text, dialect = 'izugbe') => post('/translate/speech', { text, dialect }),
  translateImage: async (file) => {
    const form = new FormData()
    form.append('file', file)
    const res = await fetch(`${BASE}/translate/image`, { method: 'POST', body: form })
    if (!res.ok) throw new Error('Image translation failed')
    return res.json()
  },
  culturalNote: (topic) => post('/learn/cultural-note', { topic }),
  generateQuiz: (words) => post('/learn/quiz', { words }),
}
