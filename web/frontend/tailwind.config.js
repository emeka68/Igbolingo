/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        igbo: {
          green:  '#219057',
          gold:   '#E8B021',
          red:    '#C72E2E',
          dark:   '#0f1f17',
          card:   '#1a2e22',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      }
    }
  },
  plugins: []
}
