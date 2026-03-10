# Content Contract

## Active Scope

- Phase 1 official lesson set: `text`, `container`, `row`, `gesture_detector`, `list_view`.
- Track ID: `core_widgets_foundation`.
- ElevatedButton examples are kept as templates or Phase 2 seeds, not Phase 1 default content.

## Directory Contract

- `content/widgets/<lessonId>/lesson.md`
- `content/widgets/<lessonId>/anatomy.json`
- `content/widgets/<lessonId>/quiz.json`
- `content/tracks/<trackId>/track.json`

Create or update the lesson triplet together.

## `lesson.md` Frontmatter

Required keys:

- `id`, `kind`, `title`, `library`
- `difficulty`, `trackIds`, `orderInTrack`, `isCoreTrackLesson`
- `recommendedNext`, `conceptCoverage`
- `sourceRefs`, `contentVersion`, `schemaVersion`, `flutterVersion`, `lastReviewedAt`
- `sections`

Required section IDs:

- `overview`
- `api`
- `anatomy`
- `source`
- `playground`
- `runtime`
- `semantics`
- `quiz`

## Phase 1 Lesson Matrix

| lessonId | minimum concept coverage | minimum playground controls |
|---|---|---|
| `text` | `text`, `text_style`, `default_text_style`, `overflow`, `semantics` | font size, weight, align, max lines, overflow, semantics label |
| `container` | `container`, `constraints`, `padding`, `alignment`, `decoration`, `clip` | size, padding, margin, alignment, decoration, clip |
| `row` | `row`, `flex`, `expanded`, `flexible`, `mainAxis`, `crossAxis`, `overflow` | child count, widths, expanded, alignment, direction |
| `gesture_detector` | `gesture_detector`, `callbacks`, `hit_test`, `behavior`, `semantics` | tap, double tap, long press, behavior, hit area, semantics |
| `list_view` | `list_view`, `scroll_view`, `viewport`, `sliver_list`, `controller`, `item_extent` | item count, builder mode, shrinkWrap, direction, scroll reset |

## `anatomy.json`

- Must contain `lessonId`, `schemaVersion`, `nodes`, and `edges`.
- Every edge must point to an existing node.
- Keep stable node IDs.
- Include at least one conceptual relation that connects to another Phase 1 lesson or a shared cross-lesson concept.

## `quiz.json`

- Must contain `lessonId`, `schemaVersion`, and `questions`.
- Ship at least 3 questions per lesson before calling content complete.
- Every `relatedSectionIds` entry must point to a real lesson section.
- Prefer question types already named in the PRD: OX, multiple choice, priority/order, or sequence.

## `track.json`

- Must contain `id`, `title`, `schemaVersion`, `contentVersion`, `orderedLessonIds`, `recommendedEntryLessonId`, `estimatedMinutes`, `learningOutcomes`, and `lastReviewedAt`.
- Phase 1 ordered lessons are `text`, `container`, `row`, `gesture_detector`, `list_view`.

## Versioning And Source Rules

- `schemaVersion` means parser compatibility.
- `contentVersion` means editorial revision count.
- Increment `contentVersion` whenever lesson meaningfully changes.
- Update `lastReviewedAt` whenever source refs or lesson claims are rechecked.
- Keep `sourceRefs` and source excerpts tied to canonical links and short explanations.

## Validation Checklist

- Lesson IDs are unique.
- Section IDs are unique.
- Track references and `recommendedNext` IDs exist.
- `sourceRefs` all resolve to defined source metadata.
- Anatomy edges only reference existing nodes.
- Quiz section links all resolve.
- `lastReviewedAt` is present on publishable content.
