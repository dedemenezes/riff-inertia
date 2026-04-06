# Riff Inertia

Rails + Inertia.js + Vue 3 + Vite. Internal / freelance contributors: use this README for setup and day-to-day development.

## Documentation

- **Tailwind design system & Controller → Inertia → Vue patterns:** [docs/frontend/style_guide_tailwind.md](docs/frontend/style_guide_tailwind.md)

---

## Stack overview

| Layer | Technology |
|--------|------------|
| **Backend** | Ruby on Rails **8.0.x** |
| **Ruby** | **3.3.5** (see `.ruby-version`) |
| **Database** | **MySQL** (`mysql2`) |
| **App server** | **Puma** |
| **Jobs / cache / cable** | **Solid Queue**, **Solid Cache**, **Solid Cable** |
| **Full-stack UI** | **Inertia.js** (`inertia_rails`) — server-driven navigation, Vue renders pages |
| **Frontend** | **Vue 3** (`@inertiajs/vue3`) |
| **Build** | **Vite 7** (`vite_rails`, `vite-plugin-ruby`) |
| **CSS** | **Tailwind CSS 4** |
| **Pagination** | **Pagy** |

---

## Repository layout

- `app/controllers/` — Rails controllers; Inertia via `render inertia: ...` and props.
- `app/frontend/` — Vite source root (`config/vite.json` → `sourceCodeDir`).
  - `entrypoints/` — JS/CSS entries for `vite_javascript_tag` / `vite_stylesheet_tag`.
  - `pages/` — Inertia page components.
  - `components/` — Reusable Vue components.
- `app/views/layouts/application.html.erb` — Root layout (Vite tags + Inertia).
- `test/` — **Minitest**.

---

## Prerequisites

- Ruby **3.3.5**
- Bundler
- Node.js (LTS)
- MySQL
- Optional: **Foreman**, **Overmind**, or **Hivemind** (used by `bin/dev`)

---

## First-time setup

```bash
bundle install
npm install    # repo has package-lock.json; align with the team if using Yarn
```

Database defaults in `config/database.yml`: `DB_USERNAME` (default `root`), `DB_PASSWORD`, `DB_HOST` (default `localhost`), `DB_PORT` (default `3306`).

```bash
bin/rails db:prepare
```

Idempotent setup (install, DB, clear logs; starts `bin/dev` unless you skip):

```bash
bin/setup --skip-server   # setup only, no servers
```

Use `.env` / team-provided secrets as needed (`dotenv` is available in development/test).

---

## Daily development

**Recommended** — Rails and Vite together (HMR on port **3036** per `config/vite.json`):

```bash
bin/dev
```

`Procfile.dev` runs `bin/rails s` and `bin/vite dev`.

**Or** two terminals:

```bash
bin/rails server
bin/vite dev    # or: npm run dev
```

If you run **only** Rails, `autoBuild` in `config/vite.json` can still rebuild assets on demand; it is slower and not ideal for active frontend work.

**Scripts:** `npm run build` (Vite production build), `npm run test` (Vitest).

---

## Tests

```bash
bin/rails test
bin/rails test test/controllers/pages_controller_test.rb
```

---

## Deployment notes

- `Procfile`: `web` runs Puma; `release` runs `rails assets:precompile` (includes Vite production build).
- Production does **not** run the Vite dev server.

---

## Contributor conventions

1. **Inertia:** Pass data from controllers with `render inertia:` + props; avoid ad hoc client `fetch` for server-owned data unless agreed.
2. **Styling & data-flow patterns:** [docs/frontend/style_guide_tailwind.md](docs/frontend/style_guide_tailwind.md).
3. **Pagination:** Use **Pagy** where lists are paginated.
4. **Lint / security:** RuboCop (Omakase) and Brakeman are in the Gemfile for dev/test.

### Useful references

- [Vite Ruby — Development](https://vite-ruby.netlify.app/guide/development.html)
- [inertia_rails](https://github.com/inertiajs/inertia-rails)

### Before you hand off

- [ ] MySQL up and `db:prepare` / migrations applied
- [ ] `bundle install` and `npm install`
- [ ] `bin/dev` (or Rails + `bin/vite dev`) for frontend work
- [ ] `bin/rails test` green for the area you changed
