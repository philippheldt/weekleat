export const DAYS = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag']
export const DAY_KEYS = ['mo', 'di', 'mi', 'do', 'fr', 'sa', 'so']
export const DAY_LETTERS = ['M', 'D', 'M', 'D', 'F', 'S', 'S']

/** 0 = Montag … 6 = Sonntag */
export function weekdayIndex(date = new Date()) {
  return (date.getDay() + 6) % 7
}

function isoDate(d) {
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

export function mondayOf(date = new Date()) {
  const d = new Date(date.getFullYear(), date.getMonth(), date.getDate())
  d.setDate(d.getDate() - weekdayIndex(d))
  return d
}

/**
 * Für welche Woche wird geplant? Ab Freitag gilt: nächste Woche.
 * @returns {string} Montag der Woche als YYYY-MM-DD
 */
export function upcomingWeek(date = new Date()) {
  const monday = mondayOf(date)
  if (weekdayIndex(date) >= 4) monday.setDate(monday.getDate() + 7)
  return isoDate(monday)
}

export function weeksBetween(a, b) {
  return Math.round((new Date(b) - new Date(a)) / (7 * 24 * 3600 * 1000))
}

export function dateOfDay(week, dayIndex) {
  const d = new Date(week + 'T00:00:00')
  d.setDate(d.getDate() + dayIndex)
  return d
}

export function formatShort(d) {
  return d.toLocaleDateString('de-DE', { day: 'numeric', month: 'long' })
}

export function weekLabel(week) {
  const start = dateOfDay(week, 0)
  const end = dateOfDay(week, 6)
  return `${start.toLocaleDateString('de-DE', { day: 'numeric', month: 'short' })} – ${end.toLocaleDateString('de-DE', { day: 'numeric', month: 'short' })}`
}

export function todayIso() {
  return isoDate(new Date())
}
