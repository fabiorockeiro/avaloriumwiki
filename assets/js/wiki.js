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
            image: 'assets/media/hunts-custom/Void Riftcaster.gif',
        },
        {
            url: 'void-corruption-depths-inner-netherbound.html',
            title: 'Void Corruption Depths (Inner Netherbound)',
            description: 'Level recomendado 1200 ~ 1400.',
            image: 'assets/media/hunts-custom/Brain Netherbound.gif',
        },
        {
            url: 'sanctum-of-fire-ice.html',
            title: 'Sanctum of Fire &amp; Ice',
            description: 'Level recomendado 600+.',
            image: 'assets/media/hunts-custom/Firzen.gif',
        },
        {
            url: 'pyramid-of-azhrkhal-three-asuras.html',
            title: 'Pyramid of Azhr\'Khal (Three Asuras)',
            description: 'Level recomendado 750+.',
            image: 'assets/media/hunts-custom/True Enrage Asura.gif',
        },
        {
            url: 'the-fallen-usurpers.html',
            title: 'The Fallen Usurpers',
            description: 'Level recomendado 1600.',
            image: 'assets/media/hunts-custom/Fallen Usurper Commander.gif',
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
                { url: 'monster-hunter.html', title: 'Monster Hunter', description: 'Evento de caça com criatura sorteada, ranking por abates e recompensas especiais.', image: 'assets/media/items-wiki/Chests/boss chest/monster box.gif' },
                { url: 'stones-guia-completo.html', title: 'Stones - Guia Completo', description: 'Raridade, slots, upgrade, elementos e tabelas de referência de stones.', image: 'assets/media/menu/stones-guia-completo.gif' },
                { url: 'rune-system.html', title: 'Rune System', description: 'Enhanced Tables, refils, produção por vocação e bônus de combate.', image: 'assets/media/menu/rune-system.gif' },
                { url: 'spell-badge-upgrade.html', title: 'Spell Badge Upgrade', description: 'Badges permanentes para aumentar dano de spells específicas.', image: 'assets/media/menu/spell-badge-upgrade.gif' },
                { url: 'sistema-de-craft.html', title: 'Sistema de Craft', description: 'Receitas, custos e materiais para itens especiais, utilitários e upgrades.', image: 'assets/media/menu/sistema-de-craft.gif' },
                { url: 'character-upgrades.html', title: 'Character Upgrades', description: 'Sistemas para fortalecer personagem, spells, itens, reflect, scrolls e stones.', image: 'assets/media/menu/character-upgrades.gif' },
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
        {
            title: 'Itens e Equipamentos',
            icon: '<svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/></svg>',
            items: [
                { url: 'weapons.html', title: 'Weapons', description: 'Em construção', image: 'assets/media/menu/weapons.gif' },
                { url: 'armors.html', title: 'Armors', description: 'Em construção', image: 'assets/media/menu/armors.gif' },
                { url: 'helmets.html', title: 'Helmets', description: 'Em construção', image: 'assets/media/menu/helmets.gif' },
                { url: 'legs.html', title: 'Legs', description: 'Em construção', image: 'assets/media/menu/legs.gif' },
                { url: 'boots.html', title: 'Boots', description: 'Em construção', image: 'assets/media/menu/boots.gif' },
                { url: 'shields.html', title: 'Shields', description: 'Em construção', image: 'assets/media/menu/shields.gif' },
                { url: 'rings.html', title: 'Rings', description: 'Em construção', image: 'assets/media/menu/rings.gif' },
                { url: 'amulets.html', title: 'Amulets', description: 'Em construção', image: 'assets/media/menu/amulets.gif' },
                { url: 'ammo.html', title: 'Ammo', description: 'Em construção', image: 'assets/media/menu/ammo.gif' },
                { url: 'dolls.html', title: 'Dolls', description: 'Em construção', image: 'assets/media/menu/dolls.gif' },
                { url: 'backpacks.html', title: 'Backpacks', description: 'Em construção', image: 'assets/media/menu/backpacks.gif' },
                { url: 'portables.html', title: 'Portables', description: 'Itens portateis para comprar, vender, recarregar, imbue, teleportar e gerenciar tasks.', image: 'assets/media/items-wiki/portables/portable arrow.gif' },
            ],
        },
        {
            title: 'Colecionáveis',
            icon: '<svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="m12 2 3 6 6 .9-4.5 4.4 1.1 6.3L12 16.6l-5.6 3 1.1-6.3L3 8.9 9 8l3-6Z"/></svg>',
            items: [
                { url: 'outfits.html', title: 'Outfits', description: 'EM CONSTRUÇÃO', image: 'assets/media/menu/outfits.gif' },
                { url: 'mounts.html', title: 'Montarias', description: 'EM CONSTRUÇÃO', image: 'assets/media/menu/mounts.gif' },
            ],
        },
    ];

    function getCurrentPage() {
        const page = window.location.pathname.split('/').pop();
        return (page || 'index.html').toLowerCase();
    }

    function getBaseMenuSection(section) {
        const currentPage = getCurrentPage();
        const isOpen = section.items.some((item) => item.url === currentPage);
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

    function getHuntsCustomMenu() {
        const currentPage = getCurrentPage();
        const isOpen = currentPage === 'hunts-custom.html' || huntsCustomMenuItems.some((item) => item.url === currentPage);
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
