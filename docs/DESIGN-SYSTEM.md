# Avalorium Codex — sistema visual premium

## Conceito

A nova direção transforma a wiki em um **arquivo arcano de alta fantasia com precisão técnica**. O conteúdo do jogo continua sendo o protagonista, mas agora vive em uma interface editorial, densa e deliberada — não em uma coleção genérica de caixas arredondadas.

Três ideias orientam a linguagem:

1. **Codex:** tipografia Cinzel, títulos monumentais, dourado e ritmo de publicação editorial.
2. **Interface de RPG:** recortes diagonais, trilhos luminosos, ícones de itens e cores elementais.
3. **Arquivo técnico:** grid sutil, microtipografia em caixa alta, índices, diretórios e tabelas precisas.

## Princípios

- Cantos retos ou chanfrados; círculos ficam restritos a indicadores naturalmente circulares.
- Poucas superfícies, com hierarquia criada por luz, contraste, recortes e espaçamento.
- Azul-ciano representa energia e interação; dourado representa autoridade e navegação.
- Os GIFs e PNGs do jogo recebem molduras discretas e sombra própria, sem competir com o conteúdo.
- Animações são curtas e funcionais. `prefers-reduced-motion` desativa movimento não essencial.

## Tokens principais

| Token | Valor | Uso |
|---|---|---|
| Fundo | `#05070d` | Base noturna |
| Superfície | `#0d1320` | Conteúdo e painéis |
| Texto | `#f3f6fb` | Leitura principal |
| Ciano | `#43d9ff` | Energia, foco e progresso |
| Dourado | `#d7af61` | Navegação e prestígio |
| Dourado claro | `#ffe3a2` | Destaques importantes |
| Verde | `#68d7a0` | Estado online |
| Corte padrão | `18px` | Geometria dos painéis |

## Tipografia

- **Cinzel:** marca, títulos, cards, seções e elementos de lore.
- **Inter:** navegação, descrições, tabelas e interface.
- Microtextos usam caixa alta e tracking amplo para criar sensação de arquivo técnico.

## Componentes reconstruídos

- **Command bar:** topbar translúcida, busca central, status online e atalhos minimalistas.
- **Knowledge directory:** menu lateral linear, sem caixas independentes; seção ativa usa trilho ciano.
- **Heroes:** composição panorâmica chanfrada, grid técnico e título em escala editorial.
- **Cards:** módulos recortados com acentos alternados, sem bordas arredondadas.
- **Seções:** título com índice visual, linha de progressão e ícone destacado.
- **Tabelas:** cabeçalho técnico, linhas densas e leitura horizontal preservada.
- **Hunts:** herdam o sistema base, mas mantêm a cor elemental de cada área.
- **Galerias e lightbox:** moldura escura, recortes diagonais e foco visível.
- **Mobile:** drawer próprio, conteúdo em uma coluna e redução controlada da escala tipográfica.
- **Progresso de leitura:** linha de 2px no topo que acompanha a página.

## Arquivos responsáveis

- `assets/css/wiki.css`: tokens, componentes, responsividade e camada de compatibilidade do tema anterior.
- `assets/js/wiki.js`: identificação do tipo de página e progresso de leitura, além dos comportamentos existentes.

## Regras para evolução

1. Não introduzir `border-radius` em painéis ou cards; use a geometria chanfrada existente.
2. Não criar uma nova cor sem vinculá-la a uma função ou tema elemental.
3. Não duplicar SVG de interface em novos conteúdos; criar componente reutilizável na futura arquitetura.
4. Manter contraste, foco por teclado e alternativa a movimento.
5. Testar qualquer componente novo em 390px, 768px, 1024px e 1440px.
6. Preservar a legibilidade de tabelas extensas por rolagem horizontal, sem comprimir dados.
