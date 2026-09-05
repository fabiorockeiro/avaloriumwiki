(() => {
    const tiers = [...document.querySelectorAll('.ts-tier')];
    const button = document.querySelector('[data-tasks-expand]');
    if (!button || !tiers.length) return;
    button.hidden = false;
    const sync = () => {
        button.textContent = tiers.every(tier => tier.open) ? 'Recolher todos os baús' : 'Expandir todos os baús';
    };
    button.addEventListener('click', () => {
        const open = !tiers.every(tier => tier.open);
        tiers.forEach(tier => { tier.open = open; });
        sync();
    });
    tiers.forEach(tier => tier.addEventListener('toggle', sync));
    const openHash = () => {
        const tier = tiers.find(tier => `#${tier.id}` === location.hash);
        if (tier) tier.open = true;
    };
    document.querySelectorAll('.ts-milestones a').forEach(link => {
        link.addEventListener('click', () => {
            const tier = tiers.find(tier => `#${tier.id}` === link.hash);
            if (tier) tier.open = true;
        });
    });
    window.addEventListener('hashchange', openHash);
    openHash();
})();
