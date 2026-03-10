# Flutter Anatomy Lab AGENTS

## Project Rules

- Treat `dev/TDD.md` as append-only. Newer sections override older examples when they conflict.
- Prefer append-only updates in `dev/PRD.md` and `dev/TDD.md` when revising product, UX, IA, or technical direction so the override history stays explicit.
- Active implementation scope is **Phase 1 Core 5 Widget Track**: `text`, `container`, `row`, `gesture_detector`, `list_view`.
- Treat `ElevatedButton` material in `dev/PRD.md` and `dev/TDD.md` as a Phase 2 seed or schema example unless the user explicitly asks for button-track work.
- For product-facing docs and documentation-style UI specs, prefer a clean official-docs visual language: content-first layout, restrained color, clear left navigation, sticky outline/context rail, simple diagrams, and minimal decorative chrome.
- Prefer the project skills below before doing broad repo exploration.

## Skills

- `flutter-anatomy-builder`: Build or refactor Flutter Anatomy Lab app code, routing, Riverpod state, repositories, preview runtime, progress/search systems, tests, and deployment-facing structure. Use for most `lib/`, app architecture, and implementation work. (file: `/Users/minchanpark/Library/Mobile Documents/com~apple~CloudDocs/dev_project/flutter_project/flutter_anatomy_lab/.codex/skills/flutter-anatomy-builder/SKILL.md`)
- `flutter-anatomy-content`: Author or revise lesson, track, anatomy, quiz, source-ref, and manifest content under `content/**`. Use when the task is primarily editorial/data-contract work rather than Flutter app code. (file: `/Users/minchanpark/Library/Mobile Documents/com~apple~CloudDocs/dev_project/flutter_project/flutter_anatomy_lab/.codex/skills/flutter-anatomy-content/SKILL.md`)

## Skill Routing

- Use `flutter-anatomy-builder` for app code, routing, state, preview runtime, repositories, tests, and infrastructure.
- Use `flutter-anatomy-content` for `content/widgets/*`, `content/tracks/*`, source drift metadata, anatomy graphs, and quizzes.
- If a task spans both code and content, load `flutter-anatomy-builder` first to confirm contracts, then `flutter-anatomy-content` for the content files.
