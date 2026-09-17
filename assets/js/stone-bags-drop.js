(function () {
    const section = document.getElementById('obter-stones');
    if (!section) return;
    const form = section.querySelector('.rs-drop-filters');
    const query = document.getElementById('rs-drop-query');
    const area = document.getElementById('rs-drop-area');
    const order = document.getElementById('rs-drop-order');
    const rows = Array.from(section.querySelectorAll('[data-drop-row]'));
    const normalize = (text) => text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLocaleLowerCase('pt-BR');
    const entries = rows.map((row) => ({ row, area: row.dataset.area, chance: Number(row.dataset.chance), monster: row.cells[0].textContent, search: normalize(row.textContent) }));
    const body = rows[0].parentElement;

    function render() {
        const term = normalize(query.value.trim());
        const visible = entries.filter((entry) => (!area.value || entry.area === area.value) && entry.search.includes(term));
        const included = new Set(visible);
        entries.forEach((entry) => { entry.row.hidden = !included.has(entry); });
        visible.sort((a, b) => {
            if (order.value === 'monster' || order.value === 'area') return a[order.value].localeCompare(b[order.value], 'pt-BR');
            return (a.chance - b.chance) * (order.value === 'chance-asc' ? 1 : -1) || a.monster.localeCompare(b.monster, 'pt-BR');
        });
        visible.forEach((entry) => body.appendChild(entry.row));
        document.getElementById('rs-drop-status').textContent = `${visible.length} de ${entries.length} criaturas · ${new Set(visible.map((entry) => entry.area)).size} de ${area.options.length - 1} hunts.`;
        document.getElementById('rs-drop-empty').hidden = visible.length > 0;
    }
    query.addEventListener('input', render);
    area.addEventListener('change', render);
    order.addEventListener('change', render);
    form.addEventListener('submit', (event) => event.preventDefault());
    form.addEventListener('reset', () => { setTimeout(render, 0); });
    render();
})();
