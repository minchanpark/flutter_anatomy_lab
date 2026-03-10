---
id: text
kind: widget
title: Text
library: widgets
difficulty: foundation
trackIds:
  - core_widgets_foundation
orderInTrack: 1
isCoreTrackLesson: true
recommendedNext:
  - container
conceptCoverage:
  - text
  - text_style
  - default_text_style
  - overflow
  - semantics
sourceRefs:
  - id: api:text
    kind: api
    title: Text class
    url: https://api.flutter.dev/flutter/widgets/Text-class.html
    licenseNote: Docs CC BY 4.0 / code samples BSD-3-Clause
    lastVerifiedAt: "2026-03-10"
  - id: api:text_style
    kind: api
    title: TextStyle class
    url: https://api.flutter.dev/flutter/painting/TextStyle-class.html
    licenseNote: Docs CC BY 4.0 / code samples BSD-3-Clause
    lastVerifiedAt: "2026-03-10"
  - id: api:default_text_style
    kind: api
    title: DefaultTextStyle class
    url: https://api.flutter.dev/flutter/widgets/DefaultTextStyle-class.html
    licenseNote: Docs CC BY 4.0 / code samples BSD-3-Clause
    lastVerifiedAt: "2026-03-10"
  - id: docs:accessibility
    kind: docs
    title: Flutter accessibility overview
    url: https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility
    licenseNote: Docs CC BY 4.0 / code samples BSD-3-Clause
    lastVerifiedAt: "2026-03-10"
contentVersion: 1
schemaVersion: 1
flutterVersion: "3.41.x"
lastReviewedAt: "2026-03-10"
sections:
  - overview
  - api
  - anatomy
  - source
  - playground
  - runtime
  - semantics
  - quiz
---

# Overview

`Text` is the default way to put readable text on screen in Flutter.

- It looks simple, but it sits on top of style inheritance, layout constraints, overflow policy, and semantics.
- Phase 1 uses `Text` as the entry lesson because it is visible in almost every app and connects quickly to `Container`, `Row`, and accessibility.
- In this first implementation slice, the reader focuses on **how text becomes style, layout, and meaning**, not on every advanced text feature.

# API

The `Text` constructor is small, but a few parameters shape most real behavior.

- `data` or `textSpan` decides the visible content.
- `style` adds local visual rules, but it still interacts with inherited defaults.
- `maxLines`, `overflow`, and `softWrap` control how text reacts when width becomes tight.
- `textAlign` changes how the paragraph is placed inside its line box.
- `semanticsLabel` lets the accessible label differ from the visible string when needed.

# Anatomy

The anatomy of `Text` is not about decoration first. It is about the chain that turns a short string into a paragraph with style and semantics.

- `TextStyle` holds local visual decisions such as size, weight, and color.
- `DefaultTextStyle` is the inherited context that fills in missing style values.
- `overflow` becomes visible only when parent width is constrained, which links this lesson to `Container` and `Row`.
- semantics is part of the lesson because visible text and accessible text can intentionally differ.

# Source

This reader keeps source coverage short and canonical.

- Use the `Text` API page for constructor shape and behavior notes.
- Use `TextStyle` and `DefaultTextStyle` to understand where visual defaults come from.
- Use Flutter accessibility guidance when the visible label and the spoken label should differ.

# Playground

The next slice will add a curated playground for:

- font size
- weight
- align
- max lines
- overflow
- semantics label

The goal is not a freeform editor. The controls will stay narrow enough to keep the structure legible.

# Runtime

`Text` itself is a widget-level description. The visible paragraph happens later in the pipeline.

- At the widget layer, `Text` describes content and high-level options.
- The render phase eventually produces paragraph layout and paint behavior.
- Constraint width matters because it decides wrapping and overflow.
- That is why this lesson belongs early in the track: the same text behaves differently when a parent box or row gives it different room.

# Semantics

Visible text often becomes its own semantics, but Flutter also gives you a way to override that.

- `semanticsLabel` is useful when the spoken label should be clearer than the raw visible string.
- If text is decorative only, the surrounding semantics structure matters more than the string itself.
- This lesson stays grounded in the most common scenario: text that must stay readable both on screen and through assistive tech.

# Quiz

The seed quiz in this first slice is data-backed, but the interactive quiz UI is intentionally deferred.

- You can still inspect the question prompts in the reader.
- The next milestone will turn them into navigable checkpoints with feedback and section jump links.
