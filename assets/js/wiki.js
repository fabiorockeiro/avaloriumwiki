(function () {
    const currentPath = window.location.pathname.split('/').pop() || 'index.html';
    const legacyCategoryRedirects = {
        'category-sistemas-do-servidor.html': 'index.html',
        'category-guias-e-utilidades.html': 'comandos-do-servidor.html',
        'category-scripts-zerobot.html': 'fabio-rockeiro-scripts.html',
    };

    if (legacyCategoryRedirects[currentPath]) {
        window.location.replace(legacyCategoryRedirects[currentPath]);
        return;
    }

    document.body.classList.add(currentPath === 'index.html' ? 'page-home' : 'page-inner');
    if (currentPath.startsWith('category-') || currentPath === 'hunts-custom.html') {
        document.body.classList.add('page-category');
    }
    if (currentPath === 'search.html') document.body.classList.add('page-search');

    const readingProgress = document.createElement('div');
    readingProgress.className = 'reading-progress';
    readingProgress.setAttribute('aria-hidden', 'true');
    document.body.prepend(readingProgress);

    function updateReadingProgress() {
        const scrollable = document.documentElement.scrollHeight - window.innerHeight;
        const progress = scrollable > 0 ? Math.min(1, window.scrollY / scrollable) : 0;
        readingProgress.style.setProperty('--reading-progress', String(progress));
    }

    window.addEventListener('scroll', updateReadingProgress, { passive: true });
    window.addEventListener('resize', updateReadingProgress);
    updateReadingProgress();

    const backToTopButton = document.createElement('button');
    backToTopButton.className = 'back-to-top';
    backToTopButton.type = 'button';
    backToTopButton.setAttribute('aria-label', 'Voltar ao topo');
    backToTopButton.setAttribute('title', 'Voltar ao topo');
    backToTopButton.innerHTML = `
        <svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="m18 15-6-6-6 6"/>
        </svg>
    `;
    document.body.appendChild(backToTopButton);

    function updateBackToTopButton() {
        const isVisible = window.scrollY > 500;
        backToTopButton.classList.toggle('is-visible', isVisible);
        backToTopButton.tabIndex = isVisible ? 0 : -1;
    }

    backToTopButton.addEventListener('click', () => {
        const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        window.scrollTo({ top: 0, behavior: reduceMotion ? 'auto' : 'smooth' });
    });

    window.addEventListener('scroll', updateBackToTopButton, { passive: true });
    updateBackToTopButton();

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

    const onlineCountCacheKey = 'avalorium-online-count';
    const onlineCountCacheTtl = 60 * 1000;

    function getOnlineCountTargets() {
        return Array.from(document.querySelectorAll('.server-pill[title="Players online"]'));
    }

    function setOnlineCountStatus(status) {
        getOnlineCountTargets().forEach((pill) => {
            pill.dataset.onlineStatus = status;
        });
    }

    function updateOnlineCountDisplay(count, cached = false) {
        getOnlineCountTargets().forEach((pill) => {
            const countElement = pill.querySelector('strong');
            if (!countElement) return;

            countElement.textContent = String(count);
            pill.dataset.onlineStatus = cached ? 'cached' : 'live';
            pill.title = `${count} players online${cached ? ' (cache)' : ''}`;
        });
    }

    function readCachedOnlineCount() {
        try {
            const cached = JSON.parse(localStorage.getItem(onlineCountCacheKey) || 'null');
            if (!cached || !Number.isFinite(cached.count) || !Number.isFinite(cached.time)) return null;
            if (Date.now() - cached.time > onlineCountCacheTtl) return null;
            return cached.count;
        } catch (error) {
            return null;
        }
    }

    function writeCachedOnlineCount(count) {
        try {
            localStorage.setItem(onlineCountCacheKey, JSON.stringify({
                count,
                time: Date.now(),
            }));
        } catch (error) {
            // Local storage may be disabled; live updates still work.
        }
    }

    function parseOnlineCountFromHtml(html) {
        const match = html.match(/Players\s+Online:\s*(\d+)\s+Players\s+Online/i)
            || html.match(/(\d+)\s+Players\s+Online/i);
        if (!match) return null;

        const count = Number(match[1]);
        return Number.isFinite(count) ? count : null;
    }

    async function fetchOnlineCount() {
        const localEndpoint = 'assets/data/online-count.json';
        const localEndpointVersion = Math.floor(Date.now() / onlineCountCacheTtl);
        const directEndpoint = 'https://avaloriumot.com/index.php/online';

        try {
            const response = await fetch(`${localEndpoint}?v=${localEndpointVersion}`, { cache: 'no-store' });
            if (response.ok) {
                const data = await response.json();
                if (Number.isFinite(data.online)) return data.online;
            }
        } catch (error) {
            // Try the public page below when the generated JSON is unavailable.
        }

        const response = await fetch(directEndpoint, { cache: 'no-store' });
        if (!response.ok) throw new Error(`Online page returned ${response.status}`);

        const html = await response.text();
        const count = parseOnlineCountFromHtml(html);
        if (count === null) throw new Error('Online count not found');

        return count;
    }

    async function refreshOnlineCount() {
        const targets = getOnlineCountTargets();
        if (!targets.length) return;

        const cachedCount = readCachedOnlineCount();
        if (cachedCount !== null) {
            updateOnlineCountDisplay(cachedCount, true);
        } else {
            targets.forEach((pill) => {
                const countElement = pill.querySelector('strong');
                if (countElement) {
                    countElement.textContent = '--';
                }
            });
            setOnlineCountStatus('loading');
        }

        try {
            const count = await fetchOnlineCount();
            updateOnlineCountDisplay(count);
            writeCachedOnlineCount(count);
        } catch (error) {
            setOnlineCountStatus(cachedCount !== null ? 'cached' : 'offline');
        }
    }

    refreshOnlineCount();

    const scriptsZeroBotPages = new Set([
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
            title: 'Sistemas',
            icon: '<svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v6M12 16v6M2 12h6M16 12h6"/><path d="m5 5 4 4M15 15l4 4M19 5l-4 4M9 15l-4 4"/></svg>',
            items: [
                { url: 'divergence-system.html', title: 'Divergence', description: 'Divergence: level 400, Hazard 3, bosses elementais, custos e recompensas por faixa.', image: 'assets/media/menu/divergence-system.gif' },
                { url: 'invasao-de-minibosses.html', title: 'Invasão de Minibosses', description: 'Avisos na tela, 30 minutos para concluir e Golden Raid Tokens como recompensa.', image: 'assets/media/trinket-badges/golden-raid-token.gif' },
                { url: 'tasks-system.html', title: 'Tasks', description: 'Bounty Tasks, baús por dificuldade, Bounty Talisman e Weekly Tasks para trocar pontos na Hunting Task Shop.', image: 'assets/media/items-wiki/portables/portable task book.gif' },
                { url: 'outfit-mount-bonus.html', title: 'Outfit & Mount Bônus', description: 'Obtenha cosméticos e use !outfitbonus para distribuir pontos em bônus de Cosmetic Mastery.', image: 'assets/media/menu/outfits.gif' },
                { url: 'stones-guia-completo.html', title: 'Rarity & Elemental Stones', description: 'Identificação progressiva, slots, ferramentas e bônus das elemental stones.', image: 'assets/media/menu/stones-guia-completo.gif' },
                { url: 'reliquary-system.html', title: 'Reliquary', description: 'Progressão em 81 níveis com itens, gold e Kron Cubes por faixa.', image: 'assets/media/reliquary/arcane-kube.png' },
                { url: 'exalted-forge.html', title: 'Exalted Forge', description: 'Forja custom: tiers, Exalted Core, chances de fusão e custos.', image: 'assets/media/exalted-forge/exalted-core.gif' },
                { url: 'spell-badge-upgrade.html', title: 'Trinket Badges', description: 'Badges para trinkets: compra com Golden Raid Tokens e evolução na Forja.', image: 'assets/media/menu/spell-badge-upgrade.gif' },
                { url: 'sistema-de-craft.html', title: 'Sistema de Craft', description: 'Receitas, custos e materiais para itens especiais, utilitários e upgrades.', image: 'assets/media/menu/sistema-de-craft.gif' },
                { url: 'upgrade-stones.html', title: 'Upgrade Stones', description: 'Chances, limites e efeitos das stones usadas para evoluir equipamentos.', image: 'assets/media/items-wiki/Craft/upgrade stone lvl 1.gif' },
                { url: 'character-upgrades.html', title: 'Upgrade Potions', description: 'Potions permanentes para cura, reflect e poderes especiais do personagem.', image: 'assets/media/menu/character-upgrades.gif' },
                { url: 'dark-totem-daily.html', title: 'Dark Totem Daily', description: 'Boss diário das 20h no Teleport de Eventos, com loot, prêmio de maior dano e sorteio.', image: 'assets/media/menu/dark-totem-daily.gif' },
                { url: 'monster-hunter.html', title: 'Monster Hunter', description: 'Evento de caça com criatura sorteada, ranking por abates e recompensas especiais.', image: 'assets/media/items-wiki/Consumables/more points wheel.gif' },
                { url: 'roulette-system.html', title: 'Roulette', description: 'Roleta, Slot Machines, Roulette Token e recompensas da Season 1.', image: 'assets/media/roulette-system/63110-roulette-token.gif' },
                { url: 'rune-system.html', title: 'Enchanted Refil', description: 'Enchanted Tables, refils, produção por vocação e bônus de combate.', image: 'assets/media/menu/rune-system.gif' },
                { url: 'voucher-system.html', title: 'Voucher', description: 'Ative e controle bônus temporários de EXP, loot, skills, bestiary, task kill e stamina protegida.', image: 'assets/media/voucher-system/golden-newspaper.gif' },
                { url: 'hireling-enchanter.html', title: 'Hireling Enchanter', description: 'Produção enchanted offline, tiers de maestria e até três Workshop Slots.', image: 'assets/media/hireling-enchanter/hireling-enchanter.png' },
                { url: 'animus-mastery-soulpit.html', title: 'Animus Mastery &amp; SoulPit', description: 'Animus, Anonymous Mastery, Soul Cores e bônus de experiência.', image: 'assets/media/menu/animus-mastery-soulpit.gif' },
            ],
        },
        {
            title: 'Guias e Utilidades',
            icon: '<svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 5a3 3 0 0 1 3-3h13v18H7a3 3 0 0 0-3 3V5Z"/><path d="M4 19a3 3 0 0 1 3-3h13"/></svg>',
            items: [
                { url: 'cadeia.html', title: 'Cadeia', description: 'Penas administrativas, fiança, Jail Warden, bloqueios e comandos.', image: 'assets/media/cadeia/prisoner.png' },
                { url: 'comandos-do-servidor.html', title: 'Comandos do Servidor', description: 'Lista completa de comandos, organizada por categoria e função.', image: 'assets/media/menu/comandos-do-servidor.gif' },
                { url: 'stamina.html', title: 'Stamina', description: 'Faixas, recuperação, banheiras e a quest de Stamina Bottle e Extension.', image: 'assets/media/items-wiki/Consumables/stamina bottler.gif' },
            ],
        },
        // Itens e Equipamentos e Colecionaveis ficam ocultos por enquanto.
    ];

    function getDesktopMenuLinks(items, extraClass = '') {
        const currentPage = getCurrentPage();

        return items.map((item) => `
            <a class="desktop-nav-link ${item.url === currentPage ? 'active' : ''} ${extraClass}" href="${item.url}">
                <img src="${item.image}" alt="" loading="lazy">
                <span>${item.title}</span>
            </a>
        `).join('');
    }

    function injectDesktopNavigation() {
        const topbar = document.querySelector('.topbar');
        if (!topbar || topbar.querySelector('.desktop-nav')) return;

        const systems = baseMenuSections[0].items;
        const serverInfo = baseMenuSections[1].items;
        const currentPage = getCurrentPage();
        const systemsActive = systems.some((item) => item.url === currentPage);
        const serverInfoActive = serverInfo.some((item) => item.url === currentPage);
        const huntsActive = huntsCustomMenuItems.some((item) => item.url === currentPage);
        const scriptsActive = scriptsZeroBotPages.has(currentPage);

        topbar.insertAdjacentHTML('beforeend', `
            <nav class="desktop-nav" aria-label="Navegacao principal da wiki">
                <div class="desktop-nav-inner">
                    <div class="desktop-nav-group desktop-nav-group-systems ${systemsActive ? 'active' : ''}">
                        <button type="button" class="desktop-nav-trigger" aria-expanded="false">
                            <svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v6M12 16v6M2 12h6M16 12h6"/><path d="m5 5 4 4M15 15l4 4M19 5l-4 4M9 15l-4 4"/></svg>
                            <span>Sistemas</span>
                            <svg class="desktop-nav-chevron" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
                        </button>
                        <div class="desktop-nav-dropdown desktop-nav-mega">
                            <div class="desktop-nav-heading"><strong>Sistemas</strong><span>${systems.length} guias disponíveis</span></div>
                            <div class="desktop-nav-grid">${getDesktopMenuLinks(systems)}</div>
                        </div>
                    </div>

                    <div class="desktop-nav-group ${serverInfoActive ? 'active' : ''}">
                        <button type="button" class="desktop-nav-trigger" aria-expanded="false">
                            <svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 8h.01"/></svg>
                            <span>Server Info</span>
                            <svg class="desktop-nav-chevron" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
                        </button>
                        <div class="desktop-nav-dropdown desktop-nav-compact">
                            <div class="desktop-nav-heading"><strong>Server Info</strong><span>Informações e utilidades</span></div>
                            ${getDesktopMenuLinks(serverInfo)}
                        </div>
                    </div>

                    <div class="desktop-nav-group ${huntsActive ? 'active' : ''}">
                        <button type="button" class="desktop-nav-trigger" aria-expanded="false">
                            <svg class="ui-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 17.5 3 6V3h3l11.5 11.5"/><path d="m13 19 6-6M16 16l3 3M19 13l2-2"/></svg>
                            <span>Hunt Custom</span>
                            <svg class="desktop-nav-chevron" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
                        </button>
                        <div class="desktop-nav-dropdown desktop-nav-hunts">
                            <div class="desktop-nav-heading"><strong>Hunt Custom</strong><span>Áreas exclusivas do servidor</span></div>
                            ${getDesktopMenuLinks(huntsCustomMenuItems)}
                        </div>
                    </div>

                    <a class="desktop-nav-direct ${scriptsActive ? 'active' : ''}" href="fabio-rockeiro-scripts.html">
                        <img src="assets/media/scripts-zerobot/fabio-rockeiro-bot-icon.png" alt="">
                        <span>Scripts Fabio Rockeiro</span>
                    </a>
                </div>
            </nav>
        `);

        const groups = Array.from(topbar.querySelectorAll('.desktop-nav-group'));
        const closeDesktopMenus = (exception) => {
            groups.forEach((group) => {
                if (group === exception) return;
                group.classList.remove('is-open');
                group.querySelector('.desktop-nav-trigger')?.setAttribute('aria-expanded', 'false');
            });
        };

        groups.forEach((group) => {
            const trigger = group.querySelector('.desktop-nav-trigger');
            trigger?.addEventListener('click', () => {
                const open = !group.classList.contains('is-open');
                closeDesktopMenus(group);
                group.classList.toggle('is-open', open);
                trigger.setAttribute('aria-expanded', String(open));
            });
        });

        document.addEventListener('click', (event) => {
            if (!topbar.querySelector('.desktop-nav')?.contains(event.target)) closeDesktopMenus();
        });

        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape') closeDesktopMenus();
        });
    }

    function getCurrentPage() {
        const page = window.location.pathname.split('/').pop();
        return (page || 'index.html').toLowerCase();
    }

    injectDesktopNavigation();

    function getBaseMenuSection(section) {
        const currentPage = getCurrentPage();
        const isOpen = section.title === 'Sistemas';
        const links = section.items.map((item) => {
            const isActive = item.url === currentPage;

            return `
                    <a class="${isActive ? 'active' : ''}" href="${item.url}">
                        <img src="${item.image}" alt="" loading="lazy">
                        <span>
                            <strong>${item.title}</strong>
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
                    <strong>SCRIPTS e DOWNLOADS</strong>
                    <small>1</small>
                </button>
                <div class="menu-links">
                    <a class="${isActive ? 'active' : ''}" href="fabio-rockeiro-scripts.html">
                        <img src="assets/media/scripts-zerobot/fabio-rockeiro-bot-icon.png" alt="" loading="lazy">
                        <span>
                            <strong>FABIO ROCKEIRO - SCRIPTS e DOWNLOADS</strong>
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
        { pattern: /\bironblood backpack\b/i, image: 'assets/media/craft-utilities/ironblood.png' },
        { pattern: /\bpoison backpack\b/i, image: 'assets/media/craft-utilities/poison.png' },
        { pattern: /\blothlorien backpack\b/i, image: 'assets/media/craft-utilities/lothlorien.png' },
        { pattern: /\bcorrupted backpack\b/i, image: 'assets/media/craft-utilities/corrupted.png' },
        { pattern: /\bgold tokens?\b/i, image: 'assets/media/items-wiki/Craft/Gold_Token.gif' },
        { pattern: /\b\d+\s*k{2,3}s?\b|\bcrystal coins?\b/i, image: 'assets/media/items-wiki/Craft/Crystal_Coin.gif' },
        { pattern: /\bsilver tokens?\b/i, image: 'assets/media/items-wiki/Craft/Silver_Token.gif' },
        { pattern: /\bwarzone tokens?\b/i, image: 'assets/media/items-wiki/Craft/expert wz token.gif' },
        { pattern: /\bdivergence tokens?\b/i, image: 'assets/media/items-wiki/Others/divergence token.gif' },
        { pattern: /\bboss tokens?\b/i, image: 'assets/media/items-wiki/Others/boss token.gif' },
        { pattern: /\bhard task tokens?\b/i, image: 'assets/media/items-wiki/Others/task token.gif' },
        { pattern: /\btask tokens?\b/i, image: 'assets/media/items-wiki/Others/task token.gif' },
        { pattern: /\bmajor crystalline tokens?\b/i, image: 'assets/media/items-wiki/Craft/Major_Crystalline_Token.gif' },
        { pattern: /\bgreater fragments?\b/i, image: 'assets/media/craft-progression/fragments/greater-fragment.gif' },
        { pattern: /\blesser fragments?\b/i, image: 'assets/media/craft-progression/fragments/lesser-fragment.gif' },
        { pattern: /\bexalted cores?\b/i, image: 'assets/media/craft-progression/materials/exalted-core.gif' },
        { pattern: /\bpiece of massacre.+shell\b/i, image: 'assets/media/craft-progression/materials/piece-of-massacres-shell.gif' },
        { pattern: /\bmr\. punish.+handcuffs\b/i, image: 'assets/media/craft-progression/materials/mr-punishs-handcuffs.gif' },
        { pattern: /\bdracola.+eye\b/i, image: 'assets/media/craft-progression/materials/dracolas-eye.gif' },
        { pattern: /\bhandmaiden.+protector\b/i, image: 'assets/media/craft-progression/materials/handmaidens-protector.gif' },
        { pattern: /\bimperor.+trident\b/i, image: 'assets/media/craft-progression/materials/imperors-trident.gif' },
        { pattern: /\bplasmother.+remains\b/i, image: 'assets/media/craft-progression/materials/plasmothers-remains.gif' },
        { pattern: /\bcountess sorrow.+frozen tear\b/i, image: 'assets/media/craft-progression/materials/countess-sorrows-frozen-tear.gif' },
        { pattern: /\bdemonic essence\b/i, image: 'assets/media/craft-progression/materials/demonic-essence.gif' },
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
        { pattern: /\bdamage ring of fire\b/i, image: 'assets/media/accessory-craft/damage/damage-ring-fire.gif' },
        { pattern: /\bdamage ring of ice\b/i, image: 'assets/media/accessory-craft/damage/damage-ring-ice.gif' },
        { pattern: /\bdamage ring of earth\b/i, image: 'assets/media/accessory-craft/damage/damage-ring-earth.gif' },
        { pattern: /\bdamage ring of energy\b/i, image: 'assets/media/accessory-craft/damage/damage-ring-energy.gif' },
        { pattern: /\bdamage ring of holy\b/i, image: 'assets/media/accessory-craft/damage/damage-ring-holy.gif' },
        { pattern: /\bdamage ring of death\b/i, image: 'assets/media/accessory-craft/damage/damage-ring-death.gif' },
        { pattern: /\bdamage ring of physical\b/i, image: 'assets/media/accessory-craft/damage/damage-ring-physical.gif' },
        { pattern: /\bdamage amulet of fire\b/i, image: 'assets/media/accessory-craft/damage/damage-amulet-fire.gif' },
        { pattern: /\bdamage amulet of ice\b/i, image: 'assets/media/accessory-craft/damage/damage-amulet-ice.gif' },
        { pattern: /\bdamage amulet of earth\b/i, image: 'assets/media/accessory-craft/damage/damage-amulet-earth.gif' },
        { pattern: /\bdamage amulet of energy\b/i, image: 'assets/media/accessory-craft/damage/damage-amulet-energy.gif' },
        { pattern: /\bdamage amulet of holy\b/i, image: 'assets/media/accessory-craft/damage/damage-amulet-holy.gif' },
        { pattern: /\bdamage amulet of death\b/i, image: 'assets/media/accessory-craft/damage/damage-amulet-death.gif' },
        { pattern: /\bdamage amulet of physical\b/i, image: 'assets/media/accessory-craft/damage/damage-amulet-physical.gif' },
        { pattern: /\bdefense ring of death\b/i, image: 'assets/media/items-wiki/Craft/defring1.gif' },
        { pattern: /\bdefense ring of energy\b/i, image: 'assets/media/items-wiki/Craft/defring2.gif' },
        { pattern: /\bdefense ring of holy\b/i, image: 'assets/media/items-wiki/Craft/defring3.gif' },
        { pattern: /\bdefense ring of ice\b/i, image: 'assets/media/items-wiki/Craft/defring4.gif' },
        { pattern: /\bdefense ring of fire\b/i, image: 'assets/media/items-wiki/Craft/defring5.gif' },
        { pattern: /\bdefense ring of earth\b/i, image: 'assets/media/items-wiki/Craft/defring6.gif' },
        { pattern: /\bdefense amulet of fire\b/i, image: 'assets/media/items-wiki/Craft/defamulet3.gif' },
        { pattern: /\bdefense amulet of holy\b/i, image: 'assets/media/items-wiki/Craft/defamulet4.gif' },
        { pattern: /\bdefense amulet of energy\b/i, image: 'assets/media/items-wiki/Craft/defamulet5.gif' },
        { pattern: /\bdefense amulet of death\b/i, image: 'assets/media/items-wiki/Craft/defamuletdeath.gif' },
        { pattern: /\bdefense amulet of earth\b/i, image: 'assets/media/items-wiki/Craft/defamuletearth.gif' },
        { pattern: /\bdefense amulet of ice\b/i, image: 'assets/media/items-wiki/Craft/defamuletice.gif' },
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

    const craftSectionLinks = [...document.querySelectorAll('.cv-section-nav a[href^="#"], .system-section-nav a[href^="#"]')];
    const craftCollapsibleSections = [...document.querySelectorAll('[data-craft-collapse]')];
    const craftMobile = window.matchMedia('(max-width: 700px)');

    function setCraftSectionExpanded(section, expanded) {
        const heading = section.querySelector(':scope > :is(.cv-heading,.ct-heading,.cu-heading)');
        const button = heading?.querySelector('.craft-collapse-toggle');
        section.classList.toggle('is-collapsed', craftMobile.matches && !expanded);
        [...section.children].forEach((child) => {
            if (child !== heading) child.hidden = craftMobile.matches && !expanded;
        });
        if (button) button.setAttribute('aria-expanded', String(!craftMobile.matches || expanded));
    }

    function revealCraftTarget(target) {
        const section = target?.closest('[data-craft-collapse]');
        if (section) setCraftSectionExpanded(section, true);
    }

    craftCollapsibleSections.forEach((section, index) => {
        const heading = section.querySelector(':scope > :is(.cv-heading,.ct-heading,.cu-heading)');
        if (!heading) return;
        const title = heading.querySelector('h2')?.textContent.trim() || 'seção';
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'craft-collapse-toggle';
        button.setAttribute('aria-label', `Alternar ${title}`);
        button.addEventListener('click', () => {
            setCraftSectionExpanded(section, button.getAttribute('aria-expanded') !== 'true');
        });
        heading.append(button);
        const hashTarget = location.hash ? section.querySelector(location.hash) : null;
        setCraftSectionExpanded(section, index === 0 || section.matches(location.hash || ':not(*)') || Boolean(hashTarget));
    });

    craftMobile.addEventListener('change', () => {
        craftCollapsibleSections.forEach((section, index) => setCraftSectionExpanded(section, index === 0));
    });

    craftSectionLinks.forEach((link) => {
        link.addEventListener('click', () => revealCraftTarget(document.querySelector(link.hash)));
    });

    window.addEventListener('hashchange', () => {
        if (location.hash) revealCraftTarget(document.querySelector(location.hash));
    });

    if (craftSectionLinks.length && 'IntersectionObserver' in window) {
        const byId = new Map(craftSectionLinks.map((link) => [link.hash.slice(1), link]));
        const observer = new IntersectionObserver((entries) => {
            const visible = entries.filter((entry) => entry.isIntersecting).sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
            if (!visible) return;
            craftSectionLinks.forEach((link) => link.removeAttribute('aria-current'));
            byId.get(visible.target.id)?.setAttribute('aria-current', 'true');
        }, { rootMargin: '-25% 0px -60%', threshold: [0, .25, .5] });
        byId.forEach((link, id) => {
            const section = document.getElementById(id);
            if (section) observer.observe(section);
        });
    }

    const craftAttributeSvgIcons = {
        shield: '<svg viewBox="0 0 24 24" aria-hidden="true"><path class="icon-base" d="M12 2.8 4 6v6.1c0 4.1 3.8 7.1 8 9.1 4.2-2 8-5 8-9.1V6l-8-3.2Z"/><path d="m8.5 12 2.3 2.4 4.8-5"/></svg>',
        weapon: '<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="m14.5 17.5-8-8L3 6V3h3l3.5 3.5 8 8"/><path d="m13 19 6-6M16 16l3 3"/></svg>',
        target: '<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3"/></svg>',
        life: '<svg class="icon-life" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2.8S5.3 10.8 5.3 15a6.7 6.7 0 0 0 13.4 0c0-4.2-6.7-12.2-6.7-12.2Z"/></svg>',
        mana: '<svg class="icon-mana" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2.8S5.3 10.8 5.3 15a6.7 6.7 0 0 0 13.4 0c0-4.2-6.7-12.2-6.7-12.2Z"/></svg>',
        magic: '<svg class="icon-magic" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="m4 20 11-11 2 2L6 22 4 20Z"/><path d="m18 2 .7 2.3L21 5l-2.3.7L18 8l-.7-2.3L15 5l2.3-.7L18 2Z"/><path d="M9 3v3M7.5 4.5h3M20 13v2M19 14h2"/></svg>',
        range: '<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>',
        deathAttack: '<svg class="icon-death-attack" viewBox="0 0 24 24" aria-hidden="true"><path d="M5.5 11.2a6.5 6.5 0 1 1 13 0c0 2.4-1.1 4.3-3 5.5V21h-7v-4.3c-1.9-1.2-3-3.1-3-5.5Z"/><circle cx="9.3" cy="11.2" r="1.35"/><circle cx="14.7" cy="11.2" r="1.35"/><path d="m12 13.2-1 1.6h2l-1-1.6ZM9.5 18h5M11 18v3m2-3v3"/></svg>',
    };

    const elementColors = {
        fire: '#ff7048', energy: '#b069ff', death: '#eef2f7', earth: '#55c878',
        ice: '#70dcff', holy: '#ffd86b', physical: '#b8c0cc',
    };

    function getElementName(text) {
        return Object.keys(elementColors).find((element) => new RegExp(`\\b${element}\\b`, 'i').test(text)) || '';
    }

    function getElementSymbol(element) {
        const symbols = {
            fire: '<path d="M12 2.5c1.4 4.2 5.2 5.5 5.2 10.3A5.3 5.3 0 0 1 6.6 13c0-2.4 1.3-4.2 3.1-6l.5 4.1c2.1-2.3 2.5-5.2 1.8-8.6Z"/>',
            energy: '<path d="m13 2-7 12h5l-1 8 8-13h-5V2Z"/>',
            death: '<path d="M6 12a6 6 0 1 1 12 0v5H6v-5Z"/><circle cx="9.5" cy="11.5" r="1.2"/><circle cx="14.5" cy="11.5" r="1.2"/><path d="M10 17v-2m4 2v-2"/>',
            earth: '<path d="M20 3C9 3 3 9 6 17c8 3 14-4 14-14Z"/><path class="icon-cut" d="m4 21 11-11"/>',
            ice: '<path class="icon-cut" d="M12 2v20M3.5 7l17 10M3.5 17l17-10M9 4.5 12 7l3-2.5M9 19.5l3-2.5 3 2.5"/>',
            holy: '<circle cx="12" cy="12" r="4"/><path class="icon-cut" d="M12 2v4m0 12v4M2 12h4m12 0h4M5 5l3 3m8 8 3 3M5 19l3-3m8-8 3-3"/>',
            physical: '<path d="M7 11V6a2 2 0 0 1 4 0v5-7a2 2 0 0 1 4 0v7-5a2 2 0 0 1 4 0v9l-4 6H9l-5-8a2 2 0 0 1 3-2Z"/>',
        };
        return symbols[element] || symbols.physical;
    }

    function getElementIcon(element, variant = 'plain') {
        const color = elementColors[element] || elementColors.physical;
        const symbol = getElementSymbol(element);
        if (variant === 'shield') {
            return `<svg class="icon-element icon-shield" style="--icon-color:${color}" viewBox="0 0 24 24" aria-hidden="true"><path class="icon-base" d="M12 2.5 4 5.8v6c0 4.2 3.8 7.3 8 9.4 4.2-2.1 8-5.2 8-9.4v-6l-8-3.3Z"/><g transform="translate(6 6) scale(.5)">${symbol}</g></svg>`;
        }
        return `<svg class="icon-element" style="--icon-color:${color}" viewBox="0 0 24 24" aria-hidden="true">${symbol}</svg>`;
    }

    document.querySelectorAll('.ac-family').forEach((family) => {
        family.open = true;
        family.querySelector('summary')?.addEventListener('click', (event) => event.preventDefault());
        family.querySelectorAll('.ac-element-name[data-element]').forEach((label) => {
            const icon = document.createElement('span');
            icon.className = 'ac-element-icon';
            icon.innerHTML = label.dataset.element === 'death'
                ? craftAttributeSvgIcons.deathAttack
                : getElementIcon(label.dataset.element);
            label.prepend(icon);
        });
    });

    function getMagicElementIcon(element) {
        return `<span class="icon-magic-up">${getElementIcon(element)}<svg viewBox="0 0 12 12" aria-hidden="true"><path d="M6 10V2M2.5 5.5 6 2l3.5 3.5"/></svg></span>`;
    }

    function getCraftAttributeIcon(label, value) {
        const element = getElementName(`${label} ${value}`);
        if (/prote/i.test(label)) return element ? getElementIcon(element, 'shield') : craftAttributeSvgIcons.shield;
        if (/magic level/i.test(label) && element) return getMagicElementIcon(element);
        if (/ataque/i.test(label) && element === 'death') return craftAttributeSvgIcons.deathAttack;
        if ((/ataque|bond/i.test(label) || element) && element) return getElementIcon(element);
        if (/defesa|shield|dodge/i.test(label)) return craftAttributeSvgIcons.shield;
        if (/life leech/i.test(label)) return craftAttributeSvgIcons.life;
        if (/mana leech/i.test(label)) return craftAttributeSvgIcons.mana;
        if (/critical|hit|fatal/i.test(label)) return craftAttributeSvgIcons.target;
        if (/alcance|momentum/i.test(label)) return craftAttributeSvgIcons.range;
        if (/magic|mantra|transcendence/i.test(label)) return craftAttributeSvgIcons.magic;
        return craftAttributeSvgIcons.weapon;
    }

    document.querySelectorAll('.cv-attributes > div').forEach((attribute) => {
        const label = attribute.querySelector('dt');
        const value = attribute.querySelector('dd');
        if (!label || !value || label.querySelector('.cv-attribute-icon')) return;

        const icon = document.createElement('span');
        icon.className = 'cv-attribute-icon';
        icon.innerHTML = getCraftAttributeIcon(label.textContent.trim(), value.textContent.trim());
        label.prepend(icon);
    });

    document.querySelectorAll('#atributos-trinkets .ct-comparison tbody th[scope="row"]').forEach((label) => {
        if (label.querySelector('.cv-attribute-icon')) return;
        const text = label.textContent.trim();
        const values = [...label.parentElement.querySelectorAll('td')].map((cell) => cell.textContent.trim()).join(' ');
        const wrapper = document.createElement('span');
        wrapper.className = 'ct-attribute-label';
        const icon = document.createElement('span');
        icon.className = 'cv-attribute-icon';
        icon.innerHTML = getCraftAttributeIcon(text, values);
        const name = document.createElement('span');
        name.textContent = text;
        wrapper.append(icon, name);
        label.replaceChildren(wrapper);
    });

    const trinketVocationSprites = {
        monk: ['monk-v1.gif', 'monk-v2.gif', 'monk-v3.gif'],
        knight: ['knight-v1.gif', 'knight-v2.gif', 'knight-v3.gif'],
        paladin: ['paladin-v1.gif', 'paladin-v2.gif', 'paladin-v3.gif'],
        sorcerer: ['sorcerer-v1.gif', 'sorcerer-v2.gif', 'sorcerer-v3.gif'],
        druid: ['druid-v1.gif', 'druid-v2.gif', 'druid-v3.gif'],
    };

    Object.entries(trinketVocationSprites).forEach(([vocation, sprites]) => {
        const summary = document.querySelector(`#trinket-${vocation} > summary`);
        const version = summary?.querySelector('.ct-version-tag');
        if (!summary || !version || summary.querySelector('.ct-trinket-sprites')) return;
        const group = document.createElement('span');
        group.className = `ct-trinket-sprites ct-trinket-sprites--${vocation}`;
        group.setAttribute('aria-label', `Trinkets ${vocation} v1, v2 e v3`);
        sprites.forEach((sprite, index) => {
            const item = document.createElement('span');
            item.className = 'ct-trinket-version';
            const label = document.createElement('small');
            label.textContent = `v${index + 1}`;
            const image = document.createElement('img');
            image.src = `assets/media/trinket-craft/vocations/${sprite}`;
            image.alt = `Trinket ${vocation} v${index + 1}`;
            image.width = 44;
            image.height = 44;
            image.loading = 'lazy';
            item.append(label, image);
            group.append(item);
        });
        summary.insertBefore(group, version);
    });

    const ancientWeaponImages = {
        'Ancient Void Razor': 'ancient-void-razor.gif',
        'Ancient Void Hatchet': 'ancient-void-hatchet.gif',
        'Ancient Void Battleaxe': 'ancient-void-battleaxe.gif',
        'Ancient Void Cudgel': 'ancient-void-cudgel.gif',
        'Ancient Void Bludgeon': 'ancient-void-bludgeon.gif',
        'Ancient Void Bow': 'ancient-void-bow.gif',
        'Ancient Void Crossbow': 'ancient-void-crossbow.gif',
        'Ancient Void Rod': 'ancient-void-rod.gif',
        'Ancient Void Coil': 'ancient-void-coil.gif',
        'Ancient Void Claws': 'ancient-void-claws.gif',
    };

    document.querySelectorAll('.cv-weapon > header').forEach((header) => {
        const title = header.querySelector('h4');
        const filename = title ? ancientWeaponImages[title.textContent.trim()] : '';
        if (!filename || header.querySelector('.cv-weapon-image')) return;

        const image = document.createElement('img');
        image.className = 'cv-weapon-image';
        image.src = `assets/media/craft-progression/ancient-items/${filename}`;
        image.alt = '';
        image.width = 56;
        image.height = 56;
        image.loading = 'lazy';
        header.append(image);
    });

    function getAncientWeaponIcon(name) {
        let shape = '<path d="m7 19 10-14 2 2L9 21H5l2-2Z"/><path class="weapon-gold" d="m14 6 3-3 4 4-3 3-4-4ZM5 17l4 4-2 1-4-4 2-1Z"/>';
        if (/hatchet/i.test(name)) shape = '<path d="M7 21 16 4"/><path class="weapon-gold" d="M13 4c3-2 7-1 9 2l-4 6-7-4 2-4Z"/><path d="m9 12 5 3"/>';
        if (/battleaxe/i.test(name)) shape = '<path d="M12 22V7"/><path class="weapon-gold" d="M12 5C8 1 3 3 2 7l5 4 5-4 5 4 5-4c-1-4-6-6-10-2Z"/>';
        if (/cudgel/i.test(name)) shape = '<path d="m6 21 9-11"/><path class="weapon-gold" d="m12 5 5-3 5 5-3 5-7-7Z"/><circle cx="17" cy="7" r="2"/>';
        if (/bludgeon/i.test(name)) shape = '<path d="m7 21 9-12"/><path class="weapon-gold" d="m12 3 7-1 3 6-5 5-6-5 1-5Z"/><path d="m14 5 5 4"/>';
        if (/crossbow/i.test(name)) shape = '<path d="m5 19 12-12M8 8c4-4 9-3 13 1l-4 4M4 7c4 0 8 3 9 7"/><path class="weapon-gold" d="m12 11 4 4-2 2-4-4 2-2Z"/>';
        else if (/bow/i.test(name)) shape = '<path d="M19 3C9 5 5 11 6 21M19 3c2 8-3 15-13 18M6 21 19 3"/><path class="weapon-gold" d="m10 15 7-1-3 6-4-5Z"/>';
        if (/rod/i.test(name)) shape = '<path d="M7 22 15 7"/><path class="weapon-gold" d="M13 7c-2-4 2-7 6-5l3 4-4 4-5-3Z"/><circle cx="18" cy="5" r="2"/>';
        if (/coil/i.test(name)) shape = '<path d="M7 22 15 8"/><path class="weapon-gold" d="M12 7c1-6 8-7 10-2-1 5-5 7-10 2Z"/><path d="M15 5c2-2 4-1 5 1"/>';
        if (/claws/i.test(name)) shape = '<path class="weapon-gold" d="M4 17 7 4l3 8L14 2l1 10 5-7-2 13-6 4-8-5Z"/><path d="m7 13 5 9m1-10-1 10m5-9-5 9"/>';
        return `<svg viewBox="0 0 24 24" aria-hidden="true">${shape}</svg>`;
    }

    // Preserve ingredient links and quantities when decorating the newer recipe lists.
    document.querySelectorAll('.craft-progression-page :is(.cv-materials, .ct-recipes ul) > li > :is(span, a)').forEach((label) => {
        if (label.querySelector('img')) return;
        const source = getCraftMaterialIcon(label.textContent);
        if (!source) return;
        const icon = document.createElement('img');
        icon.src = source;
        icon.alt = '';
        icon.width = 24;
        icon.height = 24;
        icon.loading = 'lazy';
        icon.className = 'craft-ingredient-icon';
        const text = document.createElement('span');
        while (label.firstChild) text.append(label.firstChild);
        label.classList.add('craft-ingredient-label');
        label.append(icon, text);
    });

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

    document.querySelectorAll('[data-command-list] li').forEach((item) => {
        const separatorIndex = item.textContent.indexOf(' - ');
        if (separatorIndex < 0) return;

        const command = item.textContent.slice(0, separatorIndex).trim();
        const description = item.textContent.slice(separatorIndex + 3).trim();
        item.replaceChildren();

        const commandElement = document.createElement('code');
        commandElement.textContent = command;
        const separator = document.createElement('span');
        separator.className = 'command-separator';
        separator.textContent = ' - ';
        const descriptionElement = document.createElement('span');
        descriptionElement.textContent = description;
        item.append(commandElement, separator, descriptionElement);
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
