import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const docsDir = path.join(root, 'docs');
const htmlFiles = fs.readdirSync(root).filter((name) => name.endsWith('.html')).sort();
const sourceFiles = [
  ...htmlFiles.map((name) => path.join(root, name)),
  path.join(root, 'assets/css/wiki.css'),
  path.join(root, 'assets/js/wiki.js'),
  path.join(root, 'assets/js/search-index.js'),
].filter(fs.existsSync);

const decode = (value = '') => value
  .replace(/&amp;/g, '&').replace(/&quot;/g, '"').replace(/&#39;/g, "'")
  .replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&nbsp;/g, ' ')
  .replace(/&#(\d+);/g, (_, code) => String.fromCodePoint(Number(code)))
  .replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
const match = (text, regex) => decode(text.match(regex)?.[1] || '');
const esc = (value = '') => value.replaceAll('|', '\\|').replaceAll('\n', ' ');
const rel = (value) => path.relative(root, value).replaceAll('\\', '/');

const searchSource = fs.readFileSync(path.join(root, 'assets/js/search-index.js'), 'utf8');
const searchJson = searchSource.slice(searchSource.indexOf('['), searchSource.lastIndexOf(']') + 1);
const searchItems = JSON.parse(searchJson);
const byUrl = new Map(searchItems.map((item) => [item.url, item]));

const pages = htmlFiles.map((file) => {
  const source = fs.readFileSync(path.join(root, file), 'utf8');
  const headings = [...source.matchAll(/<h([1-3])[^>]*>([\s\S]*?)<\/h\1>/gi)]
    .map((entry) => ({ level: Number(entry[1]), text: decode(entry[2]) })).filter((item) => item.text);
  const images = [...source.matchAll(/<img\b[^>]*\bsrc=["']([^"']+)["'][^>]*>/gi)].map((entry) => entry[1]);
  const item = byUrl.get(file);
  const kind = file === 'index.html' ? 'Página inicial'
    : file === 'search.html' ? 'Busca'
    : file.startsWith('category-') ? 'Categoria'
    : item ? 'Artigo no menu/busca' : 'Artigo fora do menu/busca';
  return {
    file, kind,
    title: match(source, /<title>([\s\S]*?)<\/title>/i).replace(/ \| Avalorium OT Wiki$/, ''),
    h1: headings.find((heading) => heading.level === 1)?.text || '',
    description: match(source, /<meta\s+name=["']description["']\s+content=["']([^"']*)["']/i) || item?.description || '',
    category: item?.category || (file.startsWith('category-') ? 'Página agregadora' : '—'),
    headings, images: [...new Set(images)],
  };
});

const menuSections = new Map();
for (const item of searchItems) {
  if (!menuSections.has(item.category)) menuSections.set(item.category, []);
  menuSections.get(item.category).push(item);
}

function walk(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const full = path.join(directory, entry.name);
    return entry.isDirectory() ? walk(full) : [full];
  });
}

const sourceContents = sourceFiles.map((file) => ({ file: rel(file), text: fs.readFileSync(file, 'utf8') }));
const assets = walk(path.join(root, 'assets/media')).filter((file) => /\.(gif|png|jpe?g)$/i.test(file)).sort().map((file) => {
  const relative = rel(file);
  const normalized = relative.replaceAll('\\', '/');
  const references = sourceContents.filter((source) => source.text.includes(normalized)).map((source) => source.file);
  const extension = path.extname(file).slice(1).toUpperCase();
  return {
    name: path.basename(file), path: relative, type: extension,
    group: relative.split('/').slice(2, -1).join('/') || 'raiz',
    size: fs.statSync(file).size, references,
  };
});

fs.mkdirSync(docsDir, { recursive: true });

const overview = `# Documentação da Avalorium Wiki

> Inventário do estado atual, gerado em ${new Date().toISOString().slice(0, 10)}. Serve como mapa de migração para a reconstrução da wiki.

## Visão geral

- Implementação: site estático em HTML, CSS e JavaScript, publicado diretamente pelo GitHub Pages.
- Páginas HTML: **${pages.length}**.
- Entradas no menu e índice de busca: **${searchItems.length}**.
- Imagens catalogadas: **${assets.length}** (${assets.filter((a) => a.type === 'GIF').length} GIF, ${assets.filter((a) => a.type === 'PNG').length} PNG e ${assets.filter((a) => ['JPG', 'JPEG'].includes(a.type)).length} JPG).
- Assets referenciados no código: **${assets.filter((a) => a.references.length).length}**.
- Assets sem referência direta: **${assets.filter((a) => !a.references.length).length}**. Eles podem ser reserva, conteúdo futuro ou legado; não devem ser descartados sem revisão.

## Documentos

- [Arquitetura e comportamento](ARQUITETURA.md)
- [Menus e navegação](MENUS-E-NAVEGACAO.md)
- [Catálogo de todas as páginas](PAGINAS.md)
- [Inventário visual de imagens](ASSETS-VISUAIS.md)
- [Planilha completa de imagens](assets-visuais.csv)
- [Plano de reconstrução](PLANO-DE-RECONSTRUCAO.md)
- [Novo sistema visual premium](DESIGN-SYSTEM.md)

## Fontes de verdade atuais

- \`assets/js/wiki.js\`: monta os menus, controles interativos, lightbox, filtros e carrosséis.
- \`assets/js/search-index.js\`: índice pesquisável e metadados dos artigos publicados.
- \`assets/css/wiki.css\`: todo o tema visual e layout responsivo.
- Arquivos \`*.html\` na raiz: conteúdo e marcação de cada página.
- \`assets/media/\`: biblioteca visual.

## Regra de preservação

Antes da reconstrução, mantenha os slugs/URLs atuais ou crie redirecionamentos. Preserve também uma cópia integral de \`assets/media\`, pois **${assets.filter((a) => !a.references.length).length} arquivos não aparecem como referência literal no código atual** e podem conter material ainda útil.
`;

const architecture = `# Arquitetura e comportamento atual

## Estrutura global

Todas as páginas compartilham: barra superior, busca, indicador de jogadores online, atalhos externos, menu lateral desktop, drawer mobile, conteúdo central e rodapé. O menu é injetado por JavaScript; ele não está escrito integralmente em cada HTML.

## Componentes globais

| Componente | Função | Origem |
|---|---|---|
| Topbar | Logo, busca, online e atalhos externos | HTML de cada página + \`wiki.css\` |
| Menu lateral | Navegação desktop por seções expansíveis | Gerado por \`wiki.js\` |
| Drawer mobile | Versão móvel do menu e atalhos | HTML + conteúdo gerado por \`wiki.js\` |
| Busca | Consulta local sobre o índice estático | \`search.html\`, \`static-search.js\`, \`search-index.js\` |
| Contador online | Exibe total de jogadores | \`wiki.js\` + \`assets/data/online-count.json\` |
| Filtros de tabela | Oculta linhas conforme texto digitado | Atributos \`data-filter-*\` + \`wiki.js\` |
| Lightbox | Amplia imagens de artigos | Atributo \`data-image-lightbox\` + \`wiki.js\` |
| Carrossel | Slides com setas, dots e teclado | Atributos \`data-carousel-*\` + \`wiki.js\` |
| Rodapé | Marca, copyright e redes sociais | HTML repetido nas páginas |

## Atalhos externos globais

| Nome do ícone/ação | Destino | Representação atual |
|---|---|---|
| Abrir menu | Drawer mobile | SVG inline: três linhas (hambúrguer) |
| Buscar | \`search.html?q=...\` | SVG inline: lupa |
| Download | Site do Avalorium / downloads | SVG inline: seta para baixo |
| Discord | Servidor Discord | SVG inline: símbolo estilizado do Discord |
| Instagram | Perfil do Instagram | SVG inline: câmera |
| YouTube | Canal oficial do Avalorium OT | SVG inline: botão de reprodução |
| WhatsApp | Grupo do WhatsApp | SVG inline: balão/telefone |
| Donate | Página de doação | SVG inline: caixa/loja |
| Fechar | Fecha drawer ou lightbox | SVG inline: X |
| Anterior / próximo | Navegação em carrosséis | SVG inline: setas |

## Dados e automação

- \`scripts/update-online-count.mjs\` atualiza o JSON usado pelo contador online.
- \`assets/downloads/FabioRockeiroBOT.lua\` é um download oferecido pela página de scripts.
- Não há framework, bundler, banco de dados ou geração de páginas no estado atual.
- Cabeçalho, menu-base e rodapé são parcialmente repetidos em cada HTML; isso aumenta o custo de manutenção e deve ser componentizado na nova versão.

## Pontos de atenção já visíveis

- O menu e o índice de busca duplicam metadados; podem divergir.
- Há páginas existentes fora do menu e da busca.
- Há nomes de arquivo com espaços, acentos, apóstrofos e extensões duplicadas como \`.gif.gif\`; normalize durante a migração, mantendo um mapa de origem/destino.
- Existem textos com sinais de mojibake (por exemplo, caracteres UTF-8 interpretados incorretamente). Padronize tudo em UTF-8.
- Muitos SVGs de interface são repetidos inline em todos os HTMLs; consolide-os em um sistema de ícones/componentes.
`;

let menus = `# Menus e navegação

O menu lateral e o drawer mobile recebem as mesmas seções via \`assets/js/wiki.js\`. As entradas abaixo também constam no índice de busca.

`;
for (const [section, items] of menuSections) {
  menus += `## ${section} (${items.length})\n\n| Ícone/imagem | Página | URL | Descrição |\n|---|---|---|---|\n`;
  for (const item of items) menus += `| \`${esc(item.image)}\` | ${esc(decode(item.title))} | \`${item.url}\` | ${esc(decode(item.description))} |\n`;
  menus += '\n';
}
menus += `## Páginas que existem, mas não estão no menu/índice\n\n`;
const hidden = pages.filter((page) => !byUrl.has(page.file) && !['index.html', 'search.html'].includes(page.file));
menus += hidden.map((page) => `- \`${page.file}\` — ${page.title || page.h1} (${page.kind})`).join('\n') + '\n';

let pageDoc = `# Catálogo de páginas\n\nLegenda: “no menu/busca” indica artigo publicado na navegação gerada por JavaScript; “fora” indica conteúdo presente no repositório, porém não indexado ali.\n\n## Resumo\n\n| Arquivo | Página | Tipo | Categoria | Descrição | Imagens únicas |\n|---|---|---|---|---|---:|\n`;
for (const page of pages) pageDoc += `| \`${page.file}\` | ${esc(page.title || page.h1)} | ${page.kind} | ${esc(page.category)} | ${esc(page.description || 'Sem meta description')} | ${page.images.length} |\n`;
pageDoc += '\n## Conteúdo de cada página\n\n';
for (const page of pages) {
  pageDoc += `### ${page.title || page.h1} — \`${page.file}\`\n\n- **Papel atual:** ${page.kind}${page.category !== '—' ? `; categoria “${page.category}”` : ''}.\n- **Descrição:** ${page.description || 'Não há descrição explícita; revisar manualmente antes da migração.'}\n- **Seções:** ${page.headings.length ? page.headings.map((h) => `${'#'.repeat(h.level)} ${h.text}`).join(' · ') : 'nenhum H1–H3 detectado'}.\n- **Imagens próprias/referenciadas:** ${page.images.length ? page.images.map((image) => `\`${image}\``).join(', ') : 'nenhuma tag de imagem própria; apenas estrutura global ou conteúdo dinâmico'}.\n\n`;
}

const groups = Map.groupBy(assets, (asset) => asset.group);
let assetDoc = `# Inventário visual\n\nEste inventário cobre todo arquivo GIF, PNG e JPG em \`assets/media\`. O nome funcional inicial é o próprio nome do arquivo; confirme nomes ambíguos no jogo antes de renomear. A planilha CSV contém uma linha por arquivo.\n\n## Resumo por pasta\n\n| Pasta/grupo | GIF | PNG | JPG | Total | Referenciados | Sem referência |\n|---|---:|---:|---:|---:|---:|---:|\n`;
for (const [group, items] of [...groups].sort(([a], [b]) => a.localeCompare(b))) {
  assetDoc += `| \`${esc(group)}\` | ${items.filter((a) => a.type === 'GIF').length} | ${items.filter((a) => a.type === 'PNG').length} | ${items.filter((a) => ['JPG', 'JPEG'].includes(a.type)).length} | ${items.length} | ${items.filter((a) => a.references.length).length} | ${items.filter((a) => !a.references.length).length} |\n`;
}
assetDoc += `\n## Catálogo completo\n\n| Nome do ícone/imagem | Tipo | Caminho | Uso detectado |\n|---|---|---|---|\n`;
for (const asset of assets) assetDoc += `| ${esc(asset.name)} | ${asset.type} | \`${esc(asset.path)}\` | ${asset.references.length ? asset.references.map((f) => `\`${f}\``).join(', ') : '**Sem referência literal**'} |\n`;

const rebuild = `# Plano de reconstrução\n\n## 1. Congelamento e preservação\n\n1. Criar uma tag/branch do estado atual.\n2. Guardar todo \`assets/media\`, inclusive os arquivos sem referência.\n3. Exportar e revisar este inventário com responsáveis pelo conteúdo do servidor.\n\n## 2. Modelo de conteúdo\n\nCriar uma fonte única por artigo com: ID, slug, título, descrição, categoria, ordem, status (rascunho/publicado/arquivado), imagem de menu, conteúdo, palavras-chave, última revisão e responsável. Gerar menu, busca e páginas dessa mesma fonte.\n\n## 3. Taxonomia sugerida\n\n- Novidades e Loja\n- Sistemas do Servidor\n- Guias e Utilidades\n- Hunts Custom\n- Itens e Equipamentos\n- Colecionáveis\n- Scripts Zerobot\n\nAntes de implementar, decidir quais páginas atualmente fora do menu serão publicadas, unificadas ou arquivadas.\n\n## 4. Biblioteca visual\n\n1. Definir nomes canônicos em kebab-case, sem espaços ou acentos.\n2. Criar mapa de renomeação para não quebrar URLs antigas.\n3. Separar: marca, UI, menu, artigos, itens, monstros, mapas, promoções e placeholders.\n4. Registrar para cada asset: nome exibido, categoria, página proprietária, texto alternativo, licença/origem e substituto na nova identidade.\n5. Converter formatos apenas após confirmar se a animação dos GIFs precisa ser preservada.\n\n## 5. Componentização\n\nCriar componentes únicos para cabeçalho, busca, indicador online, menu, breadcrumb, cards, tabelas, galeria/lightbox, carrossel e rodapé. Manter responsividade e acessibilidade por teclado.\n\n## 6. Migração e aceite\n\n- Migrar primeiro uma página representativa de cada tipo.\n- Validar links, imagens, busca, mobile e dados online.\n- Comparar cada página nova com \`PAGINAS.md\` e cada imagem com \`assets-visuais.csv\`.\n- Só remover legado depois de confirmar cobertura de URLs e conteúdo.\n`;

const csvCell = (value) => `"${String(value).replaceAll('"', '""')}"`;
const csv = ['nome,tipo,caminho,pasta,tamanho_bytes,status_referencia,referenciado_em', ...assets.map((asset) => [
  asset.name, asset.type, asset.path, asset.group, asset.size,
  asset.references.length ? 'referenciado' : 'sem referencia literal', asset.references.join('; '),
].map(csvCell).join(','))].join('\n');

for (const [file, content] of Object.entries({
  'README.md': overview, 'ARQUITETURA.md': architecture, 'MENUS-E-NAVEGACAO.md': menus,
  'PAGINAS.md': pageDoc, 'ASSETS-VISUAIS.md': assetDoc,
  'PLANO-DE-RECONSTRUCAO.md': rebuild, 'assets-visuais.csv': csv,
})) fs.writeFileSync(path.join(docsDir, file), `${content.trim()}\n`, 'utf8');

console.log(`Documentação gerada: ${pages.length} páginas e ${assets.length} imagens.`);
