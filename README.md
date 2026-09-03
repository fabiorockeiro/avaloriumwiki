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

## Identidade visual

A interface usa o sistema **Avalorium Codex**, uma direcao editorial de fantasia com geometria chanfrada, navegacao tecnica e componentes responsivos. As regras estao documentadas em `docs/DESIGN-SYSTEM.md`.

Para validar paginas, referencias locais e a integridade do CSS:

`node scripts/validate-wiki.mjs`
