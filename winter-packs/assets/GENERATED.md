# Arte e preparação dos arquivos

Ferramenta: `image_gen` integrada (não foi usada API/CLI alternativa).

## Baú — `chest.webp`

Prompt utilizado:

> Create one isolated premium fantasy MMORPG treasure chest icon for a Tibia-inspired winter shop UI. A beautiful open medieval treasure chest, three-quarter front view, filled with coins and faceted crystals. Entire material palette monochromatic gold and amber so the UI can recolor it with hue rotation. Strong crisp silhouette, intricate ornate metal bands, stylized hand-painted game inventory art with sharp details readable at 140px, not photorealistic. Actual transparent background with alpha, no scene, no ground, no text, no frame, no extra objects outside chest. Chest fills 85% of square canvas, centered. Restrained golden glints, no large glow outside silhouette. Single chest only.

PNG gerado convertido para WebP de 400 px, preservando transparência. As seis cores são aplicadas na apresentação por filtros CSS.

## Bag of Materials — `items/bag-of-materials.png`

Alvo: primeiro frame do GIF fornecido. Prompt utilizado:

> Edit target: the supplied Tibia Bag of Materials inventory sprite. Remove ONLY its white background, replacing it with real transparent alpha. Preserve precisely the same pixel-art bags, contents, colors, proportions and silhouette. Do not add shadows, glows, ground, checkerboard or any objects. Output a transparent PNG sprite suitable for rendering at 32px in a game inventory. Save the image as a local project asset if possible.

O resultado transparente foi dimensionado para 64 px e é usado no modo de movimento reduzido. Na apresentação normal, o GIF original mantém todos os 168 frames, redimensionados para 64 px; o filtro SVG `av-remove-white` remove o branco na renderização. Assim a edição estática não substitui a animação original.

## Outros arquivos

Os demais GIFs foram copiados dos sprites fornecidos ou da wiki. Os PNGs correspondentes oferecem o fallback acessível. A logo oficial foi apenas dimensionada e convertida para WebP com alpha, sem redesenho.

## Fundos dos cards — `cards/*.webp`

Ferramenta: `image_gen` integrada, usando a segunda imagem anexada pelo usuário como alvo de edição. Prompt utilizado:

> Use case: precise-object-edit. Asset type: six-card MMORPG shop background strip. Image 1 is the edit target, the supplied six-panel Fenrir fantasy artwork (orange ruins, moonlit ice castle, gold citadel, cyan ice mountain, purple void crystal, red blood moon). Cleanly crop the supplied artwork into one seamless horizontal strip containing the same six vertical panels in the same left-to-right order and equal widths. Remove only any outer screenshot margins or unintended padding if present. Exact 6:1 horizontal strip, six equal vertical panels, each wolf centered in its panel and suitable for background-position cropping into six separate cards. Preserve the original artwork, characters, scenery, colors, panel order and fantasy style; no redesign; no extra objects; no text; no logos; no watermark; no UI; no card labels. The boundaries between panels should remain crisp. Output an opaque high-resolution raster background.

O resultado integral está em `fenrir-card-strip.png`. Ele foi dividido mecanicamente em seis recortes WebP de 362 × 724 px, sem nova alteração visual: `bronze.webp`, `prata.webp`, `ouro.webp`, `platina.webp`, `diamante.webp` e `rubi.webp`. O CSS aplica cada recorte com baixa opacidade e uma máscara escura para preservar a leitura dos itens.
