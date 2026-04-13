# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo static site using the [Hextra](https://github.com/imfing/hextra) theme, managed as a Go module. It deploys automatically to GitHub Pages on pushes to `main`.

## Local Development

The preferred dev environment is Docker. Versions for Go, Hugo (extended), and Node are defined in `.env` and consumed by both Docker and CI.

```shell
# Start the dev server via Docker (recommended)
docker compose up

# Or run directly (requires Hugo extended, Go, and Git installed)
hugo mod tidy
hugo server --logLevel debug --disableFastRender -p 1313
```

The site is served at `http://localhost:1313`.

## Build

```shell
# Production build (output to ./public)
hugo --gc --minify
```

## Update Hugo Theme

```shell
hugo mod get -u
hugo mod tidy
```

## Architecture

- **`hugo.yaml`** — main Hugo config: site title, Hextra module import, nav menu, and theme params.
- **`content/`** — all Markdown content. `_index.md` files define section landing pages; leaf pages are standalone `.md` files. Hextra shortcodes (e.g. `{{< cards >}}`) are used for layout components.
- **`layouts/`** — local Hugo template overrides:
  - `layouts/blog/list.html` — custom blog listing that uses `.RegularPagesRecursive.ByDate.Reverse` so posts nested under `posts/YYYY/MM/` are collected and sorted correctly.
  - `layouts/partials/custom/head-end.html` — Hextra extension point injected into every page's `<head>`; currently loads KaTeX for LaTeX math rendering.
- **`static/images/`** — static assets (profile photo, certification badges, logos). Hugo copies these into `public/images/` at build time. **Do not put images only in `public/`** — that directory is wiped on every build.
- **`go.mod` / `go.sum`** — Hugo module dependency on `github.com/imfing/hextra`; no custom theme files live in this repo.
- **`public/`** — generated build output, committed to repo (used for deployment artifacts).
- **`.env`** — canonical source of `GO_VERSION`, `HUGO_VERSION`, `NODE_VERSION`; read by Docker build args, `docker-compose.yml`, and the CI workflow.
- **`.github/workflows/pages.yaml`** — builds and deploys to GitHub Pages on push to `main`; versions are loaded from `.env` via `grep`.

## Blog Structure

Posts live at `content/blog/posts/YYYY/MM/post-slug.md`. The blog landing page (`content/blog/_index.md`) lists all posts recursively sorted by date, newest first.

To add a new post, create a file at the correct year/month path with front matter:

```markdown
---
title: "Post Title"
date: YYYY-MM-DD
description: "Short description shown in the listing."
authors:
  - name: Luan Costa
---
```

Do not create `_index.md` files for year/month directories — they are not needed.

## LaTeX / Math Equations

KaTeX is loaded globally via `layouts/partials/custom/head-end.html` using the CDN auto-render extension. Write math anywhere in Markdown:

- **Block math**: wrap with `$$...$$` on its own lines
- **Inline math**: wrap with `$...$`

No per-page front matter or special config is needed.

## Navigation & Theme

The navbar menu is defined in `hugo.yaml` under `menu.main`. Current items (in order): Blog, LinkedIn, Twitter, GitHub, Search, Theme toggle.

- Theme toggle is a menu item with `params.type: theme-toggle` — this is how Hextra places it in the navbar.
- The "Edit this page on GitHub" link is disabled via `params.editURL.enable: false`.
- The light/dark toggle in the footer is disabled via `params.theme.displayToggle: false`.

## Image Paths in Content

Always use the `{{< img >}}` shortcode instead of a raw `<img>` tag. It wraps Hugo's `relURL` so paths are resolved correctly at any page depth and for both EN and PT language versions:

```
{{< img src="images/photo.jpg" alt="Description" style="float: right; width: 220px;" >}}
```

Supported attributes: `src` (required), `alt`, `style`, `class`.

Store images in `static/images/`. Hugo mirrors this directory to `public/images/` **and** `public/pt/images/` at build time (via module mounts in `hugo.yaml`), so both language versions resolve `images/` correctly.

**Do not use raw `<img src="images/...">` in blog posts** — the path is resolved relative to the post's URL (e.g. `/blog/posts/YYYY/MM/slug/images/...`), which does not exist. The shortcode avoids this.

**Do not use leading-slash paths** (`/images/...`) in raw HTML — Hugo does not reprocess them, so they break on GitHub Pages subdirectory deployments.

## Deployment Targets

| Target | Trigger | Config |
|---|---|---|
| GitHub Pages | Push to `main` | `.github/workflows/pages.yaml` |
| Netlify | Auto | `netlify.toml` |
| Vercel | Auto | `HUGO_VERSION` env var |
