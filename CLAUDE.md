# CLAUDE.md

> **Última atualização:** 2026-06-29

Este arquivo fornece orientações ao Claude Code (claude.ai/code) ao trabalhar neste repositório.

## Visão Geral do Projeto

Projeto de slides HTML estáticos para "Jonnies Tech Drops" — série de conteúdo em português sobre tecnologia para o mercado financeiro. O site é publicado no GitHub Pages a partir da pasta `docs/` na branch `gh-pages`.

Não há etapa de build, gerenciador de pacotes ou suite de testes. Todo o desenvolvimento é feito editando arquivos diretamente e visualizando no browser.

## Arquitetura

```
docs/
├── index.html          ← Página inicial — grade de cards com todos os episódios
├── published.json      ← Controle de visibilidade: lista os drops visíveis no index
├── slide-base.css      ← Sistema de design compartilhado para todos os decks
├── deck-stage.js       ← Web component que controla a navegação dos slides
├── mascot.svg          ← SVG do mascote usado nos slides de capa
└── claude-code/
    ├── 01-configure-o-claude-md.html
    ├── 02-o-que-e-claude-code.html
    ├── 03-tipos-de-modelos.html
    ├── 04-permissoes-e-seguranca.html
    ├── 05-diretorio-claude.html
    ├── 06-sessoes-e-projetos.html
    ├── 07-prompt-engineering.html
    ├── 08-slash-commands.html
    ├── 09-plan-e-auto-edit-mode.html
    ├── 10-gestao-da-janela-de-contexto.html
    ├── 11-memoria-entre-sessoes.html
    ├── 12-hooks.html
    ├── 13-statusline.html
    ├── 14-skills.html
    ├── 15-mcps.html
    └── 16-subagents.html
```

Temas futuros planejados: `aws/`, `machine-learning/`, `dados/`, `analytics/`.

**`docs/index.html`** — Página inicial. HTML simples (sem `deck-stage`) com grade de cards organizada por tema. Cada card linka para o arquivo do episódio. Para adicionar um novo episódio, insira um `<a class="card">` dentro do `<div class="card-grid">` do tema correspondente. Para um tema novo, adicione um bloco `<div class="section-label">` + `<div class="card-grid">` antes do `<footer>`. Todos os cards ficam no HTML; o script de publicação (`published.json`) controla quais aparecem.

**`docs/published.json`** — Controle de visibilidade do index. Lista os `href` dos drops que devem aparecer para o usuário, agrupados por tema. Um drop pode estar commitado e não listado aqui — ele existirá na URL direta mas não aparecerá na home. Para publicar um drop, adicione seu href ao array do tema correspondente. O `index.html` filtra os cards via `fetch()` no carregamento.

**`docs/slide-base.css`** — Fonte única de verdade para todos os design tokens (`:root`), classes de componentes, animações e o `.home-btn`. Todo arquivo de deck linka este CSS em vez de embutir seu próprio `<style>`. Para sobrescrever `--accent` em um tema não-laranja, adicione um `:root` de uma linha no arquivo do deck após o `<link>`.

**`docs/deck-stage.js`** — Web component auto-contido (`<deck-stage>`) com navegação por teclado (←/→, PgUp/PgDn, Espaço, Home/End, R para reiniciar, 1–9 para pular), navegação por toque, escala automática (letterbox), trilha de miniaturas, e pular/reordenar/duplicar/deletar slides via clique direito, e impressão em PDF. Slides são ocultados (não desmontados) entre navegações.

**`docs/mascot.svg`** — Gráfico de barras laranja usado nos slides de capa. Referencie como `<img src="../mascot.svg" alt="">` dentro de `.mascot-wrap`.

**`.claude/skills/new-tech-drop/SKILL.md`** — Skill para gerar novos episódios. Use `/new-tech-drop` ou peça ao Claude para criar um novo episódio.

**`.claude/skills/review-tech-drop/SKILL.md`** — Skill para revisar episódios existentes com foco em aprendizado adulto. Use `/review-tech-drop`.

**`.claude/hooks/validate-drop.sh`** — Hook `PostToolUse` que roda automaticamente após cada `Write` ou `Edit` em arquivos HTML de `docs/`. Valida invariantes estruturais (CSS linkado, script carregado, botão home, slide `CTA · Saiba Mais` presente, slide `CTA · Contribua` opcional — se presente deve vir depois do Saiba Mais, ausência de `<style>` inline extra). Grava log em `.claude/hooks/validate-drop.log` (ignorado pelo git).

**`TODO.md`** — Lista de tarefas local. Ignorada pelo git.

## Temas e Cores

| Tema              | Pasta               | Classe CSS home     | Cor accent |
|-------------------|---------------------|---------------------|------------|
| Claude Code       | `claude-code/`      | `theme-claude-code` | `#FF6200`  |
| AWS               | `aws/`              | `theme-aws`         | `#FF9900`  |
| Machine Learning  | `machine-learning/` | `theme-ml`          | `#FFFFFF`  |
| Dados             | `dados/`            | `theme-dados`       | `#38BDF8`  |
| Analytics         | `analytics/`        | `theme-analytics`   | `#94A3B8`  |

## Estrutura de um Arquivo de Deck

Cada arquivo de episódio é uma página HTML auto-contida. Cabeçalho mínimo:

```html
<link rel="stylesheet" href="../slide-base.css">
<script src="../deck-stage.js"></script>
```

Sequência típica de slides dentro de `<deck-stage width="1080" height="1080" no-rail>`:

1. **Capa** — cover com mascote, `series-label` no formato `"Tema · Categoria"` (sem números), título e subtítulo
2. **Slide de Dica** — bullets e `code-block` opcional
3. *(opcional)* **Bloco de Conceito** — até 4 slides de conteúdo (Definição, Comparação, Decisão, Recap)
4. **CTA · Saiba Mais** — links de recursos com subtítulo específico ao conteúdo do episódio
5. *(opcional)* **CTA · Contribua** — call-to-action fixo, sem variação entre episódios. Inclua em drops práticos; omita em drops mais conceituais.

Um `<a class="home-btn" href="../index.html">← Home</a>` fixo fica fora do `<deck-stage>`.

## Criando Slides

- Adicione slides como filhos `<section>` do `<deck-stage>`. **Não** defina `position`, `width` ou `height` em `<section>` — o componente gerencia isso.
- Classes disponíveis (todas em `slide-base.css`): `.slide-header`, `.brand`, `.tag`, `.tag-dot`, `.bullets`, `.bullet-dot`, `.code-block`, `.divider`, `.subtitle`, `.tip-title`, `.resource-list`, `.resource-card`, `.resource-title`, `.resource-url`, `.resource-url--plain`, `.contribute-body`, `.contribute-box`, `.visual-placeholder`.
- O canvas de design é 1080×1080 px. Tamanhos de fonte e espaçamentos vêm de custom properties CSS em `:root`.
- Animações de entrada são condicionadas em `[data-deck-active]` + `@media (prefers-reduced-motion: no-preference)`. O estilo base é o estado final visível para impressão e reduced-motion mostrarem o conteúdo corretamente.
- Footer padrão dos slides: `<div style="margin-top: auto; padding-top: 32px;"><div class="divider" style="width: 100%;"></div></div>`
- O footer do slide Contribua usa `flex-shrink: 0` (o conteúdo preenche o espaço acima).
- Use `.resource-url--plain` em vez de `.resource-url` quando o texto é uma descrição, não uma URL (evita estilo laranja monoespaçado).
- Use `.visual-placeholder` para indicar onde uma imagem, gráfico, diagrama ou ícone deve ser inserido posteriormente.
- Para pular um slide da navegação e da impressão, adicione `data-deck-skip` ao `<section>`.

## Deploy

O site é servido pelo GitHub Pages na pasta `docs/` na branch `gh-pages`. Push para `gh-pages` faz deploy imediato — sem pipeline de CI.
