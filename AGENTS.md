# curr-mvp — OpenCode instructions

## FIRST ACTION

Read `.specs/guide.md`. It explains the complete project — what it does, how to navigate, and the two possible flows.

## Entrypoint Gate (HARD GATE)

**Trigger:** Every first user message — greetings, single words, questions, empty messages. No exceptions.

**Detection & Routing:**
- **Job posting** (URL, structured description, intent to apply) → execute **job-briefing** flow per [features/job-briefing/spec.md](.specs/features/job-briefing/spec.md)
- **Non-job** (everything else) → execute **profile-management** flow per [features/profile-management/spec.md](.specs/features/profile-management/spec.md)

**FORBIDDEN:** Generic greetings, open-ended questions, any message that doesn't route to one of the two flows.

If `profile.md` does not exist, run profile-management first (job-briefing requires it).

## Commands

```powershell
bun run lint                                 # reindents all output/*.json to 2 spaces
bun run validate  "output/FILE.json"         # Zod schema validation
bun run typecheck                            # tsc --noEmit
.\compile.ps1 "output/DATA x EMPRESA x VAGA.json"     # lint → validate → compile → PDF
.\setup.ps1                                   # download typst binary to bin/
```

`compile.ps1` automatically runs lint + Zod validation before invoking typst — no need to run them separately.

## Skills (optional)

| Skill | When |
|-------|------|
| `spec-driven-analyst` | For spec work (DISCOVER/BUILD/FIX checkpoints) |
| `typst` | When compiling `.typ` files to PDF |

Lock file: `skills-lock.json` sources the `typst` skill from `lucifer1004/claude-skill-typst`.

## Runtime

- **Bun** (not Node): scripts use `#!/usr/bin/env bun`, deps in `bun.lock`, not `package-lock.json`
- **Typst**: binary in `bin/` (gitignored). Typst v0.14.2 is the configured version in `src/scripts/setup.ps1`
- **TypeScript**: v6, `noEmit: true` (type checking only), `@types/bun`
- **Zod**: v4 — schema in `src/scripts/validate-json.ts` is the source of truth for JSON shape

## Compile pipeline (what `compile.ps1` does)

1. Lint all JSONs in `output/` (2-space reindent)
2. Zod-validate the target JSON against canonical schema
3. Copy JSON to `_temp_resume.json` in project root (avoid path quoting issues)
4. Run `typst compile --root=. src/templates/resume.typ` with `--input data=../../_temp_resume.json`
5. Rename `_temp_resume.pdf` to final name, clean up temps

`--root` is set to the project root. `data=` path is relative to `src/templates/resume.typ`.

## Template JSON — All optional fields are mandatory in data

The template accesses fields via dot notation (`item.technologies`). This **breaks** if the key is absent.

**Before writing JSON**, read `src/templates/basic-resume/resume.typ` to verify the exact parameters each helper accepts (`work()`, `edu()`, `project()`, `certificates()`). The Zod schema in `src/scripts/validate-json.ts` is the canonical contract.

Every JSON must contain:

| Context | Required fields |
|---------|----------------|
| `meta` | `template`, `accent-color`, `font`, `paper`, `author-position`, `personal-info-position`, `lang`, `keywords` |
| `personal` | `name`, `email`, `phone`, `github`, `linkedin`, `personal-site`, `pronouns` |
| work / education / projects items | `technologies: []`, `methodologies: []`, `keywords: []`, `bullets: []` |
| projects items | `url: ""`, `dates: { "start": "", "end": "" }` |
| education items | `technologies: []`, `methodologies: []`, `keywords: []`, `bullets: []` |

Fallback JSON at `src/templates/_empty_resume.json` — used when `sys.inputs.at("data")` has no default.

## Typst Path Resolution

- `read()` and `json()` resolve paths relative to the **directory of the `.typ` file** that calls them, not `--root`
- `src/templates/resume.typ` → `json("data/foo.json")` looks in `src/templates/data/foo.json`
- To access `output/file.json` from inside `src/templates/`: use `../../output/file.json`
- Always use **forward slashes** (`/`) in paths (works on Windows, Linux, Mac)

## Profile — Behavioral notes about Pedro (accumulated)

- **Marketing digital:** real experience with GA, Meta Pixel, Tag Manager — implemented tracking on Plugchat. Not just theoretical.
- **Digital One:** a marketing agency, not a generic tech company.
- **Personal preferences:** Tailwind CSS (since ITEM Sistemas), ShadCN/UI, Zustand (since Irrah Tech). NestJS and Express.
- **Tax domain:** NF-e/NFS-e expertise, integrated with Elotech (public sector system).
- **Entrepreneurship:** t-shirt brand was a digital product with campaigns, profile, traffic — not just a "physical business".
- **Interview/briefing behavior:** when a gap is identified, Pedro often has the experience but didn't list it — ask directly ("do you have experience with X?") reveals more than waiting for him to offer it.
- **Communication:** naturally translates technical language for business/marketing teams.
- **Mentoring:** actively teaches colleagues and students, created technical documentation on his own initiative.

## Conventions

- Profile: `profile.md` (Markdown, incremental, never complete). Source of truth. **Never compact or summarize it.**
- Template: `src/templates/resume.typ` + helpers in `src/templates/basic-resume/resume.typ` (immutable)
- Output: `output/{data} x {Empresa} x {Vaga}.pdf` + companion `.json` (gitignored)
- Pipeline: profile.md → AI briefing → JSON → typst compile → PDF
- **Title per job**: define the professional title per job briefing (e.g., "Desenvolvedor Full Stack" → "Desenvolvedor Back-End .NET"). Not fixed in profile.
- **Work order**: sort experiences by relevance to the job, not chronologically. The most aligned experience first.
- **Tech inference rules** (from job-briefing spec): C# → .NET/.NET Core/ASP.NET, JavaScript → Node.js/TypeScript/React/Vue, TypeScript → JavaScript, React → Next.js/React Native, SQL → PostgreSQL/MySQL/SQL Server. Inference is **unidirectional** (specific → general) unless the job context clearly indicates otherwise.

## Features

| Feature | Status | What |
|---------|--------|------|
| **template-system** | ✅ Spec | [features/template-system/spec.md](.specs/features/template-system/spec.md) |
| **profile-management** | ✅ Spec | [features/profile-management/spec.md](.specs/features/profile-management/spec.md) |
| **job-briefing** | ✅ Spec | [features/job-briefing/spec.md](.specs/features/job-briefing/spec.md) |
