(() => {
    const families = [...document.querySelectorAll('.ac-family')];
    const openHash = () => {
        const family = families.find(item => `#${item.id}` === location.hash);
        if (family) family.open = true;
    };
    document.querySelectorAll('.ac-family-nav a').forEach(link => {
        link.addEventListener('click', () => {
            const family = families.find(item => `#${item.id}` === link.hash);
            if (family) family.open = true;
        });
    });
    window.addEventListener('hashchange', openHash);
    openHash();
})();
