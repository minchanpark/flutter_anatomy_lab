# Architecture Reference

## Scope Precedence

- `dev/TDD.md` is append-only. Newer appendices override older examples when they conflict.
- Active Phase 1 product scope is the Core 5 Widget Track: `text`, `container`, `row`, `gesture_detector`, `list_view`.
- ElevatedButton content remains useful as a schema example and Phase 2 seed, not the default implementation target.

## Product Baseline

- Flutter Web first.
- Static-first MVP with no mandatory backend.
- `go_router` path URLs and deep-linkable lesson routes.
- Riverpod 3 with code generation.
- Local progress/bookmark storage as the MVP persistence layer.

## Layer Boundaries

- `lib/app`: bootstrap, app shell, router.
- `lib/core`: theme, l10n, analytics, logging, errors.
- `lib/content`: models, parsers, manifests, repositories.
- `lib/features/*`: presentation, application, and feature-local data.
- `lib/shared`: reusable widgets, diagrams, layout, code viewers.

Keep raw JSON, storage details, and schema parsing out of the UI layer.

## State Rules

- Use `Notifier` and `AsyncNotifier` for new mutable state.
- Avoid new `StateNotifier` usage.
- Use `ref.watch` for render inputs and `ref.listen` for side effects.
- Favor provider overrides and `ProviderContainer.test()` in tests.

## Routing Rules

- Canonical routes:
  - `/`
  - `/widgets`
  - `/widgets/:widgetId`
  - `/widgets/:widgetId/anatomy/:sectionId`
  - `/tracks/:trackId`
  - `/search?q=`
  - `/settings`
- URL state beats persisted local state when both exist.
- Path URL strategy requires host rewrites to `index.html`.

## Preview And Playground Rules

- Preview builders are registry-driven and deterministic.
- Each lesson should have typed playground state, even if shared abstractions exist.
- The preview is a learning instrument, not a generic playground or user-code runner.
- Keep controls narrow enough that the structural lesson stays legible.

## Content-System Expectations For Code

- Lesson data is split across `lesson.md`, `anatomy.json`, and `quiz.json`.
- `schemaVersion` is parser compatibility; `contentVersion` is editorial revision count.
- Repositories should be the single source of truth for lesson, progress, and search state.
- Build or validation code should check source-ref integrity, section IDs, graph edges, and quiz links.

## Testing Priorities

- Unit: parsers, manifests, search ranking, progress merge logic.
- Provider: playground, progress, and search controllers.
- Widget: catalog, lesson navigation, preview updates, anatomy map, accessibility surfaces.
- Integration: deep links and local-progress persistence.

## Delivery Notes

- Prefer release JS builds for Phase 1.
- Treat Wasm as optional or internal until a deliberate rollout decision exists.
- Keep source excerpts short and store canonical links plus review dates for Source Lens features.
