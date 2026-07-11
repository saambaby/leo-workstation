# Session — 2026-07-11 API error envelope + response bodies

Branch: `feat/auth-state-refactor`

## What changed

- **`lib/core/network/api_error.dart`** — parse leo-api `{ statusCode, message, error, code }`; `ApiErrorCode` constants; branch on `code` (e.g. `EMAIL_NOT_VERIFIED`), not message strings; `mapUserFacingError` prefers server message then code/status fallbacks.
- **`lib/core/network/api_response.dart`** — `requireJsonMap` / `requireJsonList` replace `response.data!`.
- **Repos** — `ApiAuthRepository` (7 success paths) + `ApiOnboardingRepository` (2 list paths) use the helpers. Only repos on disk; void endpoints unchanged.
- **Invariant** — `INV-CLIENT-NET-2` in `.pineapple/invariants-client.md`.

## Rejected approach

- Keeping `response.data!` with a comment that Dio typed generics guarantee non-null — false; empty bodies still yield null and crash inside `fromJson`.
- Branching email-verify redirect on `message == 'Email not verified'` — fragile vs stable `EMAIL_NOT_VERIFIED` code (`INV-ERROR-1`).

## Surfaces updated

`.pineapple/invariants-client.md`, `.pineapple/state.md`, `.pineapple/code-map.md`, `docs/architecture-overview.md`, `.cursor/rules/pineapple-project.mdc`, session note.

## Left alone

Tracker issues (no task status change); area Cursor rules (no area map ownership change); personal memory.
