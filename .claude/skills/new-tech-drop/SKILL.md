---
name: new-tech-drop
description: >
  Generates a complete HTML file for a new Finance Tech Drops episode: one Tip slide + a 5-slide Concept block (cover, definition, comparison, decision, recap), following the exact design system and file structure of the project. Use this skill whenever the user asks to create a new tip, a new drop, a new episode, or wants to add content — even if they just say "quero criar a dica #X" or "novo drop sobre Y".
---

# new-tech-drop

Gera o arquivo HTML completo de um novo episódio Finance Tech Drops e o card correspondente para a home.

## Estrutura do projeto

```
docs/
├── index.html                          ← Home (lista de dicas)
├── deck-stage.js
├── claude-code/
│   └── 01-configure-o-claude-md.html  ← exemplo de referência
├── aws/
├── machine-learning/
├── python/
└── analytics/
```

Cada dica fica em `docs/<tema>/<número>-<slug>.html`. Temas disponíveis e suas cores CSS:

| Tema              | Pasta            | Classe CSS home       | Cor accent no deck |
|-------------------|------------------|-----------------------|--------------------|
| Claude Code       | `claude-code/`   | `theme-claude-code`   | `#FF6200`          |
| AWS               | `aws/`           | `theme-aws`           | `#FF9900`          |
| Machine Learning  | `machine-learning/` | `theme-ml`         | `#FFFFFF`          |
| Dados             | `dados/`         | `theme-dados`         | `#38BDF8`          |
| Analytics         | `analytics/`     | `theme-analytics`     | `#94A3B8`          |

## Passo 1 — Coletar o conteúdo

Pergunte ao usuário (tudo de uma vez):

**Metadados:**
- Tema (Claude Code / AWS / Machine Learning / Python / Analytics)
- Número da dica (ex.: `#02`) e slug para o nome do arquivo (ex.: `use-subagentes`)
- Cor accent do tema (use a tabela acima)

**Slide de Dica:**
- Título (máx. 55 chars)
- Subtítulo (máx. 70 chars)
- 3–4 bullets (frases curtas, imperativas ou afirmativas, máx. 90 chars cada)
- Bloco de código opcional (conteúdo exato — preserve espaços e quebras de linha)

**Bloco de Conceito (5 slides):**
- Título do conceito e subtítulo da capa
- Série / label (ex.: "Contexto · Fundamentos")
- CC-02 Definição: título + frase-âncora para code-block + 3 bullets
- CC-03 Comparação: título + subtítulo + 3 resource-cards (label + descrição)
- CC-04 Decisão: título + 2 bullets "Resolve" + 2 bullets "Não resolve"
- CC-05 Recap: título + subtítulo + 3 frases de fechamento

**Card para a home:**
- Descrição curta (1–2 frases para exibir no card da home, máx. 120 chars)

## Passo 2 — Gerar o arquivo da dica

Crie `docs/<tema>/<número>-<slug>.html` copiando a estrutura de
`docs/claude-code/01-configure-o-claude-md.html` como referência e substituindo:

- `../deck-stage.js` — caminho relativo correto para qualquer subpasta de `docs/`
- `../index.html` — link do botão `← Home`
- Cor `--accent` no `:root` com a cor do tema
- Todas as ocorrências de `<span>Claude Code</span>` nas tags → nome do tema
- Conteúdo de cada slide conforme coletado no Passo 1

### Regras dos slides

**Tag de tema** — todas as tags usam o nome do tema (ex.: "AWS"), nunca "Conceito 00":
```html
<div class="tag"><span class="tag-dot"></span><span>NOME DO TEMA</span></div>
```

**Slide de Dica** — inclua `<div class="code-block">` apenas se houver código. Se não houver,
remova o `style="margin-bottom: var(--gap-section);"` da `<ul>`.

**Slides de Conceito** — a `series-label` da capa do conceito deve usar o contexto, ex.:
`"Contexto · Fundamentos"` ou `"Contexto · AWS Básico"`.

**Bullets "Não resolve"** (CC-04) — use `background: var(--text-muted)` no dot e
`color: var(--text-muted)` no texto para diferenciar visualmente.

**CTA toggle** — mantenha o script `setCTA()` inline no final do arquivo. O padrão é
`setCTA('contribua')`. O slide "Saiba Mais" começa com `data-deck-skip`.

**Footer de slides** — sempre use o padrão sem texto de handle:
```html
<div style="margin-top: auto; padding-top: 32px;">
  <div class="divider" style="width: 100%;"></div>
</div>
```

**Animações** — gateadas em `[data-deck-active]` + `@media (prefers-reduced-motion: no-preference)`.
O estado base é o end-state visível (correto para print e motion-off).

## Passo 3 — Gerar o card para a home

Forneça o bloco HTML do card para o usuário adicionar em `docs/index.html`:

```html
<a class="card" href="<tema>/<número>-<slug>.html">
  <div class="card-theme theme-<classe-css>">
    <span class="card-theme-dot"></span>
    NOME DO TEMA
  </div>
  <div class="card-number">Dica #XX</div>
  <div class="card-title">TÍTULO DA DICA</div>
  <div class="card-desc">DESCRIÇÃO CURTA</div>
  <span class="card-arrow">→</span>
</a>
```

Se for o primeiro card de um tema novo, envolva com:
```html
<div class="section-label">NOME DO TEMA</div>
<div class="card-grid">
  <!-- card aqui -->
</div>
```

Oriente o usuário a inserir esse bloco em `docs/index.html` antes do `<footer>`.

## Notas de estilo

- Títulos: sem ponto final, máx. 55 chars
- Subtítulos: frase única, tom conversacional, máx. 70 chars
- O SVG de mascote é padrão — use sempre o mesmo para consistência visual
- Não adicione classes novas nem estilos inline além dos já presentes no arquivo de referência
