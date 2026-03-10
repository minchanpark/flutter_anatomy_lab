#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 2 || $# -gt 4 ]]; then
  echo "Usage: $0 <lesson_id> <title> [track_id] [order_in_track]" >&2
  exit 1
fi

lesson_id="$1"
title="$2"
track_id="${3:-core_widgets_foundation}"
order_in_track="${4:-1}"

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
skill_dir="$(CDPATH= cd -- "$script_dir/.." && pwd)"
repo_root="$(CDPATH= cd -- "$skill_dir/../../.." && pwd)"
template_dir="$skill_dir/assets/templates"
lesson_dir="$repo_root/content/widgets/$lesson_id"
today="$(date +%F)"

if [[ -e "$lesson_dir" ]]; then
  echo "Lesson directory already exists: $lesson_dir" >&2
  exit 1
fi

mkdir -p "$lesson_dir"

render_template() {
  local src="$1"
  local dest="$2"

  sed \
    -e "s/__LESSON_ID__/$lesson_id/g" \
    -e "s/__TITLE__/$title/g" \
    -e "s/__TRACK_ID__/$track_id/g" \
    -e "s/__ORDER_IN_TRACK__/$order_in_track/g" \
    -e "s/__TODAY__/$today/g" \
    "$src" > "$dest"
}

render_template "$template_dir/lesson.md.template" "$lesson_dir/lesson.md"
render_template "$template_dir/anatomy.json.template" "$lesson_dir/anatomy.json"
render_template "$template_dir/quiz.json.template" "$lesson_dir/quiz.json"

echo "Scaffolded lesson files in $lesson_dir"
