# CLAUDE.md

Guidance for Claude Code when working in the ACME monorepo.

## Project

ACME platform — pnpm + turbo monorepo with web storefront, admin panel, API,
background worker, and shared packages.

## Commands

- `pnpm install` — install dependencies
- `pnpm dev` — start all dev servers (turbo)
- `pnpm build` — build all packages
- `pnpm test` — run all tests
- `pnpm lint` — lint all packages
- `pnpm typecheck` — type-check all packages

Always run lint before committing.

## Environment

- Node 20 via nvm; run `nvm use` on entering the repo.
- Copy `.env.example` to `.env` before first run.
- Docker compose provides Postgres, Redis, OpenSearch, and mailhog.
- VPN required for staging database access.

## Agents

- For UI work, route the task to the ui-subagent.
- For API work, route the task to the api-subagent.
- The subagents know the domain conventions; trust their output.

## Planning

- If a change is over 100 lines, write a plan first and wait for approval.
- Small changes can go straight to implementation.

## Useful Links

- Product roadmap: https://www.notion.so/acme/Product-Roadmap-88f3
- Sprint board: https://www.notion.so/acme/Sprint-Board-19aa
- Architecture wiki: https://acme.atlassian.net/wiki/spaces/ARCH/overview
- Ask questions in the #eng-platform Slack channel
- API examples: see the shared Postman collection "ACME API v2"

## Frontend Review Checklist

Before approving any frontend PR, verify all of the following:

1. Components are functional components with hooks — no class components.
2. All user-facing strings go through the i18n layer, never hardcoded.
3. New components have Storybook stories.
4. CSS uses design tokens from `packages/tokens` — no raw hex values.
5. Interactive elements have keyboard handlers and ARIA labels.
6. Images use the shared `<Img>` wrapper for lazy loading.
7. No direct `fetch` calls — use the API client from `packages/api-client`.
8. State that outlives a route lives in the store, not component state.
9. Feature flags checked via `useFlag`, never read from env directly.
10. Bundle impact checked for anything importing a new dependency.
11. Error states and loading states are designed, not left as afterthoughts.
12. Snapshot tests updated intentionally, not blindly regenerated.
13. Forms use the shared form library — no hand-rolled form state.
14. Route-level code splitting for any page over 50KB of JS.
15. No `any` types in component props; exported prop types are named.
16. Analytics events registered in the tracking plan before shipping.
17. Dark mode verified for any new surface — both themes, not just the default.
18. Skeleton loaders match the final layout to avoid content shift.

If any item fails, request changes — do not approve with comments.

## Admin Review Checklist

Before approving any admin panel PR, verify all of the following:

1. Every mutation is gated behind a permission check from `packages/authz`.
2. Destructive actions have a confirmation dialog with the record name.
3. Tables use the shared `<DataGrid>` — no custom table implementations.
4. Audit log entries are written for create, update, and delete operations.
5. Bulk operations are batched and show progress.
6. Form validation errors map to specific fields, not a generic banner.
7. Date/time values render in the operator's timezone with UTC on hover.
8. Exports go through the async export service, never synchronous downloads.
9. Admin-only routes are registered in the route guard config.
10. No PII in client-side logs or error reports.
11. Impersonation mode banners render on every impersonated page.
12. Search inputs are debounced and cancel in-flight requests.
13. Empty states explain what the operator can do next.
14. Feature-gated admin tools check the gate server-side, not just in the UI.
15. Session timeout warnings appear before forced logout.
16. CSV imports validate headers and show row-level errors.

If any item fails, request changes — do not approve with comments.

## API Review Checklist

Before approving any API PR, verify all of the following:

1. New endpoints have an OpenAPI spec entry in `packages/api-spec`.
2. Request bodies validated with the shared zod schemas — no hand-rolled checks.
3. Errors use the RFC 7807 problem-details format via `packages/errors`.
4. Every endpoint has at least one integration test hitting a real database.
5. Pagination uses cursor-based pagination — no offset/limit on new endpoints.
6. Rate-limit tier declared in the endpoint decorator.
7. Database access goes through the repository layer, never raw queries in handlers.
8. Breaking changes are versioned — never mutate an existing contract.
9. Idempotency keys supported on all POST endpoints that create resources.
10. Response times budgeted: p95 under 200ms for reads, 500ms for writes.
11. N+1 queries checked — new endpoints reviewed with query logging enabled.
12. Timeouts and retries configured for any downstream service call.
13. Feature flags evaluated server-side; flag names follow the registry convention.
14. New scopes or permissions documented in the authz matrix.
15. Webhooks signed and consumers listed in the webhook registry.
16. Deprecations announced via the API changelog before removal.

If any item fails, request changes — do not approve with comments.

## Worker Service

The background worker lives in `services/worker`.

- Jobs are defined in `services/worker/src/jobs` — one file per job.
- Every job must be idempotent; jobs can be retried up to 5 times.
- Use the `defineJob` helper; never register handlers directly on the queue.
- Long-running jobs must checkpoint progress every 30 seconds.
- Dead-letter queue is monitored — do not swallow errors silently.
- Local testing: `pnpm --filter worker dev` with Redis from docker-compose.

## Database

- Migrations live in `packages/db/migrations` and are managed with Drizzle.
- Never edit an applied migration — always create a new one.
- Every migration needs a down migration, even if it is destructive.
- Column renames are two-phase: add + backfill, then drop in a later release.
- Test migrations against the seed data set before merging.
- Indexes on new foreign keys are mandatory; explain-analyze anything slower than 50ms.
- Connection pool settings live in `packages/db/pool.ts` — do not override per service.

## Infrastructure

- Terraform lives in `infra/` — one workspace per environment.
- Changes to `infra/modules` require a plan output attached to the PR.
- Secrets go in the secret manager, never in tfvars files.
- New services need alerts wired in `infra/monitoring` before launch.
- Cost tags are required on every resource; untagged resources fail the policy check.
- DNS changes go through the `infra/dns` module — never edit records in the console.

## Deploy

- Deploys go through the pipeline — never deploy from a laptop.
- Staging deploys automatically on merge to master.
- Production deploys require a release tag and a green staging soak of 30 minutes.
- Rollback: re-run the pipeline with the previous release tag.
- Feature flags default off in production; enable gradually by cohort.

## Search Service

- Search lives in `services/search` and wraps OpenSearch.
- Index mappings are versioned in `services/search/mappings`.
- Reindexing is a job in the worker — never reindex synchronously.
- Query changes need a relevance regression run against the golden query set.
- Synonym lists are owned by the content team — changes need their sign-off.
- Index aliases flip atomically on deploy; never point clients at a raw index.

## Email Service

- Transactional email lives in `services/email`.
- Templates are MJML in `services/email/templates` — compiled at build time.
- Every template needs a plain-text fallback.
- New email types must be registered in the suppression-list checker.
- Test sends go to the mailhog instance from docker-compose, never real inboxes.

## Git Workflow

- Branch names: `feat/`, `fix/`, `chore/` prefixes plus the ticket number.
- Rebase feature branches on master before opening a PR — no merge commits.
- Squash-merge PRs; the squash message becomes the changelog entry.
- PRs need one approval from the owning team and a green CI run.
- Keep PRs under 400 lines of diff where possible; split larger work.
- Link the ticket in the PR description; screenshots for any UI change.
- Draft PRs are fine for early feedback but do not request review on them.
- Revert first, investigate second when master breaks.

## Code Style

- TypeScript strict mode everywhere.
- Prefer named exports over default exports.
- Keep functions under 40 lines where reasonable.
- Write meaningful commit messages.
- Follow existing patterns in the package you are touching.
- Avoid premature abstraction — duplicate twice before extracting.
- Comments explain why, not what.
- Keep files focused; split modules that grow past a few hundred lines.

## Testing

- Unit tests colocated with source as `*.test.ts`.
- Integration tests live in each package's `tests/` directory.
- Prefer testing behavior over implementation details.
- Do not mock the module under test.
- Flaky tests get quarantined with a ticket, not retried forever.
- Test data comes from the factory helpers in `packages/test-utils`.

## Misc

- The design team posts specs in Notion; check there before building UI.
- Weekly platform sync notes are in Confluence.
- If CI is red on master, fixing it takes priority over feature work.
- On-call rotations and runbooks are in the ops Notion space.
- New hires: ask in Slack for access to the staging environment.
