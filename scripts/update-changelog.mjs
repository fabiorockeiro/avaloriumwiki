import { readFile, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';

const token = process.env.DISCORD_BOT_TOKEN;
const channelId = '1494025735122452630';
const outputPath = resolve('assets/data/changelog.json');

if (!token) throw new Error('Configure DISCORD_BOT_TOKEN como segredo do repositório.');
async function discordGet(path) {
  const response = await fetch(`https://discord.com/api/v10${path}`, {
    headers: {
      Authorization: `Bot ${token}`,
      'User-Agent': 'AvaloriumWikiChangelog/1.0',
    },
  });
  if (!response.ok) throw new Error(`Discord retornou HTTP ${response.status} para ${path}.`);
  return response.json();
}

const channel = await discordGet(`/channels/${channelId}`);
if (!/^\d+$/.test(channel.guild_id || '')) {
  throw new Error('O canal precisa pertencer a um servidor do Discord.');
}

const rawMessages = await discordGet(`/channels/${channelId}/messages?limit=20`);
if (!Array.isArray(rawMessages)) throw new Error('Resposta inesperada ao ler mensagens do Discord.');

const messages = rawMessages.map((message) => {
  const embeds = Array.isArray(message.embeds) ? message.embeds : [];
  const title = embeds.map((embed) => embed.title).filter(Boolean).join(' · ');
  const description = embeds.map((embed) => [
    embed.description,
    ...(Array.isArray(embed.fields) ? embed.fields.map((field) => `${field.name}: ${field.value}`) : []),
  ].filter(Boolean).join('\n')).filter(Boolean).join('\n\n');
  const content = [message.content, description].filter(Boolean).join('\n\n');
  const attachments = (Array.isArray(message.attachments) ? message.attachments : [])
    .filter((attachment) => /^https:\/\//.test(attachment.url || ''))
    .map((attachment) => ({ name: attachment.filename || 'Anexo', url: attachment.url }));

  return {
    id: message.id,
    timestamp: message.timestamp,
    title,
    content,
    attachments,
  };
}).filter((message) => message.title || message.content || message.attachments.length).slice(0, 12);

if (rawMessages.length && !messages.length) {
  throw new Error('As mensagens vieram sem conteúdo. Ative Message Content Intent para o bot no Discord Developer Portal.');
}

const payload = {
  channelUrl: `https://discord.com/channels/${channel.guild_id}/${channelId}`,
  messages,
};

let previous;
try {
  previous = JSON.parse(await readFile(outputPath, 'utf8'));
} catch {
  previous = null;
}

if (JSON.stringify(previous) === JSON.stringify(payload)) {
  console.log('Changelog sem alterações.');
} else {
  await writeFile(outputPath, `${JSON.stringify(payload, null, 2)}\n`);
  console.log(`Changelog atualizado: ${messages.length} mensagens.`);
}
