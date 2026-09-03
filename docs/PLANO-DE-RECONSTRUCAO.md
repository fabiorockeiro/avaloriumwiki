# Plano de reconstrução

## 1. Congelamento e preservação

1. Criar uma tag/branch do estado atual.
2. Guardar todo `assets/media`, inclusive os arquivos sem referência.
3. Exportar e revisar este inventário com responsáveis pelo conteúdo do servidor.

## 2. Modelo de conteúdo

Criar uma fonte única por artigo com: ID, slug, título, descrição, categoria, ordem, status (rascunho/publicado/arquivado), imagem de menu, conteúdo, palavras-chave, última revisão e responsável. Gerar menu, busca e páginas dessa mesma fonte.

## 3. Taxonomia sugerida

- Novidades e Loja
- Sistemas do Servidor
- Guias e Utilidades
- Hunts Custom
- Itens e Equipamentos
- Colecionáveis
- Scripts Zerobot

Antes de implementar, decidir quais páginas atualmente fora do menu serão publicadas, unificadas ou arquivadas.

## 4. Biblioteca visual

1. Definir nomes canônicos em kebab-case, sem espaços ou acentos.
2. Criar mapa de renomeação para não quebrar URLs antigas.
3. Separar: marca, UI, menu, artigos, itens, monstros, mapas, promoções e placeholders.
4. Registrar para cada asset: nome exibido, categoria, página proprietária, texto alternativo, licença/origem e substituto na nova identidade.
5. Converter formatos apenas após confirmar se a animação dos GIFs precisa ser preservada.

## 5. Componentização

Criar componentes únicos para cabeçalho, busca, indicador online, menu, breadcrumb, cards, tabelas, galeria/lightbox, carrossel e rodapé. Manter responsividade e acessibilidade por teclado.

## 6. Migração e aceite

- Migrar primeiro uma página representativa de cada tipo.
- Validar links, imagens, busca, mobile e dados online.
- Comparar cada página nova com `PAGINAS.md` e cada imagem com `assets-visuais.csv`.
- Só remover legado depois de confirmar cobertura de URLs e conteúdo.
