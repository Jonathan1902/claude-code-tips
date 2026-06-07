# Jonnies Tech Drops

Série de conteúdo em português sobre tecnologia aplicada ao mercado financeiro, publicada como slides interativos no GitHub Pages.

**Site ao vivo:** https://jonathan1902.github.io/claude-code-tips/

## Como funciona

Site estático puro (HTML + CSS + JS), sem build step, sem dependências, sem pipeline de CI. Edite os arquivos em `docs/` e faça push para a branch `gh-pages` — o deploy acontece imediatamente.

Consulte o [CLAUDE.md](CLAUDE.md) para o guia completo de arquitetura, como criar novos episódios e o padrão visual dos slides.

## Estrutura rápida

```
docs/
├── index.html          ← Home com os cards de todas as dicas
├── slide-base.css      ← Sistema de design compartilhado
├── deck-stage.js       ← Web component de navegação dos slides
├── mascot.svg          ← Mascote usado nas capas
└── claude-code/        ← Episódios por tema
```

## Contribuindo

Entre em contato: jonathancosta888@gmail.com
