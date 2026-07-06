// Thin wrapper over the canonical stories.json source of truth.
// Components import from here; the data lives in stories.json so it can be
// shared/regenerated across platforms without touching component code.
import storiesData from './stories.json'

export const STORIES = storiesData

export const STORY_CATEGORIES = ['All', 'Animal Tales', 'Origin Stories', 'History & Culture', 'Modern']
