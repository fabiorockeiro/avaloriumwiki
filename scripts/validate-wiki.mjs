import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const htmlFiles = fs.readdirSync(root).filter((file) => file.endsWith('.html')).sort();
const checkedFiles = [
    ...htmlFiles,
    'assets/css/wiki.css',
    'assets/js/wiki.js',
    'assets/js/search-index.js',
];
const missing = [];

for (const file of checkedFiles) {
    const source = fs.readFileSync(path.join(root, file), 'utf8');
    const references = [
        ...source.matchAll(/(?:src|href)=["']([^"'#?]+)["']/gi),
        ...source.matchAll(/(?:image|background)\s*:\s*["']([^"']+\.(?:png|gif|jpe?g))["']/gi),
        ...(file.endsWith('.css') ? source.matchAll(/url\(["']?([^"')?#]+)["']?\)/gi) : []),
    ].map((entry) => entry[1]);

    for (const reference of references) {
        if (/^(?:https?:|mailto:|data:)/i.test(reference) || reference.includes('${')) continue;
        const decoded = decodeURIComponent(reference).replaceAll('&amp;', '&');
        const target = file.endsWith('.css')
            ? path.resolve(path.dirname(path.join(root, file)), decoded)
            : path.resolve(root, decoded);
        if (!fs.existsSync(target)) missing.push(`${file} -> ${decoded}`);
    }
}

const css = fs.readFileSync(path.join(root, 'assets/css/wiki.css'), 'utf8');
const openBlocks = (css.match(/\{/g) || []).length;
const closeBlocks = (css.match(/\}/g) || []).length;
if (openBlocks !== closeBlocks) missing.push(`CSS desequilibrado: ${openBlocks} "{" e ${closeBlocks} "}"`);

if (missing.length) {
    console.error(`Falha de integridade (${missing.length}):\n${missing.join('\n')}`);
    process.exit(1);
}

console.log(`Wiki validada: ${htmlFiles.length} páginas, referências locais e blocos CSS íntegros.`);
