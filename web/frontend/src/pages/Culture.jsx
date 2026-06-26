import { useState } from 'react'
import { speak, stop } from '../services/tts'
import { todaysProverb, PROVERBS } from '../data/proverbs'

// Inline a few sample stories (full set would be imported from a stories.js data file)
const STORIES = [
  {
    id: 1, title: "Mbe na Nnụnụ", subtitle: "The Tortoise and the Birds", emoji: "🐢", category: "Animal Tales",
    moralLesson: "Greed and deception will always find you out.",
    paragraphs: [
      "Long, long ago, when animals still spoke and the sky was full of wonder, the birds of the forest received an invitation. A great feast was being held in the sky, and every bird was welcome.",
      "Now Mbe, the tortoise, heard all of this and his belly growled with longing. He had no wings, but he had a tongue as smooth as palm oil. He went to the birds and said: 'Let me come with you, and I shall speak on your behalf.' The birds, trusting and generous, each gave him one feather.",
      "As they flew upward, Mbe spoke again. 'It is the custom up here to take new names. My new name shall be: All of You.' The birds thought this was interesting, so each chose a sky-name.",
      "At the feast, the sky people announced: 'This food is for All of You!' And Mbe stepped forward and ate everything — all the finest portions — because his name was All of You.",
      "The furious birds took back their feathers on the way down, leaving Mbe with nothing. He fell from the sky and landed on the hard earth, shattering his once-smooth shell.",
      "To this day, the tortoise carries a cracked and patched shell — a permanent reminder that cleverness used for greed always leaves its mark."
    ],
    igboWords: [
      { english: "Tortoise", igbo: "Mbe", pronunciation: "mm-BEH", emoji: "🐢" },
      { english: "Birds", igbo: "Nnụnụ", pronunciation: "nn-OO-noo", emoji: "🐦" },
      { english: "Sky", igbo: "Igwe", pronunciation: "EE-gweh", emoji: "☁️" },
      { english: "Feast", igbo: "Oriri", pronunciation: "oh-REE-ree", emoji: "🍽️" },
      { english: "Feather", igbo: "Ìkiikè", pronunciation: "ee-KEE-keh", emoji: "🪶" },
      { english: "Greed", igbo: "Ọchịchọ", pronunciation: "oh-CHEE-choh", emoji: "💰" },
    ]
  },
  {
    id: 2, title: "Gịnị mere nkịta bi na ụlọ mmadụ", subtitle: "Why the Dog Lives with Man", emoji: "🐕", category: "Animal Tales",
    moralLesson: "Loyalty freely given is worth more than any treasure.",
    paragraphs: [
      "In the time before time, the dog did not live with man. He lived in the forest with the other animals — the leopard, the monkey, the goat — and they all kept to themselves.",
      "One dry season, hunger fell on the forest so heavily that even the insects hid. The leopard prowled but found nothing. The monkey searched the treetops and came down with empty hands. One by one, the animals slipped away.",
      "Only the dog stayed. He had been hunting with man's son — a young boy who had once shared his roasted yam without being asked. The dog thought of this kindness and felt something he could not name.",
      "He found the boy's family struggling — the father sick, the mother exhausted, the children thin. The dog went out before dawn and found a hare. He carried it back and lay it at the door of the compound. He did this again the next day. And the next.",
      "The boy's mother saw him and wept. She called her husband. 'This animal has been feeding us,' she said. The father rose and called to the dog: 'Come in. This compound is yours.'",
      "And from that day, the dog came inside — not because he was told to, but because he had chosen it. He had found something worth more than freedom without love: a family that called him home."
    ],
    igboWords: [
      { english: "Dog", igbo: "Nkịta", pronunciation: "n-KEE-tah", emoji: "🐕" },
      { english: "Loyalty", igbo: "Ikwesị", pronunciation: "ee-KWEH-see", emoji: "🤝" },
      { english: "Home", igbo: "Ụlọ", pronunciation: "oo-LOH", emoji: "🏠" },
      { english: "Kindness", igbo: "Mmadụ ọma", pronunciation: "mm-AH-doo oh-MAH", emoji: "💚" },
      { english: "Forest", igbo: "Ọhịa", pronunciation: "oh-HEE-ah", emoji: "🌳" },
      { english: "Hunger", igbo: "Agụụ", pronunciation: "ah-GWOO", emoji: "😔" },
    ]
  },
  {
    id: 3, title: "Gịnị mere oji dị nsọ", subtitle: "How Kola Nut Became Sacred", emoji: "🌰", category: "Origin Stories",
    moralLesson: "The things we share in truth and peace carry a holiness that no ceremony can manufacture.",
    paragraphs: [
      "In the time when the earth was still learning its own name, Chukwu looked down and saw that his children were scattered and afraid. They did not know how to speak to one another across distance.",
      "He plucked a small, bitter nut from the tree at the centre of the world and sent it down with a messenger named Oji. 'Give this to the first person you meet,' Chukwu said, 'and tell them: whoever shares this shares life itself.'",
      "Oji walked until he found a village. He was a stranger there — dusty, hungry, uncertain. But he walked to the compound of the eldest man, knelt, and offered the nut with both hands.",
      "The old man looked at the nut and at the young stranger. He could have kept it for himself. Instead, he called his family, then his neighbours, then the whole village — and he broke the nut open and shared each lobe.",
      "When the last lobe was given, everyone in the circle felt something pass through them — warmth, belonging, something they had no word for. They had been strangers and were now, in some small permanent way, connected.",
      "Chukwu declared: 'From this day, no gathering shall begin without the kola nut. No stranger shall be a stranger once it is offered.' And that is why the Igbo do not begin anything of importance without first lifting the oji."
    ],
    igboWords: [
      { english: "Kola nut", igbo: "Oji", pronunciation: "OH-jee", emoji: "🌰" },
      { english: "Sacred", igbo: "Nsọ", pronunciation: "n-SOH", emoji: "✨" },
      { english: "Stranger", igbo: "Onye ọbịa", pronunciation: "oh-NYEH oh-BEE-ah", emoji: "👤" },
      { english: "Share", igbo: "Kee", pronunciation: "KEH", emoji: "🤲" },
      { english: "Life", igbo: "Ndụ", pronunciation: "n-DOO", emoji: "🌱" },
      { english: "God", igbo: "Chukwu", pronunciation: "CHOO-kwoo", emoji: "🙏" },
    ]
  },
  {
    id: 4, title: "Ikenga — Chi ike mmadụ", subtitle: "The Spirit of Personal Achievement", emoji: "🗿", category: "History & Culture",
    moralLesson: "Your achievements are made of the same material as your character. The Ikenga is not a lucky charm; it is a mirror.",
    paragraphs: [
      "Every Igbo man who amounted to something kept one on his shelf: a carved wooden figure with horns curving upward and hands gripping implements of achievement. This was the Ikenga — unlike any other object in Igboland.",
      "The Ikenga represented the chi ike of a man — the force of his right hand, the energy of his personal achievement, the accumulated result of everything he had worked toward.",
      "When a man succeeded — when he took a title, harvested a great crop, raised a fine family — he brought gifts to his Ikenga: palm wine, kola nut, sometimes the blood of a goat. Not because the Ikenga had done these things, but because he and his Ikenga had done them together.",
      "There was a man named Okafor who had an Ikenga passed down from his grandfather. When Okafor fell into debt and lost nearly everything, he put the Ikenga away in a cloth and hid it in the rafters.",
      "His young son found it and said: 'You are still alive. You still have your right hand.' Okafor looked at the carved figure for a long time.",
      "He began again the next morning. Small work, honest work, one day at a time. Years later, when people asked how he had rebuilt, he pointed to the figure on the shelf and said: 'I remembered what I already was.'"
    ],
    igboWords: [
      { english: "Achievement", igbo: "Ọrụ ike", pronunciation: "oh-ROO ee-KEH", emoji: "🏆" },
      { english: "Right hand", igbo: "Aka nri", pronunciation: "AH-kah n-REE", emoji: "✋" },
      { english: "Effort", igbo: "Ọrụ", pronunciation: "oh-ROO", emoji: "💪" },
      { english: "Character", igbo: "Agwa", pronunciation: "AH-gwah", emoji: "⭐" },
      { english: "Ancestor", igbo: "Nna ochie", pronunciation: "nn-AH oh-CHEE-yeh", emoji: "👴" },
      { english: "Carving", igbo: "Ịkwa osisi", pronunciation: "ee-KWAH oh-SEE-see", emoji: "🗿" },
    ]
  },
  {
    id: 5, title: "Ụmụnne abụọ na obodo ukwu", subtitle: "Two Brothers and the City", emoji: "🌆", category: "Modern",
    moralLesson: "You can go far and still belong to where you came from. The roots do not stop a tree from growing tall.",
    paragraphs: [
      "Two brothers left their village on the same morning — Emeka in a sharp shirt with a school certificate, and Chidi carrying only a rolled mat and a pot his mother pressed into his hands.",
      "Emeka found work quickly. He wore the sharp shirt every day, learned to talk fast, to eat things wrapped in plastic, to move through crowds without looking at anyone. He sent money home and felt that this was enough.",
      "Chidi struggled. He did not talk fast. He found a small job at a carpenter's shop and spent evenings cooking the same soups his mother cooked, filling the small room with smells that made him ache and glad at the same time.",
      "One evening, Emeka passed by Chidi's room and stopped in the doorway. He could smell ofe onugbu — bitter leaf soup. He stood there and felt something move in him that he had been carefully not feeling for two years.",
      "'You cook that here?' he said. Chidi looked up. 'Every week. Sit down.' Emeka sat. He ate the soup. He said, very quietly: 'I forgot what it tasted like.' Chidi said: 'You forgot a lot of things.'",
      "That night, Emeka called his mother for the first time in months. The next Sunday, both brothers took the bus back to the village together. You do not have to choose between where you are going and where you came from. The soil travels in your shoes."
    ],
    igboWords: [
      { english: "Brother", igbo: "Nwanne nwoke", pronunciation: "n-WAHN-neh n-WOH-keh", emoji: "👦" },
      { english: "Village", igbo: "Obodo", pronunciation: "oh-BOH-doh", emoji: "🏘️" },
      { english: "City", igbo: "Obodo ukwu", pronunciation: "oh-BOH-doh oo-KWOO", emoji: "🌆" },
      { english: "Mother", igbo: "Nne", pronunciation: "nn-EH", emoji: "👩" },
      { english: "Home", igbo: "Ụlọ", pronunciation: "oo-LOH", emoji: "🏠" },
      { english: "Remember", igbo: "Echeta", pronunciation: "eh-CHEH-tah", emoji: "💭" },
    ]
  },
]

const CATEGORIES = ['All', 'Animal Tales', 'Origin Stories', 'History & Culture', 'Modern']

export default function Culture() {
  const [tab, setTab] = useState('stories')
  const [story, setStory] = useState(null)

  if (story) return <StoryReader story={story} onBack={() => { setStory(null); stop() }} />

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-black mb-4">Omenala — Culture</h1>

      <ProverbCard />

      <div className="flex gap-2 mb-6 mt-4 bg-white/5 p-1 rounded-xl">
        <button onClick={() => setTab('stories')}
          className={`flex-1 py-2 rounded-lg text-sm font-semibold transition ${tab === 'stories' ? 'bg-igbo-green text-white' : 'text-white/50'}`}>
          📖 Stories
        </button>
        <button onClick={() => setTab('proverbs')}
          className={`flex-1 py-2 rounded-lg text-sm font-semibold transition ${tab === 'proverbs' ? 'bg-igbo-green text-white' : 'text-white/50'}`}>
          💬 Proverbs
        </button>
      </div>

      {tab === 'stories' && <StoriesList stories={STORIES} onSelect={setStory} />}
      {tab === 'proverbs' && <ProverbsList />}
    </div>
  )
}

function ProverbCard() {
  const [expanded, setExpanded] = useState(false)
  const proverb = todaysProverb()
  return (
    <div className="card border border-igbo-gold/30 bg-igbo-gold/5">
      <div className="flex justify-between items-center mb-3">
        <span className="text-xs font-bold text-igbo-gold uppercase tracking-wide">💛 Ilu Ụbọchị — Proverb of the Day</span>
        <button onClick={() => speak(proverb.igbo)} className="text-igbo-gold text-sm hover:opacity-70">🔊</button>
      </div>
      <p className="text-igbo-green font-bold italic mb-1">"{proverb.igbo}"</p>
      <p className="text-white/60 text-sm">"{proverb.english}"</p>
      {expanded && <p className="text-white/70 text-sm mt-3 leading-relaxed">{proverb.meaning}</p>}
      <button onClick={() => setExpanded(e => !e)} className="text-igbo-green text-xs font-bold mt-3 hover:opacity-70">
        {expanded ? 'Show less ▲' : 'What does it mean? ▼'}
      </button>
    </div>
  )
}

function StoriesList({ stories, onSelect }) {
  const [filter, setFilter] = useState('All')
  const filtered = filter === 'All' ? stories : stories.filter(s => s.category === filter)
  return (
    <div>
      <div className="flex gap-2 overflow-x-auto pb-2 mb-4 scrollbar-hide">
        {CATEGORIES.map(c => (
          <button key={c} onClick={() => setFilter(c)}
            className={`chip flex-shrink-0 ${filter === c ? 'bg-igbo-green border-igbo-green text-white' : 'border-white/20 text-white/50 hover:border-igbo-green/50'}`}>
            {c}
          </button>
        ))}
      </div>
      <p className="text-white/30 text-xs mb-3">{filtered.length} stor{filtered.length === 1 ? 'y' : 'ies'}</p>
      <div className="space-y-3">
        {filtered.map(story => (
          <button key={story.id} onClick={() => onSelect(story)}
            className="card w-full text-left flex items-center gap-4 hover:border-igbo-green/30 transition">
            <span className="text-4xl flex-shrink-0">{story.emoji}</span>
            <div className="flex-1 min-w-0">
              <span className="text-xs text-igbo-green font-bold">{story.category}</span>
              <p className="font-bold text-igbo-green leading-tight truncate">{story.title}</p>
              <p className="text-white/70 text-sm truncate">{story.subtitle}</p>
              <p className="text-white/30 text-xs mt-0.5">{story.paragraphs.length} parts · {story.igboWords.length} words</p>
            </div>
            <span className="text-white/30 flex-shrink-0">›</span>
          </button>
        ))}
      </div>
    </div>
  )
}

function StoryReader({ story, onBack }) {
  const [mode, setMode] = useState('paginated')
  const [pageIndex, setPageIndex] = useState(0)
  const [speaking, setSpeaking] = useState(false)
  const [showVocab, setShowVocab] = useState(false)
  const [fontSize, setFontSize] = useState(16)

  function readAloud(text) {
    setSpeaking(true); speak(text)
    setTimeout(() => setSpeaking(false), text.length * 80)
  }

  return (
    <div className="max-w-2xl mx-auto">
      <div className="flex items-center justify-between mb-6">
        <button onClick={onBack} className="btn-ghost pl-0">← Stories</button>
        <div className="flex gap-2">
          <button onClick={() => setShowVocab(v => !v)} className="chip border-white/20 text-white/50 hover:border-igbo-green/50">📚 Vocab</button>
          <button onClick={() => setFontSize(s => Math.max(13, s - 2))} className="chip border-white/20 text-white/50">A-</button>
          <button onClick={() => setFontSize(s => Math.min(24, s + 2))} className="chip border-white/20 text-white/50">A+</button>
        </div>
      </div>

      <div className="flex items-center gap-3 mb-4">
        <span className="text-4xl">{story.emoji}</span>
        <div>
          <h1 className="font-black text-igbo-green text-xl">{story.title}</h1>
          <p className="text-white/60 text-sm">{story.subtitle}</p>
        </div>
      </div>

      <div className="flex gap-2 mb-6 bg-white/5 p-1 rounded-xl">
        {['paginated', 'scroll'].map(m => (
          <button key={m} onClick={() => setMode(m)}
            className={`flex-1 py-1.5 rounded-lg text-sm font-semibold transition capitalize ${mode === m ? 'bg-igbo-green text-white' : 'text-white/40'}`}>
            {m === 'paginated' ? '📄 Paginated' : '📜 Scroll'}
          </button>
        ))}
      </div>

      {showVocab && (
        <div className="card mb-4 space-y-2">
          <p className="text-xs text-igbo-green font-bold uppercase mb-3">Key Words in This Story</p>
          {story.igboWords.map((w, i) => (
            <div key={i} className="flex items-center gap-3">
              {w.emoji && <span>{w.emoji}</span>}
              <div className="flex-1">
                <span className="font-bold text-igbo-green text-sm">{w.igbo}</span>
                <span className="text-white/40 text-xs ml-2">— {w.english}</span>
              </div>
              <button onClick={() => speak(w.igbo)} className="text-igbo-green hover:opacity-70">🔊</button>
            </div>
          ))}
        </div>
      )}

      {mode === 'paginated' ? (
        <div>
          <div className="flex justify-center gap-1 mb-4">
            {story.paragraphs.map((_, i) => (
              <div key={i} className={`h-1.5 rounded-full transition-all ${i === pageIndex ? 'w-6 bg-igbo-green' : 'w-1.5 bg-white/20'}`} />
            ))}
          </div>
          <div className="card min-h-[200px] flex flex-col justify-between">
            <p style={{ fontSize }} className="text-white/90 leading-relaxed">
              {story.paragraphs[pageIndex]}
            </p>
            {pageIndex === story.paragraphs.length - 1 && (
              <div className="mt-4 p-3 bg-igbo-green/10 rounded-xl border border-igbo-green/20">
                <p className="text-xs text-igbo-green font-bold mb-1">🌿 Moral</p>
                <p className="text-white/70 text-sm italic">{story.moralLesson}</p>
              </div>
            )}
          </div>
          <div className="flex gap-3 mt-4">
            <button onClick={() => setPageIndex(i => Math.max(0, i - 1))} disabled={pageIndex === 0}
              className="btn-ghost flex-1 disabled:opacity-30">← Prev</button>
            <button onClick={() => readAloud(story.paragraphs[pageIndex])}
              className={`p-3 rounded-xl transition ${speaking ? 'bg-igbo-green text-white' : 'bg-white/10 text-igbo-green hover:bg-white/20'}`}>
              🔊
            </button>
            <button onClick={() => setPageIndex(i => Math.min(story.paragraphs.length - 1, i + 1))}
              disabled={pageIndex === story.paragraphs.length - 1} className="btn-primary flex-1 disabled:opacity-30">
              Next →
            </button>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          <button onClick={() => readAloud(story.paragraphs.join(' '))}
            className={`btn-primary w-full ${speaking ? 'opacity-70' : ''}`}>
            {speaking ? '🔊 Reading…' : '🔊 Read Full Story Aloud'}
          </button>
          {story.paragraphs.map((p, i) => (
            <p key={i} style={{ fontSize }} className="text-white/90 leading-relaxed card">{p}</p>
          ))}
          <div className="card bg-igbo-green/10 border-igbo-green/20">
            <p className="text-xs text-igbo-green font-bold mb-1">🌿 Moral</p>
            <p className="text-white/70 italic">{story.moralLesson}</p>
          </div>
        </div>
      )}
    </div>
  )
}

function ProverbsList() {
  const [search, setSearch] = useState('')
  const [expanded, setExpanded] = useState(null)
  const today = todaysProverb()
  const filtered = PROVERBS.filter(p =>
    !search || p.igbo.toLowerCase().includes(search.toLowerCase()) || p.english.toLowerCase().includes(search.toLowerCase())
  )
  return (
    <div>
      <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Search proverbs…"
        className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white placeholder:text-white/30 mb-4 outline-none focus:border-igbo-green/50" />
      <p className="text-white/30 text-xs mb-3">{filtered.length} proverbs</p>
      <div className="space-y-2">
        {filtered.map((p, i) => (
          <div key={i} className={`card cursor-pointer hover:border-igbo-green/20 transition ${p === today ? 'border-igbo-gold/40' : ''}`}
            onClick={() => setExpanded(expanded === i ? null : i)}>
            {p === today && <span className="text-xs text-igbo-gold font-bold mb-1 block">⭐ Today's Proverb</span>}
            <div className="flex justify-between items-start gap-3">
              <div className="flex-1">
                <p className="font-bold text-igbo-green italic text-sm">"{p.igbo}"</p>
                <p className="text-white/50 text-xs mt-0.5">"{p.english}"</p>
              </div>
              <button onClick={e => { e.stopPropagation(); speak(p.igbo) }} className="text-igbo-green hover:opacity-70 flex-shrink-0">🔊</button>
            </div>
            {expanded === i && <p className="text-white/70 text-sm mt-3 leading-relaxed">{p.meaning}</p>}
          </div>
        ))}
      </div>
    </div>
  )
}
