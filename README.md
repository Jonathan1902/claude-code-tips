# Jonnies Tech Drops

Série de conteúdo em português sobre tecnologia aplicada ao mercado financeiro, publicada como slides interativos no GitHub Pages.

**Site ao vivo:** https://jonathan1902.github.io/claude-code-tips/

## Episódios criados

Drops publicados (visíveis na home) são controlados por `docs/published.json`. Os demais existem no repositório e são acessíveis pela URL direta.

### Claude Code
| # | Título |
|---|--------|
| 01 | Configure o CLAUDE.md |
| 02 | O que é o Claude Code |
| 03 | Tipos de modelos |
| 04 | Permissões e segurança |
| 05 | Diretório .claude |
| 06 | Sessões e projetos |
| 07 | Prompt engineering |
| 08 | Slash commands |
| 09 | Plan e auto-edit mode |
| 10 | Gestão da janela de contexto |
| 11 | Memória entre sessões |
| 12 | Hooks |
| 13 | Statusline |
| 14 | Skills |
| 15 | MCPs |
| 16 | Subagents |

## Como funciona

Site estático puro (HTML + CSS + JS), sem build step, sem dependências, sem pipeline de CI. Edite os arquivos em `docs/` e faça push para a branch `gh-pages` — o deploy acontece imediatamente.

Consulte o [CLAUDE.md](CLAUDE.md) para o guia completo de arquitetura, como criar novos episódios e o padrão visual dos slides.

## Estrutura rápida

```
docs/
├── index.html          ← Home com os cards das dicas publicadas
├── published.json      ← Controle de visibilidade: define quais drops aparecem na home
├── slide-base.css      ← Sistema de design compartilhado
├── deck-stage.js       ← Web component de navegação dos slides
├── mascot.svg          ← Mascote usado nas capas
└── claude-code/        ← Episódios por tema
```

## Contribuindo

Entre em contato: jonathancosta888@gmail.com
