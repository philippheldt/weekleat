import { useState } from 'preact/hooks'
import { formatAmount } from '../lib/ingredients.js'
import { chooseImage } from '../lib/images.js'
import { addShoppingItem, clearBought, removeShopping, toggleShopping } from '../actions.js'
import { BackLink, FoodImage, Icon, NavBar, Svg, Tag } from './common.jsx'

function Item({ item }) {
  const amount = formatAmount(item.amount, item.unit)
  return (
    <div class={`shop-item ${item.checked ? 'done' : ''}`}>
      <button
        style={{ display: 'flex', alignItems: 'center', flex: 1, minWidth: 0, textAlign: 'left' }}
        onClick={() => {
          navigator.vibrate?.(8)
          toggleShopping(item)
        }}
        aria-pressed={item.checked}
        aria-label={`${item.name}${amount ? ', ' + amount : ''}`}
      >
        <FoodImage name={chooseImage(item.name)} />
        <div class="card-body">
          <div class="shop-name">{item.name}</div>
          <div class="tags">
            {amount && <Tag icon="portion-black">{amount}</Tag>}
            {item.manual ? (
              <span class="muted small">eigener Eintrag</span>
            ) : (
              <span class="muted small" style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                {(item.recipes || []).join(', ')}
              </span>
            )}
          </div>
        </div>
        <span class="check">{item.checked && <Svg name="check" size={16} />}</span>
      </button>
      {item.manual && (
        <button class="del-btn" aria-label={`${item.name} löschen`} onClick={() => removeShopping(item.id)}>
          <Icon name="bin-black" class="icon-sm" />
        </button>
      )}
    </div>
  )
}

export function ShoppingView({ app }) {
  const [text, setText] = useState('')
  const sortFn = (a, b) => (a.manual === b.manual ? a.name.localeCompare(b.name, 'de') : a.manual ? -1 : 1)
  const open = app.shopping.filter((x) => !x.checked).sort(sortFn)
  const done = app.shopping.filter((x) => x.checked).sort(sortFn)

  const submit = (e) => {
    e.preventDefault()
    addShoppingItem(text)
    setText('')
  }

  return (
    <>
      <NavBar left={<BackLink />} title="Einkaufsliste" sub={`${open.length} offen`} />
      <form class="add-row" onSubmit={submit}>
        <input
          class="input"
          placeholder="Etwas hinzufügen, z. B. 1 l Milch"
          value={text}
          onInput={(e) => setText(e.currentTarget.value)}
          enterkeyhint="done"
        />
        <button class="btn primary square" aria-label="Hinzufügen" disabled={!text.trim()}>
          <Svg name="plus" />
        </button>
      </form>

      <div class="section-head caption">Offen</div>
      {open.length ? (
        open.map((item) => <Item key={item.id} item={item} />)
      ) : (
        <p class="muted" style={{ padding: '0 16px', margin: 0 }}>
          {app.shopping.length ? 'Alles eingekauft 🎉' : 'Noch leer – generiere einen Wochenplan oder füge etwas hinzu.'}
        </p>
      )}

      {done.length > 0 && (
        <>
          <div class="section-head caption" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <span>Gekauft</span>
            {done.some((x) => x.manual) && (
              <button class="caption" style={{ color: 'var(--fg)' }} onClick={clearBought}>
                Eigene entfernen
              </button>
            )}
          </div>
          {done.map((item) => (
            <Item key={item.id} item={item} />
          ))}
        </>
      )}
    </>
  )
}
