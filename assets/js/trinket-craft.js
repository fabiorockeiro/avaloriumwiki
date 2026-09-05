(() => {
    const panels = [...document.querySelectorAll('.ct-vocation')];
    const openHash = () => {
        const panel = panels.find(item => `#${item.id}` === location.hash);
        if (panel) panel.open = true;
    };
    document.querySelectorAll('.ct-vocation-nav a').forEach(link => {
        link.addEventListener('click', () => {
            const panel = panels.find(item => `#${item.id}` === link.hash);
            if (panel) panel.open = true;
        });
    });
    window.addEventListener('hashchange', openHash);
    openHash();
})();
