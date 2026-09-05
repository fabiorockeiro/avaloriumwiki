(() => {
    const picker = document.querySelector('.us-picker');
    const target = document.querySelector('#upgrade-target');
    const result = document.querySelector('#upgrade-result');
    if (!picker || !target || !result) return;
    const rows = [...document.querySelectorAll('.us-table [data-target]')];
    function update() {
        rows.forEach(row => row.classList.toggle('is-selected', row.dataset.target === target.value));
        const row = rows.find(row => row.dataset.target === target.value);
        result.textContent = [...row.querySelectorAll('[data-stone]')].map(cell =>
            `Lvl ${cell.dataset.stone}: ${cell.dataset.chance ? `${cell.dataset.chance}%` : 'fora do limite'}`
        ).join(' · ');
    }
    target.addEventListener('change', update);
    update();
    picker.hidden = false;
})();
