import { useEffect, useRef, useState } from 'preact/hooks'
import { chooseImage, hasLarge, imageBg, imageUrl } from '../lib/images.js'
import { CATEGORY_LABELS, DIET_LABELS } from '../lib/catalog.js'

const BASE = import.meta.env.BASE_URL

/** PNG-Icon aus der iOS-App (wird im Dark Mode invertiert) */
export function Icon({ name, class: cls = '' }) {
  return <img class={`icon ${cls}`} src={`${BASE}img/icons/${name}.png`} alt="" aria-hidden="true" />
}

const PATHS = {
  lock: 'M7 11V8a5 5 0 0 1 10 0v3M6 11h12v9H6z',
  unlock: 'M7 11V8a5 5 0 0 1 9.6-2M6 11h12v9H6z',
  up: 'M7 10v10H4V10zM7 10l4-7c1.5 0 2.5 1 2.2 2.6L12.6 9H19a2 2 0 0 1 2 2.3l-1.2 7A2 2 0 0 1 17.8 20H7',
  down: 'M7 14V4H4v10zM7 14l4 7c1.5 0 2.5-1 2.2-2.6L12.6 15H19a2 2 0 0 0 2-2.3l-1.2-7A2 2 0 0 0 17.8 4H7',
  more: 'M12 19V5M5 12l7-7 7 7',
  less: 'M12 5v14M5 12l7 7 7-7',
  pin: 'M9 3h6M10 3v6l-3 4h10l-3-4V3M12 13v8',
  pencil: 'M4 20h4L19 9l-4-4L4 16zM14 6l4 4',
  refresh: 'M20 12a8 8 0 1 1-2.3-5.7M20 4v5h-5',
  plus: 'M12 5v14M5 12h14',
  check: 'M5 12.5l4.5 4.5L19 7',
  x: 'M6 6l12 12M18 6L6 18',
  swap: 'M7 7h12l-3-3M17 17H5l3 3',
  link: 'M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1',
  cloud: 'M7 18h10a4 4 0 0 0 .5-8A6 6 0 0 0 6 9.5 4.3 4.3 0 0 0 7 18z',
}

export function Svg({ name, size = 20, class: cls = '' }) {
  return (
    <svg class={`svg-icon ${cls}`} width={size} height={size} viewBox="0 0 24 24" aria-hidden="true">
      <path d={PATHS[name]} />
    </svg>
  )
}

export function Chevron() {
  return (
    <svg class="chevron" viewBox="0 0 14 14" aria-hidden="true">
      <path d="M5 2l5 5-5 5" />
    </svg>
  )
}

export function Tag({ icon, children, class: cls = '' }) {
  return (
    <span class={`tag ${cls}`}>
      {icon && <Icon name={icon} />}
      {children}
    </span>
  )
}

export function RecipeTags({ recipe, score, portions }) {
  return (
    <div class="tags">
      <Tag icon="portion-black">{portions ?? recipe.portions}</Tag>
      {recipe.category !== 'sonstiges' && <Tag icon="rice-black">{CATEGORY_LABELS[recipe.category]}</Tag>}
      <Tag>{DIET_LABELS[recipe.diet]}</Tag>
      {recipe.source && <Tag>{recipe.source}</Tag>}
      {recipe.tags.slice(0, 1).map((t) => (
        <Tag key={t}>{t}</Tag>
      ))}
      {score > 0 && <Tag class="up">▲ {score}</Tag>}
      {score < 0 && <Tag class="down">▼ {Math.abs(score)}</Tag>}
    </div>
  )
}

export function FoodImage({ name, class: cls = 'card-img' }) {
  return (
    <img class={cls} src={imageUrl(name)} alt="" loading="lazy" decoding="async" width="100" height="100" style={{ background: imageBg(name) }} />
  )
}

export function Banner({ name, class: cls = 'banner' }) {
  if (hasLarge(name)) return <img class={cls} src={imageUrl(name, true)} alt="" style={{ background: imageBg(name) }} />
  return (
    <div class="banner-letter" style={{ background: imageBg(name) }}>
      <img src={imageUrl(name)} alt="" />
    </div>
  )
}

export function ingredientImage(name) {
  return chooseImage(name)
}

export function NavBar({ left, title, sub, right }) {
  return (
    <header class="nav">
      <div>{left}</div>
      <div class="nav-title">
        {title}
        {sub && <span class="nav-sub">{sub}</span>}
      </div>
      <div style={{ justifySelf: 'end' }}>{right}</div>
    </header>
  )
}

export function BackLink({ label = 'Wochenplan' }) {
  return (
    <a class="nav-back" href="#/" aria-label="Zurück">
      <Icon name="arrow-left-black" />
    </a>
  )
}

export function Sheet({ title, onClose, children, action }) {
  const ref = useRef()
  useEffect(() => {
    const onKey = (e) => e.key === 'Escape' && onClose()
    document.addEventListener('keydown', onKey)
    const prev = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    return () => {
      document.removeEventListener('keydown', onKey)
      document.body.style.overflow = prev
    }
  }, [])
  return (
    <div class="overlay" onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div class="sheet" ref={ref} role="dialog" aria-modal="true" aria-label={title}>
        <div class="sheet-grip" />
        <div class="sheet-head">
          {title ? <h2>{title}</h2> : <span />}
          {action ?? (
            <button class="close-btn" onClick={onClose} aria-label="Schließen">
              <Svg name="x" size={18} />
            </button>
          )}
        </div>
        {children}
      </div>
    </div>
  )
}

export function Segmented({ options, value, onChange, labels = {} }) {
  return (
    <div class="segmented" role="radiogroup">
      {options.map((o) => (
        <button key={o} role="radio" aria-checked={value === o} class={value === o ? 'on' : ''} onClick={() => onChange(o)}>
          {labels[o] ?? o}
        </button>
      ))}
    </div>
  )
}

export function Stepper({ value, min, max, onChange }) {
  return (
    <div class="stepper">
      <button aria-label="weniger" disabled={value <= min} onClick={() => onChange(Math.max(min, value - 1))}>
        −
      </button>
      <span>{value}</span>
      <button aria-label="mehr" disabled={value >= max} onClick={() => onChange(Math.min(max, value + 1))}>
        +
      </button>
    </div>
  )
}

let toastSetter = null
export function toast(msg) {
  toastSetter?.(msg)
}
export function Toast() {
  const [msg, setMsg] = useState('')
  useEffect(() => {
    toastSetter = setMsg
  }, [])
  useEffect(() => {
    if (!msg) return
    const t = setTimeout(() => setMsg(''), 3500)
    return () => clearTimeout(t)
  }, [msg])
  return msg ? (
    <div class="toast" role="status">
      {msg}
    </div>
  ) : null
}
