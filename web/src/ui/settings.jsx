import { useState } from 'preact/hooks'
import { DAYS, DAY_LETTERS } from '../lib/week.js'
import { FREQ_OPTIONS } from '../lib/generator.js'
import { CATEGORY_LABELS } from '../lib/catalog.js'
import { updateSettings } from '../actions.js'
import { store, syncEnabled } from '../lib/store.js'
import { Segmented, Sheet, Stepper } from './common.jsx'

const STATUS = {
  local: 'Nur auf diesem Gerät (Supabase nicht eingerichtet)',
  connecting: 'Verbinde…',
  online: 'Synchronisiert',
  offline: 'Offline – Änderungen werden später übertragen',
  error: 'Fehler beim Synchronisieren – wird wiederholt',
}

export function SettingsSheet({ app, onClose }) {
  const s = app.settings
  const [pantry, setPantry] = useState(s.pantry)

  return (
    <Sheet title="Einstellungen" onClose={() => {
      if (pantry !== s.pantry) updateSettings({ pantry })
      onClose()
    }}>
      <div class="form-head caption">Tage</div>
      <div class="form-section">
        <div class="form-row">
          <span>Kochen</span>
          <div style={{ display: 'flex', gap: '4px' }}>
            {DAY_LETTERS.map((l, i) => (
              <button
                key={i}
                class={`day-toggle ${s.days[i] ? 'on' : ''}`}
                style={{ width: '30px', height: '30px', borderRadius: '50%' }}
                aria-pressed={s.days[i]}
                aria-label={DAYS[i]}
                onClick={() => {
                  const days = [...s.days]
                  days[i] = !days[i]
                  updateSettings({ days })
                }}
              >
                {l}
              </button>
            ))}
          </div>
        </div>
        <div class="form-row">
          <span>Portionen</span>
          <Stepper value={s.portions} min={1} max={20} onChange={(portions) => updateSettings({ portions })} />
        </div>
      </div>
      <div class="form-foot">Die Zutaten auf der Einkaufsliste werden auf diese Portionen umgerechnet.</div>

      <div class="form-head caption">Rezeptgenerierung</div>
      <div class="form-section">
        {Object.keys(s.freq).map((cat) => (
          <div class="form-row" key={cat}>
            <span>{CATEGORY_LABELS[cat]}</span>
            <Segmented options={FREQ_OPTIONS} value={s.freq[cat]} onChange={(v) => updateSettings({ freq: { [cat]: v } })} />
          </div>
        ))}
      </div>

      <div class="form-head caption">Ernährungsweise</div>
      <div class="form-section">
        <div class="form-row">
          <span>Essen</span>
          <Segmented
            options={['alles', 'vegetarisch', 'vegan']}
            labels={{ alles: 'alles', vegetarisch: 'veggie', vegan: 'vegan' }}
            value={s.diet}
            onChange={(diet) => updateSettings({ diet })}
          />
        </div>
        {s.diet === 'alles' && (
          <div class="form-row">
            <span>Fleisch & Fisch</span>
            <Segmented options={FREQ_OPTIONS} value={s.meat} onChange={(meat) => updateSettings({ meat })} />
          </div>
        )}
      </div>
      {s.diet === 'alles' && (
        <div class="form-foot">selten = 1×, mittel = 2×, häufig = 4× pro Woche.</div>
      )}

      <div class="form-head caption">Abwechslung</div>
      <div class="form-section">
        <div class="form-row">
          <span>Nicht wiederholen für</span>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <Stepper value={s.noRepeatWeeks} min={0} max={8} onChange={(noRepeatWeeks) => updateSettings({ noRepeatWeeks })} />
            <span class="muted small">Wo.</span>
          </div>
        </div>
      </div>
      <div class="form-foot">
        Rezepte aus den letzten Wochen werden übersprungen, solange genug andere da sind. Upvotes machen ein Rezept
        wahrscheinlicher, Downvotes seltener.
      </div>

      <div class="form-head caption">Vorrat</div>
      <div class="form-section">
        <div class="form-row stack">
          <textarea
            class="input"
            rows={2}
            value={pantry}
            onInput={(e) => setPantry(e.currentTarget.value)}
            onBlur={() => pantry !== s.pantry && updateSettings({ pantry })}
          />
        </div>
      </div>
      <div class="form-foot">Diese Zutaten habt ihr immer da – sie kommen nicht auf die Einkaufsliste (mit Komma trennen).</div>

      <div class="form-head caption">Synchronisierung</div>
      <div class="form-section">
        <div class="form-row">
          <span>
            <span class={`status-dot ${app.status}`} />
            {STATUS[app.status]}
          </span>
        </div>
        {syncEnabled && app.session && (
          <div class="form-row">
            <span class="muted small">{app.session.user?.email}</span>
            <button class="btn small" onClick={() => store.signOut()}>
              Abmelden
            </button>
          </div>
        )}
      </div>
      <div class="form-foot" style={{ paddingBottom: '8px' }}>
        Wochenplan, Bewertungen, Einstellungen und Einkaufsliste sind auf allen angemeldeten Handys gleich.
      </div>
    </Sheet>
  )
}
