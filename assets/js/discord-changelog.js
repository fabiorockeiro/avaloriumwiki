(function () {
    const tick = String.fromCharCode(96);
    const dateLabel = new Intl.DateTimeFormat('pt-BR', {
        day: '2-digit', month: 'long', year: 'numeric', timeZone: 'UTC',
    });
    const postedAtLabel = new Intl.DateTimeFormat('pt-BR', {
        day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit',
        timeZone: 'America/Cuiaba',
    });
    const localDateParts = new Intl.DateTimeFormat('en-US', {
        year: 'numeric', month: '2-digit', day: '2-digit', timeZone: 'America/Cuiaba',
    });

    function findClosing(text, marker, from) {
        let position = text.indexOf(marker, from);
        while (position !== -1) {
            let slashes = 0;
            for (let index = position - 1; text[index] === '\\'; index--) slashes++;
            if (slashes % 2 === 0) return position;
            position = text.indexOf(marker, position + marker.length);
        }
        return -1;
    }

    function appendInline(parent, text, depth = 0) {
        if (depth > 8) {
            parent.appendChild(document.createTextNode(text));
            return;
        }
        let buffer = '';
        const flush = () => {
            if (buffer) parent.appendChild(document.createTextNode(buffer));
            buffer = '';
        };

        for (let index = 0; index < text.length;) {
            const rest = text.slice(index);
            if (text[index] === '\\' && index + 1 < text.length
                && /[\\*_~|[\]()<>#]/.test(text[index + 1])) {
                buffer += text[index + 1];
                index += 2;
                continue;
            }

            const emoji = /^<(a?):([a-zA-Z0-9_]{2,32}):(\d{15,22})>/.exec(rest);
            if (emoji) {
                flush();
                const image = document.createElement('img');
                image.className = 'changelog-md-emoji';
                image.src = 'https://cdn.discordapp.com/emojis/' + emoji[3] + (emoji[1] ? '.gif' : '.png');
                image.alt = ':' + emoji[2] + ':';
                image.width = 20;
                image.height = 20;
                image.loading = 'lazy';
                image.decoding = 'async';
                image.addEventListener('error', () => {
                    image.replaceWith(document.createTextNode(image.alt));
                }, { once: true });
                parent.appendChild(image);
                index += emoji[0].length;
                continue;
            }

            const maskedLink = /^\[([^\]\n]{1,120})\]\((https?:\/\/[^\s)]+)\)/.exec(rest);
            const bareLink = !maskedLink && /^https?:\/\/[^\s<>]+/.exec(rest);
            if (maskedLink || bareLink) {
                const href = maskedLink ? maskedLink[2] : bareLink[0].replace(/[.,;!?]+$/, '');
                try {
                    const url = new URL(href);
                    if (url.protocol === 'https:' || url.protocol === 'http:') {
                        flush();
                        const link = document.createElement('a');
                        link.href = url.href;
                        link.target = '_blank';
                        link.rel = 'noopener noreferrer';
                        link.textContent = maskedLink ? maskedLink[1] : href;
                        parent.appendChild(link);
                        index += maskedLink ? maskedLink[0].length : href.length;
                        continue;
                    }
                } catch {
                    // Endereços inválidos permanecem como texto comum.
                }
            }

            if (text[index] === tick) {
                const close = findClosing(text, tick, index + 1);
                if (close > index + 1) {
                    flush();
                    const code = document.createElement('code');
                    code.textContent = text.slice(index + 1, close);
                    parent.appendChild(code);
                    index = close + 1;
                    continue;
                }
            }

            const marks = [
                ['***', 'strong', 'em'],
                ['**', 'strong'],
                ['__', 'u'],
                ['~~', 'del'],
                ['||', 'spoiler'],
                ['*', 'em'],
                ['_', 'em'],
            ];
            let formatted = false;
            for (const [marker, outer, inner] of marks) {
                if (!rest.startsWith(marker)) continue;
                const close = findClosing(text, marker, index + marker.length);
                if (close <= index + marker.length) continue;
                const value = text.slice(index + marker.length, close);
                if (!value.trim()) continue;
                flush();
                if (outer === 'spoiler') {
                    const spoiler = document.createElement('span');
                    spoiler.className = 'changelog-md-spoiler';
                    const reveal = document.createElement('button');
                    reveal.type = 'button';
                    reveal.textContent = 'Mostrar spoiler';
                    const content = document.createElement('span');
                    content.hidden = true;
                    appendInline(content, value, depth + 1);
                    reveal.addEventListener('click', () => {
                        content.hidden = false;
                        reveal.hidden = true;
                    });
                    spoiler.append(reveal, content);
                    parent.appendChild(spoiler);
                } else {
                    const element = document.createElement(outer);
                    const target = inner ? element.appendChild(document.createElement(inner)) : element;
                    appendInline(target, value, depth + 1);
                    parent.appendChild(element);
                }
                index = close + marker.length;
                formatted = true;
                break;
            }
            if (formatted) continue;

            buffer += text[index];
            index++;
        }
        flush();
    }

    function renderContent(source) {
        const content = document.createElement('div');
        content.className = 'changelog-md';
        const lines = String(source || '').replace(/\r\n?/g, '\n').split('\n');
        const isFence = (line) => line.trimStart().startsWith(tick.repeat(3));
        const heading = (line) => /^ {0,3}(#{1,3}) +(.+)$/.exec(line);
        const listItem = (line) => /^ {0,3}([-*•]|\d+\.) +(.+)$/.exec(line);
        const quote = (line) => /^ {0,3}> ?(.*)$/.exec(line);
        const isBlockStart = (line) => isFence(line) || heading(line)
            || listItem(line) || quote(line) || /^-# /.test(line);

        for (let index = 0; index < lines.length;) {
            const line = lines[index];
            if (!line.trim()) {
                index++;
                continue;
            }
            if (isFence(line)) {
                const codeLines = [];
                index++;
                while (index < lines.length && !isFence(lines[index])) codeLines.push(lines[index++]);
                if (index < lines.length) index++;
                const pre = document.createElement('pre');
                const code = document.createElement('code');
                code.textContent = codeLines.join('\n');
                pre.appendChild(code);
                content.appendChild(pre);
                continue;
            }

            const head = heading(line);
            if (head) {
                const element = document.createElement('h' + (Number(head[1].length) + 2));
                appendInline(element, head[2]);
                content.appendChild(element);
                index++;
                continue;
            }
            if (line.startsWith('-# ')) {
                const small = document.createElement('small');
                appendInline(small, line.slice(3));
                content.appendChild(small);
                index++;
                continue;
            }

            const firstItem = listItem(line);
            if (firstItem) {
                const ordered = /^\d/.test(firstItem[1]);
                const list = document.createElement(ordered ? 'ol' : 'ul');
                while (index < lines.length) {
                    const item = listItem(lines[index]);
                    if (!item || /^\d/.test(item[1]) !== ordered) break;
                    const li = document.createElement('li');
                    appendInline(li, item[2]);
                    list.appendChild(li);
                    index++;
                }
                content.appendChild(list);
                continue;
            }

            if (quote(line)) {
                const blockquote = document.createElement('blockquote');
                while (index < lines.length) {
                    const quoted = quote(lines[index]);
                    if (!quoted) break;
                    if (blockquote.hasChildNodes()) blockquote.appendChild(document.createElement('br'));
                    appendInline(blockquote, quoted[1]);
                    index++;
                }
                content.appendChild(blockquote);
                continue;
            }

            const paragraph = document.createElement('p');
            while (index < lines.length && lines[index].trim()
                && (index === 0 || !isBlockStart(lines[index]) || !paragraph.hasChildNodes())) {
                if (paragraph.hasChildNodes()) paragraph.appendChild(document.createElement('br'));
                appendInline(paragraph, lines[index].trim());
                index++;
                if (index < lines.length && isBlockStart(lines[index])) break;
            }
            content.appendChild(paragraph);
        }
        return content;
    }

    function getDay(message) {
        const timestamp = new Date(message.timestamp);
        let year;
        let month;
        let day;
        if (!Number.isNaN(timestamp.getTime())) {
            const parts = Object.fromEntries(localDateParts.formatToParts(timestamp)
                .filter((part) => part.type !== 'literal')
                .map((part) => [part.type, Number(part.value)]));
            ({ year, month, day } = parts);
        }
        const firstLine = String(message.content || '').split('\n', 1)[0];
        if (/changelog|atualizaç/i.test(firstLine)) {
            const found = /\b(\d{1,2})\/(\d{1,2})(?:\/(\d{4}))?\b/.exec(firstLine);
            if (found) {
                const nextDay = Number(found[1]);
                const nextMonth = Number(found[2]);
                let nextYear = found[3] ? Number(found[3]) : year;
                if (!found[3] && month === 12 && nextMonth === 1) nextYear++;
                if (!found[3] && month === 1 && nextMonth === 12) nextYear--;
                const candidate = new Date(Date.UTC(nextYear, nextMonth - 1, nextDay));
                if (candidate.getUTCFullYear() === nextYear
                    && candidate.getUTCMonth() + 1 === nextMonth
                    && candidate.getUTCDate() === nextDay) {
                    year = nextYear;
                    month = nextMonth;
                    day = nextDay;
                }
            }
        }
        if (!year || !month || !day) return { key: 'unknown', label: 'Sem data' };
        const date = new Date(Date.UTC(year, month - 1, day));
        return {
            key: [year, String(month).padStart(2, '0'), String(day).padStart(2, '0')].join('-'),
            label: dateLabel.format(date),
        };
    }

    function groupByDate(messages) {
        const groups = new Map();
        messages.forEach((message) => {
            const day = getDay(message);
            if (!groups.has(day.key)) groups.set(day.key, { ...day, messages: [] });
            groups.get(day.key).messages.push(message);
        });
        return [...groups.values()].sort((a, b) => b.key.localeCompare(a.key));
    }

    function renderEntry(message, channelUrl) {
        const article = document.createElement('article');
        article.className = 'changelog-widget-entry';
        const timestamp = new Date(message.timestamp);
        if (!Number.isNaN(timestamp.getTime())) {
            const time = document.createElement('time');
            time.dateTime = timestamp.toISOString();
            time.textContent = 'Publicado no Discord em ' + postedAtLabel.format(timestamp);
            article.appendChild(time);
        }
        if (message.title) {
            const title = document.createElement('h3');
            appendInline(title, String(message.title));
            article.appendChild(title);
        }
        if (message.content) article.appendChild(renderContent(message.content));
        if (Array.isArray(message.attachments)) {
            message.attachments.forEach((attachment) => {
                if (!/^https:\/\//.test(attachment.url || '')) return;
                const link = document.createElement('a');
                link.className = 'changelog-widget-attachment';
                link.href = attachment.url;
                link.target = '_blank';
                link.rel = 'noopener noreferrer';
                link.textContent = attachment.name || 'Ver anexo';
                article.appendChild(link);
            });
        }
        if (channelUrl && /^\d+$/.test(message.id || '')) {
            const link = document.createElement('a');
            link.className = 'changelog-widget-message-link';
            link.href = channelUrl + '/' + message.id;
            link.target = '_blank';
            link.rel = 'noopener noreferrer';
            link.textContent = 'Ver mensagem no Discord ↗';
            article.appendChild(link);
        }
        return article;
    }

    window.AvaloriumDiscordChangelog = Object.freeze({ groupByDate, renderEntry });
}());
