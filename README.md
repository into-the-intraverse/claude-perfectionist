# claude-perfectionist

A Claude Code skill that audits and optimizes instruction harnesses — root `CLAUDE.md`, rules, skills, hooks, settings, MCP config, and canonical docs.

Optimizes for **agent reliability per unit of always-on context**, not for the shortest file.

> ⚠️ If you have `claude-md-management` or another CLAUDE.md-related skill installed, it may intercept queries before the perfectionist gets a chance. Uninstall competing skills or be explicit: *"use the perfectionist to audit my harness."*

**Try it:**
- `"My Claude keeps using yarn but we switched to pnpm months ago"` — traces the misbehavior to contradicting instructions across your config surfaces, produces a corrected snippet.
- `"Audit my CLAUDE.md"` — full harness sweep: finds contradictions, stale commands, context bloat, missing verification, and tells you the 3–5 changes that matter most.

## Quick Start

### Claude Code — plugin (recommended)

```bash
/plugin install into-the-intraverse/claude-perfectionist
```

### Claude Code — via marketplace

If you have the [bazaar](https://github.com/into-the-intraverse/bazaar) marketplace:

```bash
/plugin marketplace add into-the-intraverse/bazaar
/plugin install claude-perfectionist@bazaar
```

### Claude Code — manual (personal)

```bash
git clone https://github.com/into-the-intraverse/claude-perfectionist.git
cp -r claude-perfectionist/skills/claude-perfectionist ~/.claude/skills/claude-perfectionist
```

### Claude.ai (web/mobile)

1. Download or clone this repo.
2. Zip the `skills/claude-perfectionist` folder (the folder itself must be the zip root).
3. In Claude.ai go to **Customize → Skills → "+" → Upload a skill**.
4. Upload the zip.

After installing, ask Claude:

```
Audit my CLAUDE.md and instruction harness
```

---

## What It Does

The perfectionist inspects the full harness surface:

| Surface | What it checks |
|---|---|
| Root `CLAUDE.md` | always-on bloat, missing verification, generic instructions, stale commands |
| `.claude/rules/` | misplaced scoped knowledge, path-scoping opportunities |
| `.claude/skills/` | overlapping triggers, vague descriptions |
| `.claude/agents/` | unclear routing boundaries |
| `.claude/settings.json` | enforcement gaps that should be config, not prose |
| Hooks | prose-only invariants that should be deterministic |
| `.mcp.json` | undocumented tool surfaces |
| `REVIEW.md` | review-only guidance polluting normal sessions |
| `README`, `docs/` | duplicated content, external-only sources of truth |

It produces a verdict-first report with:
- **Verdict** — 2–4 sentences on whether the harness is trustworthy, plus a grade (A–F with human meaning)
- **Top findings** — max 5, prioritized by severity, in plain language
- **Recommended changes** — specific, actionable, max 7
- **Open questions** — only blocker-level
- **Appendix** — harness map, validation plan, evidence (only when needed)
- **Machine-readable JSON report**

The report adapts its template to the scenario: default audit, new/empty harness bootstrap, or contradiction debug.

## Modes

| Mode | What it does | When to use |
|---|---|---|
| `audit` | Diagnose only. No file changes. | First pass, understanding the current state |
| `propose` | Diagnose + draft minimum high-leverage changes. | Default. Most common use. |
| `apply` | Produce concrete rewritten files. | When you're ready to commit changes |

Ask Claude to use a specific mode:

```
Audit my instruction harness — audit mode only
```
```
Propose optimizations for my CLAUDE.md
```
```
Apply the top changes to my harness
```

If you don't specify, the perfectionist defaults to **propose**.

## Core Philosophy

1. **Evidence over opinion** — findings are grounded in repo files, not abstract best practices.
2. **Always-on context accounting** — distinguishes real context savings from cosmetic reorganization.
3. **Right surface for the job** — routes guidance to rules, hooks, skills, docs, or settings instead of piling everything into `CLAUDE.md`.
4. **Fix before you delete** — fix contradictions and add verification before removing anything. Delete only when content is clearly stale, redundant, or zero-value.
5. **Verification is non-negotiable** — a harness without concrete verification commands is a critical finding.
6. **Honest confidence** — when evidence is incomplete, lower confidence instead of raising severity. Distinguish verified defects from likely issues and open questions.

## Repo Structure

```
.claude-plugin/
└── plugin.json                       # Plugin metadata
skills/
└── claude-perfectionist/
    ├── SKILL.md                      # Core skill (~307 lines)
    └── references/
        ├── finding-model.md          # Full finding fields, tags, examples
        ├── scoring.md                # Grade model (A–F with human meanings), confidence gates
        ├── examples.md               # Annotated before/after examples
        └── report-schema.json        # Machine-readable output schema
```

`SKILL.md` is the control plane — compact core logic under 500 lines.
`references/` files load on demand only when the perfectionist needs detailed schemas or examples.

## Example Output

Given a bloated `CLAUDE.md` with review checklists, unverified commands, and wiki-only references, the perfectionist might produce:

```
# Verdict
The root CLAUDE.md is a 210-line dumping ground. Three review checklists (~80 lines) and
six service-specific sections (~60 lines) consume always-on context that should be conditional.
Fix the review-only misplacement and stale external references first.

Grade: C — major cleanup needed

## Top findings
| Severity | Problem                              | Action                                                    |
|----------|--------------------------------------|-----------------------------------------------------------|
| major    | Review checklists in always-on memory | Move into REVIEW.md; add one-line pointer in root         |
| major    | Service-specific sections in root     | Move into per-service rule files                          |
| major    | References to tools Claude can't use  | Delete Notion/Slack/Confluence refs or replace with docs  |
| major    | Routing to agents that don't exist    | Remove unless .claude/agents/ definitions are added       |
| minor    | LOC-based planning trigger            | Rewrite: plan when ambiguous, irreversible, or broad      |
```

## Detailed Usage

### First audit

Run an audit first to understand your starting point:

```
Audit my Claude Code instruction harness. Show me the harness map, 
top findings, and grade. Audit mode only — don't change anything.
```

### Targeted optimization

Focus on specific problems:

```
My CLAUDE.md is 400 lines. Help me reduce always-on context cost 
without losing verification or routing. Propose mode.
```

### Full apply

When ready to commit:

```
Apply the top 3 changes from your audit. Create any new files 
(rules, docs, REVIEW.md) that the extraction plan calls for.
```

### Monorepo

```
Audit the instruction harness for the apps/web package. 
Check for contradictions with the root CLAUDE.md.
```

### After refactoring

```
I just restructured my .claude/ directory. Re-audit and check 
that routing still works and nothing got lost.
```

## Requirements

- Claude Code with skills support, or Claude.ai with code execution enabled.
- No external dependencies. The skill is pure markdown + JSON schema.

## Contributing

Issues and PRs welcome. The skill follows its own philosophy:
- Changes should be grounded in evidence (real failure modes, not theoretical improvements).
- Keep `SKILL.md` under 500 lines. Push detail to `references/`.
- Test changes against real-world `CLAUDE.md` files before merging.

## License

MIT
