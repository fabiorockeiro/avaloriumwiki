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

    const scriptsZeroBotPages = new Set([
        'category-scripts-zerobot.html',
        'fabio-rockeiro-scripts.html',
    ]);

    const huntsCustomPages = new Set([
        'hunts-custom.html',
    ]);

    function getCurrentPage() {
        const page = window.location.pathname.split('/').pop();
        return (page || 'index.html').toLowerCase();
    }

    function getScriptsZeroBotMenu() {
        const currentPage = getCurrentPage();
        const isOpen = scriptsZeroBotPages.has(currentPage);
        const isActive = currentPage === 'fabio-rockeiro-scripts.html';

        return `
            <section class="menu-section ${isOpen ? 'is-open' : ''}" data-scripts-zerobot-menu>
                <button type="button" class="menu-section-button" data-section-toggle>
                    <span><svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="m16 18 6-6-6-6"/><path d="m8 6-6 6 6 6"/><path d="m13 4-2 16"/></svg></span>
                    <strong>Scripts Zerobot</strong>
                    <small>1</small>
                </button>
                <div class="menu-links">
                    <a class="${isActive ? 'active' : ''}" href="fabio-rockeiro-scripts.html">
                        <img src="assets/media/scripts-zerobot/fabio-rockeiro-bot-icon.png" alt="" loading="lazy">
                        <span>
                            <strong>Fábio Rockeiro Scripts</strong>
                            <small>Task Book, refils e Auto Forja para ZeroBot.</small>
                        </span>
                    </a>
                </div>
            </section>
        `;
    }

    function injectScriptsZeroBotMenu() {
        document.querySelectorAll('.drawer-menu, .sidebar-sticky').forEach((container) => {
            if (container.querySelector('[data-scripts-zerobot-menu]')) return;
            container.insertAdjacentHTML('beforeend', getScriptsZeroBotMenu());
        });

        document.querySelectorAll('.sidebar-title small').forEach((counter) => {
            if (counter.dataset.scriptsZeroBotCounted) return;
            counter.dataset.scriptsZeroBotCounted = 'true';
            counter.textContent = counter.textContent.replace(/\d+/, (value) => String(Number(value) + 1));
        });
    }

    injectScriptsZeroBotMenu();

    function getHuntsCustomMenuItem() {
        const currentPage = getCurrentPage();
        const isActive = currentPage === 'hunts-custom.html';

        return `
            <a class="${isActive ? 'active' : ''}" href="hunts-custom.html" data-hunts-custom-link>
                <img src="assets/media/menu/hunts-custom.gif" alt="" loading="lazy">
                <span>
                    <strong>Hunts Custom</strong>
                    <small>Nightmare, Hazard, Tasks, Void e boss especial.</small>
                </span>
            </a>
        `;
    }

    function injectHuntsCustomMenu() {
        const currentPage = getCurrentPage();
        const isOpen = huntsCustomPages.has(currentPage);

        document.querySelectorAll('.menu-section').forEach((section) => {
            const sectionTitle = section.querySelector('.menu-section-button strong');
            const links = section.querySelector('.menu-links');
            if (!sectionTitle || !links || sectionTitle.textContent.trim() !== 'Guias e Utilidades') return;

            if (!links.querySelector('[data-hunts-custom-link]')) {
                links.insertAdjacentHTML('beforeend', getHuntsCustomMenuItem());
            }

            if (isOpen) section.classList.add('is-open');

            if (section.dataset.huntsCustomCounted) return;
            section.dataset.huntsCustomCounted = 'true';
            const counter = section.querySelector('.menu-section-button small');
            if (counter) {
                counter.textContent = counter.textContent.replace(/\d+/, (value) => String(Number(value) + 1));
            }
        });

        document.querySelectorAll('.sidebar-title small').forEach((counter) => {
            if (counter.dataset.huntsCustomCounted) return;
            counter.dataset.huntsCustomCounted = 'true';
            counter.textContent = counter.textContent.replace(/\d+/, (value) => String(Number(value) + 1));
        });
    }

    injectHuntsCustomMenu();

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

    document.querySelectorAll('[data-carousel]').forEach((carousel) => {
        const track = carousel.querySelector('[data-carousel-track]');
        const slides = track ? Array.from(track.children) : [];
        const previousButton = carousel.querySelector('[data-carousel-prev]');
        const nextButton = carousel.querySelector('[data-carousel-next]');
        const dots = Array.from(carousel.querySelectorAll('[data-carousel-dot]'));
        let currentIndex = 0;

        if (!track || slides.length === 0) return;

        track.style.width = `${slides.length * 100}%`;
        slides.forEach((slide) => {
            const slideWidth = `${100 / slides.length}%`;
            slide.style.flexBasis = slideWidth;
            slide.style.width = slideWidth;
        });

        function showSlide(index) {
            currentIndex = (index + slides.length) % slides.length;
            track.style.transform = `translateX(-${currentIndex * (100 / slides.length)}%)`;

            slides.forEach((slide, slideIndex) => {
                slide.setAttribute('aria-hidden', slideIndex === currentIndex ? 'false' : 'true');
            });

            dots.forEach((dot, dotIndex) => {
                const isActive = dotIndex === currentIndex;
                dot.classList.toggle('is-active', isActive);
                dot.setAttribute('aria-current', isActive ? 'true' : 'false');
            });
        }

        previousButton?.addEventListener('click', () => showSlide(currentIndex - 1));
        nextButton?.addEventListener('click', () => showSlide(currentIndex + 1));

        dots.forEach((dot, dotIndex) => {
            dot.addEventListener('click', () => showSlide(dotIndex));
        });

        carousel.addEventListener('keydown', (event) => {
            if (event.key === 'ArrowLeft') {
                event.preventDefault();
                showSlide(currentIndex - 1);
            }

            if (event.key === 'ArrowRight') {
                event.preventDefault();
                showSlide(currentIndex + 1);
            }
        });

        showSlide(0);
    });
})();
