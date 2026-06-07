# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static HTML slide deck project for "Finance Tech Drops" — a Brazilian Portuguese content series about technology tips for the financial market. The site is published to GitHub Pages from the `docs/` folder on the `gh-pages` branch.

There is no build step, package manager, or test suite. All development is done by editing files directly and previewing in a browser.

## Architecture

```
docs/
├── index.html          ← Home page — card grid linking to all tips
├── slide-base.css      ← Shared design system for all deck files
├── deck-stage.js       ← Web component powering slide navigation
├── mascot.svg          ← Shared mascot SVG used in cover slides
├── claude-code/
│   ├── 01-configure-o-claude-md.html
│   └── 02-o-que-e-claude-code.html
├── aws/                ← (future)
├── machine-learning/   ← (future)
├── dados/              ← (future)
└── analytics/          ← (future)
```

**`docs/index.html`** — Home page. A regular HTML page (no `deck-stage`) with a card grid organized by theme. Each card links to its tip file. To add a new tip, add a `<a class="card">` inside the appropriate `<div class="card-grid">`. To add a new theme, add a `<div class="section-label">` + `<div class="card-grid">` block before the footer.

**`docs/slide-base.css`** — Single source of truth for all design tokens (`:root`), component classes, animations, and the `.home-btn`. Every deck file links this instead of embedding its own `<style>` block. To override `--accent` for a non-orange theme, add a one-line `:root` override in the deck file after the `<link>`.

**`docs/deck-stage.js`** — Self-contained web component (`<deck-stage>`) handling keyboard navigation (←/→, PgUp/PgDn, Space, Home/End, R to reset, 1–9 to jump), touch navigation, auto-scaling (letterboxed), thumbnail rail, slide skip/reorder/duplicate/delete via right-click, and print-to-PDF. Slides are hidden (not unmounted) between navigation.

**`docs/mascot.svg`** — The three-bar orange chart graphic used in cover slides. Reference as `<img src="../mascot.svg" alt="">` inside `.mascot-wrap`.

**`.claude/skills/new-tech-drop/SKILL.md`** — Project skill for generating new episodes. Invoke with `/new-tech-drop` or ask Claude to create a new tip/drop.

**`TODO.md`** — Local task list. Ignored by git.

## Themes and Colours

| Theme            | Folder             | CSS class          | Accent colour |
|------------------|--------------------|--------------------|---------------|
| Claude Code      | `claude-code/`     | `theme-claude-code`| `#FF6200`     |
| AWS              | `aws/`             | `theme-aws`        | `#FF9900`     |
| Machine Learning | `machine-learning/`| `theme-ml`         | `#FFFFFF`     |
| Dados            | `dados/`           | `theme-dados`      | `#38BDF8`     |
| Analytics        | `analytics/`       | `theme-analytics`  | `#94A3B8`     |

## Deck File Structure

Each tip file is a self-contained HTML page. Minimal head:

```html
<link rel="stylesheet" href="../slide-base.css">
<script src="../deck-stage.js"></script>
```

Typical slide sequence inside `<deck-stage width="1080" height="1080" no-rail>`:

1. **Capa** — cover with mascot, `series-label`, title, subtitle
2. **Dica #XX** — tip slide with bullets and optional `code-block`
3. *(optional)* **Concept block** — 4 content slides (Definição, Comparação, Decisão, Recap)
4. **CTA · Saiba Mais** — resource links
5. **CTA · Contribua** — call-to-action

A fixed `<a class="home-btn" href="../index.html">← Home</a>` sits outside `<deck-stage>`.

## Authoring Slides

- Add slides as `<section>` children of `<deck-stage>`. Do **not** set `position`, `width`, or `height` on `<section>` — the component manages that.
- Available classes (all in `slide-base.css`): `.slide-header`, `.brand`, `.tag`, `.tag-dot`, `.bullets`, `.bullet-dot`, `.code-block`, `.divider`, `.subtitle`, `.tip-title`, `.resource-list`, `.resource-card`, `.resource-title`, `.resource-url`, `.resource-url--plain`, `.contribute-body`, `.contribute-box`.
- Design canvas is 1080×1080 px. Type sizes and spacing come from CSS custom properties in `:root`.
- Entrance animations are gated on `[data-deck-active]` + `@media (prefers-reduced-motion: no-preference)`. The base style is the visible end-state so print and reduced-motion show content correctly.
- Slide footers use a plain divider: `<div style="margin-top: auto; padding-top: 32px;"><div class="divider" style="width: 100%;"></div></div>`
- The Contribua CTA footer uses `flex-shrink: 0` instead (content fills available space above it).
- Use `.resource-url--plain` instead of `.resource-url` when the text is a description, not a URL (avoids orange monospace styling).
- To skip a slide from navigation and print, add `data-deck-skip` to its `<section>`.

## Deployment

The site is served from GitHub Pages at the `docs/` directory on the `gh-pages` branch. Pushing to `gh-pages` deploys immediately — no CI pipeline.
