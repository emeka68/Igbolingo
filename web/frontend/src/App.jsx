import { Routes, Route } from 'react-router-dom'
import { AppProvider } from './store/appStore'
import Nav from './components/layout/Nav'
import Translator from './pages/Translator'
import Learn from './pages/Learn'
import Culture from './pages/Culture'
import Saved from './pages/Saved'

export default function App() {
  return (
    <AppProvider>
      <div className="min-h-screen bg-igbo-dark">
        <Nav />
        {/* Desktop: offset for sidebar; mobile: pad bottom for tab bar */}
        <main className="md:ml-56 px-4 py-6 pb-24 md:pb-8 max-w-4xl">
          <Routes>
            <Route path="/"        element={<Translator />} />
            <Route path="/learn"   element={<Learn />} />
            <Route path="/culture" element={<Culture />} />
            <Route path="/saved"   element={<Saved />} />
          </Routes>
        </main>
      </div>
    </AppProvider>
  )
}
