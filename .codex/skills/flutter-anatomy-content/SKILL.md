---
name: flutter-anatomy-content
description: Author and maintain Flutter Anatomy Lab lesson and track content in this repository. Use when Codex is adding or updating files under `content/widgets/*` or `content/tracks/*`, editing lesson frontmatter, anatomy graphs, quizzes, source references, search/manifests, or source-drift metadata. Prefer this skill for content-contract work, especially the Phase 1 Core 5 lessons, and pair it with `flutter-anatomy-builder` only when content changes also require app code.
---

# Flutter Anatomy Content

Read `references/content-contract.md` before editing `content/**`. Use this skill for lesson, track, anatomy, quiz, and source-reference work; if the task also changes Flutter app code or providers, pair it with `flutter-anatomy-builder`.

## Quick Start

- Scaffold a new lesson directory with `scripts/scaffold_lesson.sh <lesson_id> <title> [track_id] [order_in_track]`.
- Reuse the starter files in `assets/templates/` instead of rewriting structure from scratch.
- Prioritize the Phase 1 Core 5 track over the older ElevatedButton pilot.

## Workflow

1. Confirm that the lesson or track belongs to the active scope in the reference.
2. Create or update `lesson.md`, `anatomy.json`, and `quiz.json` together.
3. Keep `schemaVersion`, `contentVersion`, `lastReviewedAt`, and `sourceRefs` current.
4. Check that anatomy nodes, edges, quiz links, and track metadata agree with each other.
5. Validate cross-file references before handing the task off.

## Non-Negotiable Rules

- Required lesson sections are `overview`, `api`, `anatomy`, `source`, `playground`, `runtime`, `semantics`, and `quiz`.
- `schemaVersion` tracks parser compatibility; `contentVersion` tracks editorial revisions.
- Keep source excerpts short. Prefer explanation plus a canonical link over copied framework text.
- Phase 1 lessons are curated teaching modules, not freeform sandboxes. Keep playground controls narrow and intentional.
- Prefer `WidgetState`-family terminology in explanations and note legacy Material aliases only when relevant to search or source context.

## Resources

- `references/content-contract.md`: active content schema, Phase 1 lesson matrix, and validation checklist.
- `scripts/scaffold_lesson.sh`: create a new lesson directory from the project templates.
- `assets/templates/`: starter files for lessons and tracks.
