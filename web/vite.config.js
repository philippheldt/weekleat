import { defineConfig } from 'vite'
import preact from '@preact/preset-vite'

export default defineConfig({
  // relative Pfade: läuft unter jeder Adresse (GitHub Pages, Netlify, Vercel …)
  base: './',
  plugins: [preact()],
  test: { include: ['test/**/*.test.js'] },
})
