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

    const huntsCustomMenuItems = [
        {
            url: 'void-corruption-depths-outer-void.html',
            title: 'Void Corruption Depths (Outer Void)',
            description: 'Level recomendado 1000 ~ 1200.',
            image: 'assets/media/hunts-custom/VOID CORRUPTION DEPTHS (OUTER VOID).png',
        },
        {
            url: 'void-corruption-depths-inner-netherbound.html',
            title: 'Void Corruption Depths (Inner Netherbound)',
            description: 'Level recomendado 1200 ~ 1400.',
            image: 'assets/media/hunts-custom/VOID CORRUPTION DEPTHS (INNER NETHERBOUND).png',
        },
        {
            url: 'sanctum-of-fire-ice.html',
            title: 'Sanctum of Fire &amp; Ice',
            description: 'Level recomendado 600+.',
            image: 'assets/media/hunts-custom/SANCTUM OF FIRE & ICE.png',
        },
        {
            url: 'pyramid-of-azhrkhal-three-asuras.html',
            title: 'Pyramid of Azhr\'Khal (Three Asuras)',
            description: 'Level recomendado 750+.',
            image: 'assets/media/hunts-custom/PYRAMID OF AZHR’KHAL (THREE ASURAS).png',
        },
        {
            url: 'the-fallen-usurpers.html',
            title: 'The Fallen Usurpers',
            description: 'Level recomendado 1600.',
            image: 'assets/media/hunts-custom/THE FALLEN USURPERS.png',
        },
    ];

    const baseMenuSections = [
        {
            title: 'Novidades e Loja',
            icon: '<svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 11v2a2 2 0 0 0 2 2h2l3 5h2l-2-5h2l8 3V6l-8 3H5a2 2 0 0 0-2 2Z"/><path d="M21 9v6"/></svg>',
            items: [
                {
                    url: 'noticias-e-promocoes.html',
                    title: 'Noticias, Promocoes e Pacotes Especiais',
                    description: 'Pacotes ativos e afiliados do Avalorium.',
                    image: 'assets/media/menu/noticias-e-promocoes.gif',
                },
            ],
        },
        {
            title: 'Sistemas do Servidor',
            icon: '<svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v6M12 16v6M2 12h6M16 12h6"/><path d="m5 5 4 4M15 15l4 4M19 5l-4 4M9 15l-4 4"/></svg>',
            items: [
                { url: 'divergence-system.html', title: 'Divergence System', description: 'Dungeon progressiva com bosses elementais, custo por stage e recompensas por tier.', image: 'assets/media/menu/divergence-system.gif' },
                { url: 'dark-totem-daily.html', title: 'Dark Totem Daily', description: 'Evento diário com boss, cidades possíveis e recompensas.', image: 'assets/media/menu/dark-totem-daily.gif' },
                { url: 'monster-hunter.html', title: 'Monster Hunter', description: 'Evento de caça com criatura sorteada, ranking por abates e recompensas especiais.', image: 'assets/media/items-wiki/Consumables/more points wheel.gif' },
                { url: 'stones-guia-completo.html', title: 'Stones - Guia Completo', description: 'Raridade, slots, upgrade, elementos e tabelas de referência de stones.', image: 'assets/media/menu/stones-guia-completo.gif' },
                { url: 'rune-system.html', title: 'Rune System', description: 'Enhanced Tables, refils, produção por vocação e bônus de combate.', image: 'assets/media/menu/rune-system.gif' },
                { url: 'spell-badge-upgrade.html', title: 'Spell Badge Upgrade', description: 'Badges permanentes para aumentar dano de spells específicas.', image: 'assets/media/menu/spell-badge-upgrade.gif' },
                { url: 'sistema-de-craft.html', title: 'Sistema de Craft', description: 'Receitas, custos e materiais para itens especiais, utilitários e upgrades.', image: 'assets/media/menu/sistema-de-craft.gif' },
                { url: 'character-upgrades.html', title: 'UPGRADE POTIONS', description: 'Potions permanentes para cura, reflect e poderes especiais do personagem.', image: 'assets/media/menu/character-upgrades.gif' },
                { url: 'upgrade-stones.html', title: 'Upgrade Stones', description: 'Chances, limites e efeitos das stones usadas para evoluir equipamentos.', image: 'assets/media/items-wiki/Craft/upgrade stone lvl 1.gif' },
                { url: 'animus-mastery-soulpit.html', title: 'Animus Mastery &amp; SoulPit', description: 'Progressão baseada em criaturas, Soul Core, SoulPit e bônus de experiência.', image: 'assets/media/menu/animus-mastery-soulpit.gif' },
            ],
        },
        {
            title: 'Guias e Utilidades',
            icon: '<svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 5a3 3 0 0 1 3-3h13v18H7a3 3 0 0 0-3 3V5Z"/><path d="M4 19a3 3 0 0 1 3-3h13"/></svg>',
            items: [
                { url: 'vocacoes.html', title: 'Vocações', description: 'Resumo visual das vocações e seus papéis no servidor.', image: 'assets/media/menu/vocacoes.gif' },
                { url: 'comandos-do-servidor.html', title: 'Comandos do Servidor', description: 'Comandos organizados por categoria, com busca rapida.', image: 'assets/media/menu/comandos-do-servidor.gif' },
            ],
        },
        // Itens e Equipamentos e Colecionaveis ficam ocultos por enquanto.
    ];

    function getCurrentPage() {
        const page = window.location.pathname.split('/').pop();
        return (page || 'index.html').toLowerCase();
    }

    function getBaseMenuSection(section) {
        const currentPage = getCurrentPage();
        const isOpen = section.title === 'Sistemas do Servidor';
        const links = section.items.map((item) => {
            const isActive = item.url === currentPage;

            return `
                    <a class="${isActive ? 'active' : ''}" href="${item.url}">
                        <img src="${item.image}" alt="" loading="lazy">
                        <span>
                            <strong>${item.title}</strong>
                            <small>${item.description}</small>
                        </span>
                    </a>
                `;
        }).join('');

        return `
            <section class="menu-section ${isOpen ? 'is-open' : ''}">
                <button type="button" class="menu-section-button" data-section-toggle>
                    <span>${section.icon}</span>
                    <strong>${section.title}</strong>
                    <small>${section.items.length}</small>
                </button>
                <div class="menu-links">
                    ${links}
                </div>
            </section>
        `;
    }

    function injectBaseWikiMenus() {
        const baseMenu = baseMenuSections.map(getBaseMenuSection).join('');

        document.querySelectorAll('.drawer-menu, .sidebar-sticky').forEach((container) => {
            if (container.querySelector('.menu-section')) return;

            const title = container.querySelector('.sidebar-title');
            if (title) {
                title.insertAdjacentHTML('afterend', baseMenu);
            } else {
                container.insertAdjacentHTML('beforeend', baseMenu);
            }
        });
    }

    function syncSidebarArticleCounters() {
        document.querySelectorAll('.sidebar-sticky').forEach((container) => {
            const counter = container.querySelector('.sidebar-title small');
            if (!counter) return;
            const totalLinks = container.querySelectorAll('.menu-links a').length;
            counter.textContent = `${totalLinks} artigos`;
        });
    }

    injectBaseWikiMenus();

    function getScriptsZeroBotMenu() {
        const currentPage = getCurrentPage();
        const isOpen = false;
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
                            <small>Task Book, refils, Auto Forja, Follow, Auto Party e RESET FPS.</small>
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

    function getHuntsCustomMenu() {
        const currentPage = getCurrentPage();
        const isOpen = false;
        const links = huntsCustomMenuItems.map((item) => {
            const isActive = currentPage === item.url;

            return `
                    <a class="${isActive ? 'active' : ''}" href="${item.url}" data-hunts-custom-link>
                        <img src="${item.image}" alt="" loading="lazy">
                        <span>
                            <strong>${item.title}</strong>
                            <small>${item.description}</small>
                        </span>
                    </a>
                `;
        }).join('');

        return `
            <section class="menu-section ${isOpen ? 'is-open' : ''}" data-hunts-custom-menu>
                <button type="button" class="menu-section-button" data-section-toggle>
                    <span><svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 17.5 3 6V3h3l11.5 11.5"/><path d="m13 19 6-6"/><path d="m16 16 3 3"/><path d="m19 13 2-2"/></svg></span>
                    <strong>Hunts Custom</strong>
                    <small>${huntsCustomMenuItems.length}</small>
                </button>
                <div class="menu-links">
                    ${links}
                </div>
            </section>
        `;
    }

    function refreshHuntsCustomActiveLinks() {
        const currentPage = getCurrentPage();

        document.querySelectorAll('[data-hunts-custom-link]').forEach((link) => {
            const linkPage = new URL(link.href, window.location.href).pathname.split('/').pop().toLowerCase();
            link.classList.toggle('active', currentPage === linkPage);
        });
    }

    function injectHuntsCustomMenu() {
        document.querySelectorAll('.drawer-menu, .sidebar-sticky').forEach((container) => {
            if (container.querySelector('[data-hunts-custom-menu]')) return;

            const guideSection = Array.from(container.querySelectorAll('.menu-section')).find((section) => {
                const sectionTitle = section.querySelector('.menu-section-button strong');
                return sectionTitle && sectionTitle.textContent.trim() === 'Guias e Utilidades';
            });

            if (guideSection) {
                guideSection.insertAdjacentHTML('afterend', getHuntsCustomMenu());
            } else {
                container.insertAdjacentHTML('afterbegin', getHuntsCustomMenu());
            }
        });

        document.querySelectorAll('.sidebar-title small').forEach((counter) => {
            if (counter.dataset.huntsCustomCounted) return;
            counter.dataset.huntsCustomCounted = 'true';
            counter.textContent = counter.textContent.replace(/\d+/, (value) => String(Number(value) + huntsCustomMenuItems.length));
        });

        refreshHuntsCustomActiveLinks();
    }

    injectHuntsCustomMenu();
    syncSidebarArticleCounters();

    const craftMaterialIcons = [
        { pattern: /\bgold tokens?\b/i, image: 'assets/media/items-wiki/Craft/Gold_Token.gif' },
        { pattern: /\b\d+\s*k{2,3}s?\b/i, image: 'assets/media/items-wiki/Craft/Crystal_Coin.gif' },
        { pattern: /\bsilver tokens?\b/i, image: 'assets/media/items-wiki/Craft/Silver_Token.gif' },
        { pattern: /\bwarzone tokens?\b/i, image: 'assets/media/items-wiki/Craft/expert wz token.gif' },
        { pattern: /\bdivergence tokens?\b/i, image: 'assets/media/items-wiki/Others/divergence token.gif' },
        { pattern: /\bboss tokens?\b/i, image: 'assets/media/items-wiki/Others/boss token.gif' },
        { pattern: /\bhard task tokens?\b/i, image: 'assets/media/items-wiki/Others/task token.gif' },
        { pattern: /\btask tokens?\b/i, image: 'assets/media/items-wiki/Others/task token.gif' },
        { pattern: /\bmajor crystalline tokens?\b/i, image: 'assets/media/items-wiki/Craft/Major_Crystalline_Token.gif' },
        { pattern: /\btainted hearts?\b/i, image: 'assets/media/items-wiki/Craft/Tainted_Heart.gif' },
        { pattern: /\bdarklight hearts?\b/i, image: 'assets/media/items-wiki/Craft/Darklight_Heart.gif' },
        { pattern: /\bthe essence of murcion\b/i, image: 'assets/media/items-wiki/Craft/the essence of Murcion.gif' },
        { pattern: /\bthe essence of ichgahal\b/i, image: 'assets/media/items-wiki/Craft/the essence of Ichgahal.gif' },
        { pattern: /\bthe essence of vemiath\b/i, image: 'assets/media/items-wiki/Craft/the essence of Vemiath.gif' },
        { pattern: /\bthe essence of chagorz\b/i, image: 'assets/media/items-wiki/Craft/the essence of Chagorz.gif' },
        { pattern: /\bchalice of energy\b/i, image: 'assets/media/items-wiki/Craft/energy chalice.gif' },
        { pattern: /\bchalice of death\b/i, image: 'assets/media/items-wiki/Craft/deathchalice.gif.gif' },
        { pattern: /\bchalice of earth\b/i, image: 'assets/media/items-wiki/Craft/earthchalice.gif' },
        { pattern: /\bchalice of ice\b/i, image: 'assets/media/items-wiki/Craft/icechalice.gif' },
        { pattern: /\bchalice of holy\b/i, image: 'assets/media/items-wiki/Craft/holychalice.gif' },
        { pattern: /\bchalice of physical\b/i, image: 'assets/media/items-wiki/Craft/physicalchalice.gif' },
        { pattern: /\bchalice of fire\b/i, image: 'assets/media/items-wiki/Craft/firechalice.gif' },
        { pattern: /\bprecious metal bars?\b/i, image: 'assets/media/items-wiki/Craft/precious metal bar.gif' },
        { pattern: /\bprecious gold bars?\b/i, image: 'assets/media/items-wiki/Craft/precious gold bar.gif' },
        { pattern: /\belemental cores?\b/i, image: 'assets/media/items-wiki/Craft/elemental_core.gif' },
        { pattern: /\bsanguine upgrade\b/i, image: 'assets/media/items-wiki/Craft/sanguine upgrade.gif' },
        { pattern: /\bupgrade stones? lvl 1\b/i, image: 'assets/media/items-wiki/Craft/upgrade stone lvl 1.gif' },
        { pattern: /\bupgrade stones? lvl 2\b/i, image: 'assets/media/items-wiki/Craft/upgrade stone lvl 2.gif' },
        { pattern: /\bupgrade stones? lvl 3\b/i, image: 'assets/media/items-wiki/Craft/upgrade stone lvl 3.gif' },
        { pattern: /\bupgrade stones? lvl 4\b/i, image: 'assets/media/items-wiki/Craft/upgrade stone lvl 4.gif' },
        { pattern: /\bburningfrost sigil\b/i, image: 'assets/media/items-wiki/Craft/burningfrost sigil.gif' },
        { pattern: /\bpoisonstorm sigil\b/i, image: 'assets/media/items-wiki/Craft/poisonstorm sigil.gif' },
        { pattern: /\bsaintdying sigil\b/i, image: 'assets/media/items-wiki/Craft/saintdying sigil.gif' },
        { pattern: /\bburningfrost pendulet\b/i, image: 'assets/media/items-wiki/Craft/burningfrost pendulet.gif' },
        { pattern: /\bpoisonstorm pendulet\b/i, image: 'assets/media/items-wiki/Craft/poisonstorm pendulet.gif' },
        { pattern: /\bsaintdying pendulet\b/i, image: 'assets/media/items-wiki/Craft/saintdying pendulet.gif' },
    ];

    function escapeHtml(value) {
        return value
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function getCraftMaterialIcon(material) {
        const icon = craftMaterialIcons.find((item) => item.pattern.test(material));
        return icon ? icon.image : '';
    }

    function enhanceCraftMaterialCells() {
        document.querySelectorAll('.craft-recipe-table tbody td:nth-child(4)').forEach((cell) => {
            if (cell.dataset.materialIconsReady) return;
            const materials = cell.textContent.split(',').map((material) => material.trim()).filter(Boolean);
            if (materials.length === 0) return;

            const html = materials.map((material, index) => {
                const ending = material.match(/[.;]$/)?.[0] || '';
                const label = ending ? material.slice(0, -1).trim() : material;
                const icon = getCraftMaterialIcon(label);
                const separator = index < materials.length - 1 ? ',' : ending;
                const content = icon
                    ? `<img src="${icon}" alt="" loading="lazy"> ${escapeHtml(label)}`
                    : escapeHtml(label);

                return `<span class="craft-material${icon ? ' has-icon' : ''}">${content}${separator}</span>`;
            }).join('');

            cell.dataset.materialIconsReady = 'true';
            cell.innerHTML = `<span class="craft-materials">${html}</span>`;
        });
    }

    enhanceCraftMaterialCells();

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            setDrawer(false);
            closeImageLightbox();
        }
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

    const lightboxTriggers = document.querySelectorAll('[data-image-lightbox]');
    let imageLightbox = null;
    let imageLightboxImage = null;
    let imageLightboxCloseButton = null;
    let lastLightboxTrigger = null;
    let previousBodyOverflow = '';

    function closeImageLightbox() {
        if (!imageLightbox || imageLightbox.hidden) return;
        imageLightbox.hidden = true;
        imageLightboxImage.removeAttribute('src');
        imageLightboxImage.removeAttribute('alt');
        document.body.style.overflow = previousBodyOverflow;

        if (lastLightboxTrigger) {
            lastLightboxTrigger.focus();
            lastLightboxTrigger = null;
        }
    }

    if (lightboxTriggers.length > 0) {
        imageLightbox = document.createElement('div');
        imageLightbox.className = 'image-lightbox';
        imageLightbox.hidden = true;
        imageLightbox.setAttribute('role', 'dialog');
        imageLightbox.setAttribute('aria-modal', 'true');
        imageLightbox.setAttribute('aria-label', 'Imagem ampliada');
        imageLightbox.innerHTML = `
            <button class="image-lightbox-backdrop" type="button" data-image-lightbox-close aria-label="Fechar imagem ampliada"></button>
            <div class="image-lightbox-panel">
                <button class="image-lightbox-close" type="button" data-image-lightbox-close aria-label="Fechar imagem ampliada">
                    <svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18M6 6l12 12"/></svg>
                </button>
                <img alt="">
            </div>
        `;

        document.body.appendChild(imageLightbox);
        imageLightboxImage = imageLightbox.querySelector('img');
        imageLightboxCloseButton = imageLightbox.querySelector('.image-lightbox-close');

        imageLightbox.querySelectorAll('[data-image-lightbox-close]').forEach((button) => {
            button.addEventListener('click', closeImageLightbox);
        });

        lightboxTriggers.forEach((trigger) => {
            trigger.addEventListener('click', () => {
                const triggerImage = trigger.querySelector('img');
                const imageSrc = trigger.getAttribute('data-image-lightbox') || triggerImage?.currentSrc || triggerImage?.src;
                const imageAlt = trigger.getAttribute('data-image-lightbox-alt') || triggerImage?.alt || 'Imagem ampliada';
                if (!imageSrc || !imageLightboxImage) return;

                lastLightboxTrigger = trigger;
                previousBodyOverflow = document.body.style.overflow;
                imageLightboxImage.src = imageSrc;
                imageLightboxImage.alt = imageAlt;
                imageLightbox.hidden = false;
                document.body.style.overflow = 'hidden';
                imageLightboxCloseButton.focus();
            });
        });
    }

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
