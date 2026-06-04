import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';

const sourceUrl = 'https://avaloriumot.com/index.php/online';
const outputPath = resolve('assets/data/online-count.json');

function parseOnlineCount(html) {
  const match = html.match(/Players\s+Online:\s*(\d+)\s+Players\s+Online/i)
    || html.match(/(\d+)\s+Players\s+Online/i);

  if (!match) {
    throw new Error('Could not find "Players Online" count in source HTML.');
  }

  return Number(match[1]);
}

const response = await fetch(sourceUrl, {
  headers: {
    'user-agent': 'AvaloriumWikiOnlineCounter/1.0',
  },
});

if (!response.ok) {
  throw new Error(`Source returned HTTP ${response.status}`);
}

const html = await response.text();
const online = parseOnlineCount(html);

if (!Number.isFinite(online)) {
  throw new Error(`Invalid online count: ${online}`);
}

const payload = {
  online,
  source: sourceUrl,
  updatedAt: new Date().toISOString(),
};

await mkdir(dirname(outputPath), { recursive: true });
await writeFile(outputPath, `${JSON.stringify(payload, null, 2)}\n`);

console.log(`Updated online player count: ${online}`);
