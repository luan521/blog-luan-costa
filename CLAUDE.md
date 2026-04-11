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
- **`go.mod` / `go.sum`** — Hugo module dependency on `github.com/imfing/hextra`; no custom theme files live in this repo.
- **`public/`** — generated build output, committed to repo (used for deployment artifacts).
- **`.env`** — canonical source of `GO_VERSION`, `HUGO_VERSION`, `NODE_VERSION`; read by Docker build args, `docker-compose.yml`, and the CI workflow.
- **`.github/workflows/pages.yaml`** — builds and deploys to GitHub Pages on push to `main`; versions are loaded from `.env` via `grep`.

## Deployment Targets

| Target | Trigger | Config |
|---|---|---|
| GitHub Pages | Push to `main` | `.github/workflows/pages.yaml` |
| Netlify | Auto | `netlify.toml` |
| Vercel | Auto | `HUGO_VERSION` env var |
