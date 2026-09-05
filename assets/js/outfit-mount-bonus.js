(() => {
    const categories = [...document.querySelectorAll('.om-category')];
    const openHash = () => {
        const category = categories.find(item => `#${item.id}` === location.hash);
        if (category) category.open = true;
    };
    document.querySelectorAll('.om-category-nav a').forEach(link => {
        link.addEventListener('click', () => {
            const category = categories.find(item => `#${item.id}` === link.hash);
            if (category) category.open = true;
        });
    });
    window.addEventListener('hashchange', openHash);
    openHash();
    const button = document.querySelector('[data-copy-outfit-command]');
    const status = document.querySelector('[data-copy-status]');
    button?.addEventListener('click', async () => {
        try {
            await navigator.clipboard.writeText('!outfitbonus');
            status.textContent = 'Comando copiado!';
        } catch {
            status.textContent = 'Selecione e copie o comando acima.';
        }
    });
})();
