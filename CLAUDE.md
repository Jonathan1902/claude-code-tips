# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static HTML slide deck project for "Finance Tech Drops" — a Brazilian Portuguese content series about Claude Code tips. The deck is published to GitHub Pages from the `docs/` folder on the `gh-pages` branch.

There is no build step, package manager, or test suite. All development is done by editing files directly and previewing in a browser.

## Architecture

The project has two files:

- **`docs/deck-stage.js`** — A self-contained web component (`<deck-stage>`) that handles all slide presentation logic: keyboard navigation (←/→, PgUp/PgDn, Space, Home/End, R to reset, 1–9 to jump), touch tap navigation, auto-scaling to fit the viewport (letterboxed), a resizable thumbnail rail on the left, slide skip/reorder/duplicate/delete via right-click context menu, print-to-PDF support (one slide per page), and speaker notes via `postMessage`. Slides are hidden (not unmounted) between navigation, preserving state like React trees and iframes.

- **`docs/index.html`** — The slide content. Slides are `<section>` elements inside `<deck-stage width="1080" height="1080" no-rail>`. CSS design tokens are defined in `:root` and shared across all slides. A React + Babel inline script powers a "Tweaks" panel that toggles which CTA slide is shown by setting `data-deck-skip` on sections.

## Authoring Slides

- Add slides as `<section>` children of `<deck-stage>`. Do **not** set `position`, `width`, or `height` on `<section>` — the component manages that.
- Use the existing CSS classes: `.slide-header`, `.brand`, `.tag`, `.bullets`, `.code-block`, `.divider`, `.subtitle`.
- Design canvas is 1080×1080 px. All type sizes and spacing use the CSS custom properties in `:root`.
- Entrance animations must be gated on `[data-deck-active]` and `@media (prefers-reduced-motion: no-preference)` — the base style is the visible end-state, animated *from* hidden, so print and reduced-motion show content correctly.
- To skip a slide from navigation and print, add `data-deck-skip` to its `<section>`.

## Deployment

The site is served from GitHub Pages at the `docs/` directory on the `gh-pages` branch. Pushing to `gh-pages` deploys immediately — no CI pipeline.
