# Arquitetura e comportamento atual

## Estrutura global

Todas as páginas compartilham: barra superior, busca, indicador de jogadores online, atalhos externos, menu lateral desktop, drawer mobile, conteúdo central e rodapé. O menu é injetado por JavaScript; ele não está escrito integralmente em cada HTML.

## Componentes globais

| Componente | Função | Origem |
|---|---|---|
| Topbar | Logo, busca, online e atalhos externos | HTML de cada página + `wiki.css` |
| Menu lateral | Navegação desktop por seções expansíveis | Gerado por `wiki.js` |
| Drawer mobile | Versão móvel do menu e atalhos | HTML + conteúdo gerado por `wiki.js` |
| Busca | Consulta local sobre o índice estático | `search.html`, `static-search.js`, `search-index.js` |
| Contador online | Exibe total de jogadores | `wiki.js` + `assets/data/online-count.json` |
| Filtros de tabela | Oculta linhas conforme texto digitado | Atributos `data-filter-*` + `wiki.js` |
| Lightbox | Amplia imagens de artigos | Atributo `data-image-lightbox` + `wiki.js` |
| Carrossel | Slides com setas, dots e teclado | Atributos `data-carousel-*` + `wiki.js` |
| Rodapé | Marca, copyright e redes sociais | HTML repetido nas páginas |

## Atalhos externos globais

| Nome do ícone/ação | Destino | Representação atual |
|---|---|---|
| Abrir menu | Drawer mobile | SVG inline: três linhas (hambúrguer) |
| Buscar | `search.html?q=...` | SVG inline: lupa |
| Download | Site do Avalorium / downloads | SVG inline: seta para baixo |
| Discord | Servidor Discord | SVG inline: símbolo estilizado do Discord |
| Instagram | Perfil do Instagram | SVG inline: câmera |
| YouTube | Canal oficial do Avalorium OT | SVG inline: botão de reprodução |
| WhatsApp | Grupo do WhatsApp | SVG inline: balão/telefone |
| Donate | Página de doação | SVG inline: caixa/loja |
| Fechar | Fecha drawer ou lightbox | SVG inline: X |
| Anterior / próximo | Navegação em carrosséis | SVG inline: setas |

## Dados e automação

- `scripts/update-online-count.mjs` atualiza o JSON usado pelo contador online.
- `assets/downloads/FabioRockeiroBOT.lua` é um download oferecido pela página de scripts.
- Não há framework, bundler, banco de dados ou geração de páginas no estado atual.
- Cabeçalho, menu-base e rodapé são parcialmente repetidos em cada HTML; isso aumenta o custo de manutenção e deve ser componentizado na nova versão.

## Pontos de atenção já visíveis

- O menu e o índice de busca duplicam metadados; podem divergir.
- Há páginas existentes fora do menu e da busca.
- Há nomes de arquivo com espaços, acentos, apóstrofos e extensões duplicadas como `.gif.gif`; normalize durante a migração, mantendo um mapa de origem/destino.
- Existem textos com sinais de mojibake (por exemplo, caracteres UTF-8 interpretados incorretamente). Padronize tudo em UTF-8.
- Muitos SVGs de interface são repetidos inline em todos os HTMLs; consolide-os em um sistema de ícones/componentes.
