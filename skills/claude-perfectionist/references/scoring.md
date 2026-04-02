# Scoring and Grades

Keep scoring simple and stable.
Do not simulate fake arithmetic precision.

## Severity summary

- `critical`: likely repeated failure, unsafe behavior, or direct contradiction
- `major`: meaningful quality loss or misplaced design with real cost
- `minor`: worthwhile cleanup with limited downside
- `info`: optional improvement
- `insufficient_evidence`: suspicion without enough proof

## Confidence gates

Use confidence to limit severity.

- `high`: direct repo evidence or direct conflict in inspected active surfaces
- `medium`: partial evidence with a reasonable inference
- `low`: plausible but weakly supported

Rules:
- low confidence should usually cap at `minor`
- medium confidence can reach `major`
- `critical` normally requires high confidence

## Overall grade

Use one overall grade for the harness. Always show both the letter and the human meaning.

- `A` — **production-ready** — no critical findings, verification and routing are present, root context is lean enough
- `B` — **solid, minor issues** — no critical findings, but some major issues remain
- `C` — **major cleanup needed** — one critical finding or several major issues
- `D` — **minimal harness, significant gaps** — multiple critical findings or widespread misplacement and drift
- `F` — **actively misleading** — the harness contradicts itself or cannot be trusted on important workflows

When reporting the grade, always include the meaning: "Grade: C — major cleanup needed", not just "Grade: C".

## Grade modifiers

Adjust down one step when any of these hold:
- important recommendations depend on unread surfaces
- canonical commands appear stale or unverified
- review-only or path-specific content dominates root memory
- the proposal adds complexity without clear gain

Adjust up one step only when the repo has all of these:
- clear verification paths
- good routing to narrower surfaces
- limited duplication
- deterministic enforcement where appropriate

## Remediation priority

Use this order:
1. fix contradictions between active surfaces
2. add or repair verification paths
3. rewrite unclear or misleading instructions
4. move path-specific content out of root into per-path rule files or nested CLAUDE.md
5. enforce with hooks, settings, or CI when deterministic enforcement beats prose
6. delete only when content is clearly stale, redundant, or zero-value

## Repo maturity signals

Use these as binary signals, not a 100-point score:
- shared root memory is present and coherent
- verification is concrete and repo-grounded
- scoped knowledge is routed away from root
- deterministic checks exist where they should
- canonical docs and commands are not obviously stale

The more signals are present, the higher the confidence that the harness is mature.
