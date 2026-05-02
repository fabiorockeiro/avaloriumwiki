(function () {
    const drawer = document.querySelector('[data-drawer]');
    const backdrop = document.querySelector('[data-drawer-close].drawer-backdrop');
    const openButtons = document.querySelectorAll('[data-drawer-open]');
    const closeButtons = document.querySelectorAll('[data-drawer-close]');

    function setDrawer(open) {
        if (!drawer || !backdrop) return;
        drawer.classList.toggle('is-open', open);
        drawer.setAttribute('aria-hidden', open ? 'false' : 'true');
        backdrop.hidden = !open;
        document.body.style.overflow = open ? 'hidden' : '';
    }

    openButtons.forEach((button) => {
        button.addEventListener('click', () => setDrawer(true));
    });

    closeButtons.forEach((button) => {
        button.addEventListener('click', () => setDrawer(false));
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') setDrawer(false);
    });

    document.querySelectorAll('[data-section-toggle]').forEach((button) => {
        button.addEventListener('click', () => {
            const section = button.closest('.menu-section');
            if (section) section.classList.toggle('is-open');
        });
    });

    document.querySelectorAll('[data-filter-input]').forEach((input) => {
        const panel = input.closest('.tool-panel');
        const scope = panel ? panel.nextElementSibling : document.querySelector('[data-filter-scope]');
        if (!scope) return;

        input.addEventListener('input', () => {
            const query = input.value.trim().toLowerCase();
            scope.querySelectorAll('[data-filter-row]').forEach((row) => {
                const text = (row.getAttribute('data-filter-text') || row.textContent || '').toLowerCase();
                row.classList.toggle('is-hidden', query !== '' && !text.includes(query));
            });
        });
    });
})();
