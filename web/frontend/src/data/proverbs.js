// Thin wrapper over the canonical proverbs.json source of truth.
import proverbsData from './proverbs.json'

export const PROVERBS = proverbsData

export function todaysProverb() {
  const dayOfYear = Math.floor((new Date() - new Date(new Date().getFullYear(), 0, 0)) / 86400000)
  return PROVERBS[(dayOfYear - 1) % PROVERBS.length]
}
