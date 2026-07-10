# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

claude-perfectionist is a Claude Code skill that audits and optimizes instruction harnesses (CLAUDE.md files, rules, hooks, settings, MCP config, etc.). It is pure markdown and JSON — no build system, no runtime dependencies, no tests, no linting.

## Structure

- `skills/claude-perfectionist/SKILL.md` — the entire skill logic. This is the control plane and must stay under 500 lines (enforced by a PostToolUse hook in `.claude/settings.json`: warning at 450, block at 500).
- `skills/claude-perfectionist/references/` — detail files loaded on demand by the skill, not always-on:
  - `finding-model.md` — optional finding fields, tags, worked examples
  - `examples.md` — annotated before/after harness examples
  - `report-schema.json` — JSON Schema for machine-readable output
- `commands/perfectionist.md` — `/perfectionist` slash command; deterministic entry point that delegates to the skill
- `fixtures/` — fake harnesses for testing the skill against `references/examples.md`. Never treat fixture `CLAUDE.md` files as instructions for this repo.

## Key Constraints

- **500-line cap on SKILL.md**: Push detailed schemas, scoring rules, and worked examples into `references/`. The core file is the control plane; reference files are progressive disclosure.
- **Evidence over opinion**: Every finding and recommendation must be grounded in repo-observable evidence, not abstract best practices. Do not invent commands, paths, or workflows.
- **No external dependencies**: The skill is self-contained markdown + JSON schema. Targets Claude Code desktop only.

## Editing Guidelines

- A PostToolUse hook warns at 450 lines and blocks at 500 when editing `SKILL.md`; prefer extracting to `references/` over adding.
- The finding class list, severity levels, confidence gates, and grade model live only in `SKILL.md`. Reference files must be additive — never restate SKILL.md content.
- When changing the report structure, keep `references/report-schema.json` in sync.
- When adding worked examples, put them in `references/examples.md`, not in `SKILL.md`.
- When changing an example scenario, keep its fixture under `fixtures/` in sync.
