# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

claude-perfectionist is a Claude Code skill that audits and optimizes instruction harnesses (CLAUDE.md files, rules, hooks, settings, MCP config, etc.). It is pure markdown and JSON — no build system, no runtime dependencies, no tests, no linting.

## Structure

- `skills/claude-perfectionist/SKILL.md` — the entire skill logic (~307 lines). This is the control plane and must stay under 500 lines.
- `skills/claude-perfectionist/references/` — detail files loaded on demand by the skill, not always-on:
  - `finding-model.md` — finding field definitions, tags, examples
  - `scoring.md` — grade model (A–F), confidence gates, severity rules
  - `examples.md` — annotated before/after harness examples
  - `report-schema.json` — JSON Schema for machine-readable output

## Key Constraints

- **500-line cap on SKILL.md**: Push detailed schemas, scoring rules, and worked examples into `references/`. The core file is the control plane; reference files are progressive disclosure.
- **Evidence over opinion**: Every finding and recommendation must be grounded in repo-observable evidence, not abstract best practices. Do not invent commands, paths, or workflows.
- **No external dependencies**: The skill is self-contained markdown + JSON schema. It must work in both Claude Code CLI and Claude.ai (web/mobile) via zip upload.

## Editing Guidelines

- When modifying `SKILL.md`, verify the line count stays under 500 after edits.
- When adding a new finding class, update both `SKILL.md` (the class list) and `references/finding-model.md`.
- When changing the report structure, keep `references/report-schema.json` in sync.
- When adding worked examples, put them in `references/examples.md`, not in `SKILL.md`.
