import { NavLink } from 'react-router-dom'
import { useApp } from '../../store/appStore'

const links = [
  { to: '/',        label: 'Translate', icon: '🌐' },
  { to: '/learn',   label: 'Learn',     icon: '📚' },
  { to: '/culture', label: 'Culture',   icon: '🎭' },
  { to: '/saved',   label: 'Saved',     icon: '🔖' },
]

export default function Nav() {
  const { dueWords } = useApp()

  return (
    <>
      <a href="#main-content" className="sr-only focus:not-sr-only focus:fixed focus:top-3 focus:left-3 focus:z-50 focus:bg-igbo-green focus:text-white focus:px-4 focus:py-2 focus:rounded-lg">Skip to content</a>
      {/* Desktop sidebar */}
      <nav className="hidden md:flex flex-col w-56 min-h-screen bg-igbo-card border-r border-white/5 px-4 py-8 gap-1 fixed top-0 left-0 z-30">
        <div className="mb-8 px-2">
          <h1 className="text-xl font-black text-igbo-green">Igbolingo</h1>
          <p className="text-xs text-white/40 mt-0.5">Learn Igbo Language</p>
        </div>
        {links.map(({ to, label, icon }) => (
          <NavLink key={to} to={to} end={to === '/'}
            className={({ isActive }) =>
              `flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition
               ${isActive ? 'bg-igbo-green text-white' : 'text-white/60 hover:bg-white/5 hover:text-white'}`
            }>
            <span className="text-lg">{icon}</span>
            {label}
            {label === 'Saved' && dueWords.length > 0 && (
              <span className="ml-auto bg-igbo-green text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                {dueWords.length}
              </span>
            )}
          </NavLink>
        ))}
      </nav>

      {/* Mobile bottom bar — pb-safe keeps it above the iOS home indicator */}
      <nav aria-label="Main navigation" className="md:hidden fixed bottom-0 left-0 right-0 bg-igbo-card/95 backdrop-blur border-t border-white/10 z-30 flex"
        style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}>
        {links.map(({ to, label, icon }) => (
          <NavLink key={to} to={to} end={to === '/'}
            className={({ isActive }) =>
              `flex-1 min-w-0 flex flex-col items-center gap-0.5 py-3 text-xs font-semibold transition
               ${isActive ? 'text-igbo-green' : 'text-white/40'}`
            }>
            <span className="text-xl relative">
              {icon}
              {label === 'Saved' && dueWords.length > 0 && (
                <span className="absolute -top-1 -right-1 bg-igbo-green text-white text-[9px] rounded-full w-3.5 h-3.5 flex items-center justify-center">
                  {dueWords.length}
                </span>
              )}
            </span>
            {label}
          </NavLink>
        ))}
      </nav>
    </>
  )
}
