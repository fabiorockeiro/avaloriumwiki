# Avalorium · Winter Ice

Abra `index.html` desta pasta para ver a demonstração com o popup aberto. Não precisa instalar dependências, compilar ou executar um servidor. A página inicial da wiki permanece preservada.

## Arquitetura

- `packs-data.js`: catálogo dos itens e os seis pacotes; preços em reais, TC e pares `[item, quantidade]`.
- `popup.js`: API pública, criação do Shadow DOM, diálogo modal nativo, links e controle de movimento.
- `popup.css`: apresentação isolada, seis cores, bordas luminosas, neve, hover e responsividade.
- `assets/items/`: GIFs originais animados e PNGs alternativos para movimento reduzido. `sources.json` registra a origem. Outfit + Mount mostra os dois sprites na mesma recompensa.
- `assets/cards/`: seis recortes verticais de Fenrir usados como ambientação de baixa opacidade, um para cada tier.
- `assets/scene.webp`: arte local da wiki, com Fenrir; nenhuma imagem ou fonte remota.
- `index.html`: demonstração independente; não é necessário copiá-la para integrar.

A implementação usa um `<dialog>` na camada superior do navegador, dentro de Shadow DOM, para evitar colisões de seletores e z-index. O diálogo nativo mantém a navegação por teclado dentro do modal e deixa a página hospedeira inerte. Ao fechar, o componente restaura foco e os valores anteriores de `overflow`. Somente os namespaces `AvaloriumPacksData` e `AvaloriumPacks` são adicionados ao `window`.

## Incorporar

Copie a pasta inteira `winter-packs/` para seu site e coloque antes de `</body>`:

```html
<button type="button" id="ver-pacotes">Ver pacotes</button>
<script src="winter-packs/packs-data.js"></script>
<script src="winter-packs/popup.js"></script>
<script>
  document.querySelector('#ver-pacotes').addEventListener('click', () => {
    AvaloriumPacks.open();
  });
</script>
```

Os caminhos de CSS e imagens são resolvidos a partir de `popup.js`, mesmo quando a página hospedeira está em outro diretório. Carregue os dois scripts nessa ordem, sem `async`.

```js
await AvaloriumPacks.open(); // resolve depois de carregar o CSS
AvaloriumPacks.close();
console.log(AvaloriumPacks.isOpen);
```

Para abrir automaticamente, execute `AvaloriumPacks.open()` depois dos scripts. X, Escape e clique na área externa fecham o popup. Em produção, trate falhas de carregamento com `.catch(...)`, como na demonstração.

## Links para Donates

Cada card é um link HTML completo: nome, baú, itens, TC e preço levam à página oficial na mesma aba. O destino fica em `donateUrl`, dentro de `packs-data.js`, e atualmente abre a loja depois da autenticação.

## Editar e substituir ícones

Edite `packs-data.js`; os dados não estão misturados ao HTML dos cards. Para trocar uma imagem, substitua o GIF e o PNG de mesmo nome em `assets/items/`, ou altere `icon` para o novo arquivo. O GIF é exibido normalmente e o PNG é usado quando o visitante prefere movimento reduzido. Todos os itens solicitados possuem arte local.

## Responsividade e movimento

Acima de 1100 px, os seis cards ficam lado a lado. Em telas menores, os cards têm rolagem horizontal e atalhos por pacote. Em janelas baixas, o diálogo tem rolagem vertical para manter todas as recompensas legíveis. Não há redução de texto para forçar conteúdo em uma altura fixa.

Os GIFs preservam seus frames e tempos originais. Prey Wildcards e Drome Cube possuem apenas um frame na origem, então recebem movimento sutil por CSS. O Bag of Materials mantém seus 168 frames e recebe um filtro local que remove o fundo branco durante a renderização.

`prefers-reduced-motion` troca GIFs por PNGs e remove neve, bordas em movimento, flutuação, transições e ampliação. Fechar o popup ou ocultar a aba também pausa os efeitos. A fonte medieval é local e inclui sua licença OFL. Não há bibliotecas obrigatórias nem loops JavaScript de animação.
