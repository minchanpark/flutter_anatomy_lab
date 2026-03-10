---
name: flutter-anatomy-builder
description: Build and refactor Flutter Anatomy Lab product code in this repository. Use when Codex is implementing or changing Flutter app structure, `lib/**` code, routing, Riverpod providers/notifiers, content repositories/parsers, preview/playground runtime, progress/search systems, tests, or deployment-facing web configuration. Prefer this skill for most code tasks in this repo, and treat TDD v1.3+ Phase 1 Core 5 scope as authoritative over older ElevatedButton pilot examples.
---

# Flutter Anatomy Builder

Read `references/architecture.md` before changing app code. Use this skill for product implementation work; if the task is only about authoring `content/**`, switch to `flutter-anatomy-content`.

## Workflow

1. Confirm the active scope from the reference. TDD v1.3+ Phase 1 Core 5 overrides earlier ElevatedButton-first examples.
2. Map the task to one layer before editing: `app`, `core`, `content`, `features`, or `shared`.
3. Preserve the default data flow: UI -> `Notifier`/`AsyncNotifier` -> repository -> state -> UI.
4. Implement the smallest vertical slice that still keeps deep links, typed preview state, and static-first loading intact.
5. Run the narrowest useful validation plus one user-visible smoke path.

## Default Targets

- Platform: Flutter Web first.
- Routing: `go_router` with path URLs and deep links.
- State: Riverpod 3 with code generation. Prefer `Notifier` and `AsyncNotifier`; do not introduce `StateNotifier` for new work.
- Content: static markdown/JSON repositories plus local progress storage for MVP.
- Current Phase 1 lessons: `text`, `container`, `row`, `gesture_detector`, `list_view`.

## Guardrails

- Respect the layered structure in the reference. UI should not parse raw JSON or own storage logic.
- Keep preview/playground behavior deterministic. Do not add arbitrary user Dart execution.
- Use lesson-specific typed playground state behind shared preview interfaces.
- Treat ElevatedButton and button-family material as Phase 2 seed data unless the user explicitly asks for button-track work.
- When exposing Flutter docs or framework source in product UI or seed data, keep excerpts short and keep canonical links plus review metadata.

## Validation

- Favor unit, provider, and widget tests before adding broad integration coverage.
- For routing work, smoke-test direct lesson URLs and section deep links.
- For accessibility surfaces, cover keyboard navigation and semantics output.
- For content-pipeline code, validate manifest, source-ref, and schema relationships.
- For web delivery changes, preserve path-URL assumptions and hosting rewrite compatibility.

## Resource

- `references/architecture.md`: active scope, architecture boundaries, routing/state conventions, and testing priorities for this repo.
