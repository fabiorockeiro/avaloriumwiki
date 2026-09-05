(() => {
    document.querySelectorAll('.dv-image-link').forEach(link => {
        link.addEventListener('click', event => {
            if (document.querySelector('.image-lightbox')) event.preventDefault();
        });
    });
    const tiers = [...document.querySelectorAll('.dv-tier')];
    const toggle = document.querySelector('[data-dv-expand]');
    if (!toggle || !tiers.length) return;
    toggle.hidden = false;
    const sync = () => {
        toggle.textContent = tiers.every(tier => tier.open)
            ? 'Recolher todas as faixas' : 'Expandir todas as faixas';
    };
    toggle.addEventListener('click', () => {
        const open = !tiers.every(tier => tier.open);
        tiers.forEach(tier => { tier.open = open; });
        sync();
    });
    tiers.forEach(tier => tier.addEventListener('toggle', sync));
    const openHash = () => {
        const tier = tiers.find(item => `#${item.id}` === location.hash);
        if (tier) tier.open = true;
    };
    document.querySelectorAll('.dv-costs a').forEach(link => {
        link.addEventListener('click', () => {
            const tier = tiers.find(item => `#${item.id}` === link.hash);
            if (tier) tier.open = true;
        });
    });
    window.addEventListener('hashchange', openHash);
    openHash();
})();
