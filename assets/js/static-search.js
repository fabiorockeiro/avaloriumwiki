(function () {
    function normalize(value) {
        return String(value || '')
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .toLowerCase();
    }

    document.addEventListener('DOMContentLoaded', function () {
        var params = new URLSearchParams(window.location.search);
        var query = params.get('q') || '';
        var normalizedQuery = normalize(query.trim());
        var index = window.AVALORIUM_SEARCH_INDEX || [];
        var main = document.querySelector('.wiki-main');
        var headingText = document.querySelector('.page-hero p');
        var empty = main ? main.querySelector('.empty-state') : null;

        document.querySelectorAll('input[name="q"]').forEach(function (input) {
            input.value = query;
        });

        if (!main) return;

        var results = normalizedQuery === '' ? [] : index.filter(function (item) {
            var haystack = normalize([
                item.title,
                item.description,
                item.category,
                item.keywords
            ].join(' '));
            return haystack.indexOf(normalizedQuery) !== -1;
        });

        if (headingText) {
            headingText.textContent = normalizedQuery === ''
                ? 'Digite um termo para buscar na wiki.'
                : results.length + ' resultado(s) para "' + query + '"';
        }

        if (empty) empty.remove();

        if (normalizedQuery === '') {
            main.insertAdjacentHTML('beforeend', '<section class="empty-state"><span></span><h2>Digite um termo para buscar</h2><p>A busca encontra sistemas, itens, comandos e categorias.</p></section>');
            return;
        }

        if (results.length === 0) {
            main.insertAdjacentHTML('beforeend', '<section class="empty-state"><span></span><h2>Nenhum resultado encontrado</h2><p>Tente procurar por sistema, item, custo, vocacao ou comando.</p></section>');
            return;
        }

        var list = document.createElement('div');
        list.className = 'search-results';

        results.forEach(function (item) {
            var link = document.createElement('a');
            link.className = 'search-result';
            link.href = item.url;
            link.innerHTML = '<span class="search-result-icon"><img src="' + item.image + '" alt=""></span>'
                + '<span><strong></strong><small></small></span>';
            link.querySelector('strong').textContent = item.title;
            link.querySelector('small').textContent = item.category + ' - ' + item.description;
            list.appendChild(link);
        });

        main.appendChild(list);
    });
})();