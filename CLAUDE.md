# CLAUDE.md

## Project Overview

**Festival do Rio** — RIFF (Rio International Film Festival) web application.

## Stack

- **Backend:** Ruby on Rails 8.0.x, Ruby 3.3.5, MySQL, Puma
- **Frontend:** Vue 3 + Inertia.js + Vite 7 + Tailwind CSS 4
- **Tests:** Minitest (backend), Vitest (frontend)
- **Pagination:** Pagy
- **Jobs/Cache/Cable:** Solid Queue, Solid Cache, Solid Cable

## Key Directories

- `app/controllers/` — Rails controllers using `render inertia:` with props
- `app/frontend/pages/` — Inertia Vue page components
- `app/frontend/components/` — Reusable Vue components
- `app/frontend/entrypoints/` — Vite JS/CSS entry points
- `test/` — Minitest tests
- `docs/frontend/style_guide_tailwind.md` — Design system & data flow patterns

## Development

```bash
bin/dev              # Rails + Vite HMR (port 3036)
bin/rails test       # Run backend tests
npm run test         # Run frontend tests (Vitest)
```

## Conventions

- **Inertia pattern:** Pass data from controllers via `render inertia:` + props. Avoid ad hoc client `fetch` for server-owned data.
- **Styling:** Use custom Tailwind spacing scale (100-based increments: 100, 200, 300, 400...) and brand color tokens. See `docs/frontend/style_guide_tailwind.md`.
- **I18n:** Server-side translation in controllers, client-side formatting in components.
- **Pagination:** Use Pagy.
- **Lint/Security:** RuboCop (Omakase) + Brakeman.

## Commit Message Format

Use the format: `TICKET-ID: Short imperative description`

Examples:
- `RIFF-30: Move presentation logic from models to controllers`
- `FR-26: Reorganize tests location`
- `RIFF-30: apply gemini build_sessoes filter fix`

## Development Practices

- XP coding practices (TDD, pair programming, small increments)
- Always run tests before considering a feature complete
