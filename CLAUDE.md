# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static HTML slide deck project for "Finance Tech Drops" — a Brazilian Portuguese content series about Claude Code tips. The deck is published to GitHub Pages from the `docs/` folder on the `gh-pages` branch.

There is no build step, package manager, or test suite. All development is done by editing files directly and previewing in a browser.

## Architecture

The project has two files:

- **`docs/deck-stage.js`** — A self-contained web component (`<deck-stage>`) that handles all slide presentation logic: keyboard navigation (←/→, PgUp/PgDn, Space, Home/End, R to reset, 1–9 to jump), touch tap navigation, auto-scaling to fit the viewport (letterboxed), a resizable thumbnail rail on the left, slide skip/reorder/duplicate/delete via right-click context menu, print-to-PDF support (one slide per page), and speaker notes via `postMessage`. Slides are hidden (not unmounted) between navigation, preserving state like React trees and iframes.

- **`docs/index.html`** — The slide content. Slides are `<section>` elements inside `<deck-stage width="1080" height="1080" no-rail>`. CSS design tokens are defined in `:root` and shared across all slides. A React + Babel inline script powers a "Tweaks" panel that toggles which CTA slide is shown by setting `data-deck-skip` on sections.

- **`TODO.md`** — Local task list tracking the 19 concepts planned for the series. Ignored by git (listed in `.gitignore`).

## Slide Structure

The deck currently has 9 slides in this order:

| Index | Label | Type |
|-------|-------|------|
| 0 | Capa | Cover |
| 1 | Dica #01 — Configure o CLAUDE.md | Tip |
| 2 | CC-01 · Capa do conceito 00 | Concept cover |
| 3 | CC-02 · Definição | Concept |
| 4 | CC-03 · Comparação | Concept |
| 5 | CC-04 · Decisão | Concept |
| 6 | CC-05 · Recap | Concept |
| 7 | Saiba Mais (CTA) | CTA — toggled by Tweaks |
| 8 | Contribua (CTA) | CTA — toggled by Tweaks |

The Tweaks panel (React script at the bottom of `index.html`) toggles `data-deck-skip` on indices 7 and 8 to show only one CTA at a time. **If you add or remove slides before index 7, update those indices in the `applySkip` function.**

## Authoring Slides

- Add slides as `<section>` children of `<deck-stage>`. Do **not** set `position`, `width`, or `height` on `<section>` — the component manages that.
- Use the existing CSS classes: `.slide-header`, `.brand`, `.tag`, `.bullets`, `.code-block`, `.divider`, `.subtitle`.
- Design canvas is 1080×1080 px. All type sizes and spacing use the CSS custom properties in `:root`.
- Entrance animations must be gated on `[data-deck-active]` and `@media (prefers-reduced-motion: no-preference)` — the base style is the visible end-state, animated *from* hidden, so print and reduced-motion show content correctly.
- To skip a slide from navigation and print, add `data-deck-skip` to its `<section>`.
- Slide footers use a plain divider only — no handle text. Match the cover footer pattern: `<div style="margin-top: auto; padding-top: 32px;"><div class="divider" style="width: 100%;"></div></div>`

## Deployment

The site is served from GitHub Pages at the `docs/` directory on the `gh-pages` branch. Pushing to `gh-pages` deploys immediately — no CI pipeline.
