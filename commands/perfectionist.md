---
description: Audit and optimize the Claude Code instruction harness (CLAUDE.md, rules, hooks, settings, MCP config)
argument-hint: "[audit|propose|apply] [--json] [path]"
---

Use the claude-perfectionist skill to audit this repository's instruction harness.

Arguments: $ARGUMENTS

- If the arguments contain `audit`, `propose`, or `apply`, run in that execution mode. Otherwise default to `propose`.
- If the arguments contain `--json`, also emit the machine-readable JSON report defined by the skill's `references/report-schema.json`.
- If the arguments name a path or package, scope the audit to that part of the repo plus the shared surfaces above it.
- Follow the skill's workflow and output format exactly.
