# Avalorium Wiki

Versao estatica da Avalorium OT Wiki, pronta para GitHub Pages.

## Publicar no GitHub Pages

1. Crie um repositorio no GitHub chamado `avaloriumwiki`.
2. Envie esta pasta para o repositorio.
3. No GitHub, abra `Settings > Pages`.
4. Em `Build and deployment`, selecione `Deploy from a branch`.
5. Escolha a branch `main` e a pasta `/ (root)`.

Depois do deploy, a wiki ficara em uma URL parecida com:

`https://SEU_USUARIO.github.io/avaloriumwiki/`

## Desenvolvimento

Este projeto e estatico. Abra `index.html` ou use um servidor local simples para testar as buscas e links.

## Changelog do Discord

A janela de atualizações aparece em todas as páginas e lê `assets/data/changelog.json`. Ela abre na primeira visita abaixo do menu superior, à direita; ao minimizar, continua acessível pelo botão **Atualizações** ao lado de **Scripts Fabio Rockeiro**. No celular, o atalho fica na barra superior. A preferência de minimização fica salva no navegador. As mensagens são agrupadas pela data indicada no changelog (ou pela data da publicação) e o seletor mostra um dia por vez. O texto usa a formatação do Discord e exibe emojis personalizados. Ao abrir a wiki como arquivo local, a janela lê o JSON publicado no GitHub Pages. Enquanto não houver mensagens, ela oferece um link para o Discord.

Para sincronizar as mensagens do canal `#atualizações`:

1. Crie um aplicativo com bot no [Discord Developer Portal](https://discord.com/developers/applications) e adicione o bot ao servidor. Dê acesso ao canal com as permissões **View Channel** e **Read Message History**. Ative **Message Content Intent** nas configurações do bot para ler texto e embeds.
2. No repositório GitHub, configure o segredo de Actions `DISCORD_BOT_TOKEN` com o token do bot. Nunca coloque o token em arquivos da wiki.
3. Execute manualmente a Action **Update Discord changelog** uma vez. Depois disso, ela verificará novas mensagens a cada hora e publicará alterações no JSON quando houver novidades.

O canal já está configurado: `https://discord.com/channels/1379133420395036712/1494025735122452630`.

O webhook de entrada do Discord publica mensagens no canal, mas não lê o histórico dele; ele não é usado nesta integração. Se o URL do webhook tiver sido compartilhado publicamente, regenere ou exclua esse webhook nas configurações do canal.

## Identidade visual

A interface usa o sistema **Avalorium Codex**, uma direcao editorial de fantasia com geometria chanfrada, navegacao tecnica e componentes responsivos. As regras estao documentadas em `docs/DESIGN-SYSTEM.md`.

Para validar paginas, referencias locais e a integridade do CSS:

`node scripts/validate-wiki.mjs`
