# Documentação da Avalorium Wiki

> Inventário do estado atual, gerado em 2026-09-03. Serve como mapa de migração para a reconstrução da wiki.

## Visão geral

- Implementação: site estático em HTML, CSS e JavaScript, publicado diretamente pelo GitHub Pages.
- Páginas HTML: **43**.
- Entradas no menu e índice de busca: **20**.
- Imagens catalogadas: **457** (426 GIF, 29 PNG e 2 JPG).
- Assets referenciados no código: **257**.
- Assets sem referência direta: **200**. Eles podem ser reserva, conteúdo futuro ou legado; não devem ser descartados sem revisão.

## Documentos

- [Arquitetura e comportamento](ARQUITETURA.md)
- [Menus e navegação](MENUS-E-NAVEGACAO.md)
- [Catálogo de todas as páginas](PAGINAS.md)
- [Inventário visual de imagens](ASSETS-VISUAIS.md)
- [Planilha completa de imagens](assets-visuais.csv)
- [Plano de reconstrução](PLANO-DE-RECONSTRUCAO.md)
- [Novo sistema visual premium](DESIGN-SYSTEM.md)

## Fontes de verdade atuais

- `assets/js/wiki.js`: monta os menus, controles interativos, lightbox, filtros e carrosséis.
- `assets/js/search-index.js`: índice pesquisável e metadados dos artigos publicados.
- `assets/css/wiki.css`: todo o tema visual e layout responsivo.
- Arquivos `*.html` na raiz: conteúdo e marcação de cada página.
- `assets/media/`: biblioteca visual.

## Regra de preservação

Antes da reconstrução, mantenha os slugs/URLs atuais ou crie redirecionamentos. Preserve também uma cópia integral de `assets/media`, pois **200 arquivos não aparecem como referência literal no código atual** e podem conter material ainda útil.
