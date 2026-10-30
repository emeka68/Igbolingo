import { Routes, Route } from 'react-router-dom'
import { AppProvider } from './store/appStore'
import Nav from './components/layout/Nav'
import Translator from './pages/Translator'
import Learn from './pages/Learn'
import Culture from './pages/Culture'
import Saved from './pages/Saved'
import Games from './pages/Games'

export default function App() {
  return (
    <AppProvider>
      <div className="min-h-screen bg-igbo-dark">
        <Nav />
        {/* Desktop: offset for sidebar; mobile: pad bottom for tab bar */}
        <main id="main-content" className="md:ml-56 px-4 sm:px-6 py-8 pb-28 md:py-10 md:pb-12 max-w-5xl mx-auto">
          <Routes>
            <Route path="/"        element={<Translator />} />
            <Route path="/learn"   element={<Learn />} />
            <Route path="/culture" element={<Culture />} />
            <Route path="/saved"   element={<Saved />} />
            <Route path="/games"   element={<Games />} />
          </Routes>
        </main>
      </div>
    </AppProvider>
  )
}
