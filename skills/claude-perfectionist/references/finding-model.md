# Finding Model

Use a small core finding in the main report.
Use this file only when more structure materially improves consistency.

## Core fields

Required in most cases:
- `severity`: `critical | major | minor | info | insufficient_evidence`
- `class`: one primary class
- `surface`: where the problem lives
- `evidence`: concrete files, configs, commands, or observed behavior
- `remediation`: one of `keep | rewrite | delete | extract | enforce | investigate`
- `budget_impact`: `saves_always_on | maintainability_only | none | unknown`

## Optional fields

Use only when useful:
- `confidence`: `high | medium | low`
- `target_surface`: destination when `extract` is chosen
- `enforcement_mechanism`: hook, setting, permission, CI, linter, schema
- `secondary_tags`: short routing tags such as `review_only`, `path_scoped`, `version_sensitive`, `shared_policy`, `legacy_surface`
- `notes`: brief nuance or caveat

## Recommended primary classes

- `missing_verification`
- `contradiction`
- `prose_only_invariant`
- `always_on_bloat`
- `misplaced_scoped_knowledge`
- `review_only_misplacement`
- `missing_routing`
- `stale_or_unverified_command`
- `external_only_source_of_truth`
- `generic_low_signal_instruction`
- `overlapping_skill_or_command`
- `naive_planning_trigger`
- `insufficient_evidence`

## Confidence guidance

Distinguish clearly between:
- **high (verified defect)**: direct repo evidence confirms the problem
- **medium (likely issue)**: strong indirect evidence, but not fully proven
- **low (arguable / not fully verified)**: plausible suspicion, incomplete evidence — flag it, do not assert as fact

When unsure, lower confidence instead of raising severity.

Low-confidence findings should rarely be `critical`. Exceptions:
- direct contradictions in inspected active surfaces
- fabricated command/path presented as canonical
- important workflow with no concrete verification path despite strong repo evidence that verification matters

## Good finding example

```yaml
severity: major
class: misplaced_scoped_knowledge
surface: CLAUDE.md
confidence: high
evidence:
  - CLAUDE.md contains frontend-only review checklist
  - repo has .claude/rules/frontend.md
remediation: extract
target_surface: .claude/rules/frontend.md
budget_impact: saves_always_on
```

## Good enforcement example

```yaml
severity: critical
class: prose_only_invariant
surface: CLAUDE.md
confidence: high
evidence:
  - CLAUDE.md says always run lint before stop
  - repo has CI and local lint command
remediation: enforce
enforcement_mechanism: hook
budget_impact: maintainability_only
```
