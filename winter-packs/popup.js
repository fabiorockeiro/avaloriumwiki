(() => {
  'use strict';
  if (window.AvaloriumPacks) return;
  const base = new URL('.', document.currentScript.src);
  const motion = matchMedia('(prefers-reduced-motion: reduce)');
  const font = new FontFace('AvaloriumMedieval', `url(${new URL('assets/fonts/CinzelDecorative-Bold.ttf', base).href})`, { weight: '700' });
  font.load().then(loaded => document.fonts.add(loaded)).catch(() => {});
  const winterFont = new FontFace('AvaloriumWinter', `url(${new URL('assets/fonts/AlmendraSC-Regular.ttf', base).href})`, { weight: '400' });
  winterFont.load().then(loaded => document.fonts.add(loaded)).catch(() => {});
  const titleFont = new FontFace('AvaloriumTitle', `url(${new URL('assets/fonts/Cinzel-Variable.ttf', base).href})`, { weight: '700' });
  titleFont.load().then(loaded => document.fonts.add(loaded)).catch(() => {});
  let host, root, dialog, ready, previousFocus, scrollState;
  const number = value => value.toLocaleString('pt-BR');
  const asset = path => new URL(path, base).href;
  function element(tag, className, text) {
    const node = document.createElement(tag);
    if (className) node.className = className;
    if (text !== undefined) node.textContent = text;
    return node;
  }
  function icon(file, className = '') {
    const img = element('img', className);
    img.dataset.animated = asset('assets/items/' + file);
    img.dataset.still = asset('assets/items/' + file.replace(/\.gif$/, '.png'));
    img.src = img.dataset.still;
    img.alt = ''; img.width = 32; img.height = 32;
    return img;
  }
  function syncMotion() {
    if (!root) return;
    const animate = dialog.open && !motion.matches && !document.hidden;
    root.querySelectorAll('img[data-animated]').forEach(img => {
      const next = animate ? img.dataset.animated : img.dataset.still;
      if (img.src !== next) img.src = next;
    });
    dialog.classList.toggle('paused', !animate);
  }
  function initialize() {
    if (ready) return ready;
    const data = window.AvaloriumPacksData;
    if (!data) throw new Error('Carregue packs-data.js antes de popup.js.');
    host = element('avalorium-winter-packs');
    root = host.attachShadow({ mode: 'open' });
    const css = element('link'); css.rel = 'stylesheet'; css.href = asset('popup.css');
    ready = new Promise((resolve, reject) => {
      css.onload = resolve;
      css.onerror = () => { ready = null; host.remove(); reject(new Error('Não foi possível carregar popup.css.')); };
    });
    root.append(css);
    dialog = element('dialog');
    dialog.setAttribute('aria-labelledby', 'av-title');
    dialog.setAttribute('aria-describedby', 'av-description');
    dialog.innerHTML = `<div class="surface"><div class="snow" aria-hidden="true"></div>
      <svg class="filter-definitions" width="0" height="0" aria-hidden="true"><defs>
        <filter id="av-remove-white" color-interpolation-filters="sRGB" x="0" y="0" width="100%" height="100%">
          <feColorMatrix in="SourceGraphic" type="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  -8 -8 -8 0 22.8" result="key"/>
          <feComposite in="SourceGraphic" in2="key" operator="in"/>
        </filter>
      </defs></svg>
      <button class="close" type="button" aria-label="Fechar pacotes">×</button>
      <header class="heading"><img class="logo" alt="Avalorium OT" width="124" height="124"><div class="title-row"><h1 id="av-title">PACOTES AVALORIUM</h1></div><p id="av-description">APOIE O SERVIDOR E RECEBA RECOMPENSAS EXCLUSIVAS</p></header>
      <nav class="pack-nav" aria-label="Ir para pacote"></nav>
      <div class="cards" role="region" aria-label="Comparação dos seis pacotes" tabindex="0"></div>
    </div>`;
    dialog.querySelector('.logo').src = asset('assets/avalorium-logo.webp');
    root.append(dialog); document.body.append(host);
    const cards = root.querySelector('.cards');
    data.packs.forEach((pack, index) => {
      const card = element('a', 'card' + (pack.featured ? ' featured' : ''));
      card.href = data.donateUrl;
      card.id = 'pack-' + pack.id;
      card.style.setProperty('--accent', pack.color);
      card.style.setProperty('--phase', `${-index * 1.3}s`);
      card.setAttribute('aria-label', `${pack.name}, ${number(pack.tc)} TC, R$ ${number(pack.price)}. Ir para Donates`);
      const border = element('span', 'border-light'); border.setAttribute('aria-hidden', 'true');
      card.append(border);
      const title = element('h2', '', pack.name);
      const hero = element('div', 'artifact'); hero.setAttribute('aria-hidden', 'true');
      const chest = element('img', 'chest'); chest.src = asset('assets/chest.webp'); chest.alt = ''; chest.width = 160; chest.height = 160;
      hero.append(chest);
      const credits = element('div', 'credits');
      credits.append(icon('tibia-coins.gif', 'coin'), element('strong', '', number(pack.tc)), element('span', '', 'TC'));
      const rewards = element('ul', 'rewards');
      pack.rewards.forEach(([key, quantity]) => {
        const item = data.items[key];
        const row = element('li');
        const art = element('span', 'item-art' + (item.idleMotion ? ' idle-motion' : ''));
        art.append(icon(item.icon, item.removeWhite ? 'remove-white' : ''));
        if (item.extraIcon) { art.classList.add('paired'); art.append(icon(item.extraIcon)); }
        row.append(art, element('b', 'quantity', quantity + '×'), element('span', 'item-name', item.name));
        rewards.append(row);
      });
      const price = element('div', 'price');
      price.append(element('span', 'currency', 'R$'), element('strong', '', number(pack.price)));
      card.append(title, hero, credits, rewards, price);
      cards.append(card);
      const jump = element('button', '', pack.name); jump.type = 'button';
      jump.addEventListener('click', () => cards.scrollTo({ left: card.offsetLeft - cards.offsetLeft - 12, behavior: motion.matches ? 'instant' : 'smooth' }));
      root.querySelector('.pack-nav').append(jump);
    });
    root.querySelector('.close').addEventListener('click', close);
    dialog.addEventListener('cancel', event => { event.preventDefault(); close(); });
    dialog.addEventListener('keydown', event => {
      if (event.key !== 'Tab') return;
      const focusable = [...dialog.querySelectorAll('button, a[href], [tabindex="0"]')]
        .filter(node => !node.disabled && node.getClientRects().length);
      const first = focusable[0], last = focusable[focusable.length - 1];
      if (event.shiftKey && root.activeElement === first) { event.preventDefault(); last.focus(); }
      else if (!event.shiftKey && root.activeElement === last) { event.preventDefault(); first.focus(); }
    });
    let outside = false;
    dialog.addEventListener('pointerdown', event => { outside = event.target === dialog; });
    dialog.addEventListener('click', event => { if (outside && event.target === dialog) close(); outside = false; });
    dialog.addEventListener('close', restore);
    return ready;
  }
  function restore() {
    if (!scrollState || dialog.open) return;
    for (const [node, value, priority] of scrollState) {
      if (value) node.style.setProperty('overflow', value, priority);
      else node.style.removeProperty('overflow');
    }
    scrollState = null;
    syncMotion();
    if (previousFocus?.isConnected) previousFocus.focus({ preventScroll: true });
  }
  async function open() {
    await initialize();
    if (dialog.open) return;
    previousFocus = document.activeElement;
    scrollState = [document.documentElement, document.body].map(node => [node, node.style.getPropertyValue('overflow'), node.style.getPropertyPriority('overflow')]);
    dialog.showModal(); dialog.scrollTop = 0;
    for (const [node] of scrollState) node.style.setProperty('overflow', 'hidden', 'important');
    syncMotion();
    root.querySelector('.close').focus({ preventScroll: true });
  }
  function close() { if (dialog?.open) { dialog.close(); restore(); } }
  motion.addEventListener('change', syncMotion);
  document.addEventListener('visibilitychange', syncMotion);
  window.AvaloriumPacks = { open, close, get isOpen() { return !!dialog?.open; } };
})();
