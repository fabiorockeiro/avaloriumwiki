(() => {
    const controls = document.querySelector('.cv-filters');
    const cards = [...document.querySelectorAll('[data-craft-vocation]')];
    const count = document.querySelector('[data-craft-count]');
    if (!controls || !cards.length) return;
    controls.hidden = false;
    controls.querySelectorAll('[data-craft-filter]').forEach(button => {
        button.addEventListener('click', () => {
            const vocation = button.dataset.craftFilter;
            controls.querySelectorAll('button').forEach(item => item.setAttribute('aria-pressed', String(item === button)));
            cards.forEach(card => { card.hidden = vocation !== 'all' && card.dataset.craftVocation !== vocation; });
            const visible = cards.filter(card => !card.hidden).length;
            count.textContent = `${visible} ${visible === 1 ? 'item' : 'itens'}`;
        });
    });
})();
