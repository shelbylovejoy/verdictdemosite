#!/usr/bin/env bash
# Mechanical pass for AI tells in HTML/CSS. Prints leads for the ai-tells-reviewer agent.
# Usage: bash scripts/ai-tells-lint.sh [files...]   (default: every *.html and *.css in the repo, minus bundles)
set -u
cd "$(dirname "$0")/.."
if [ $# -gt 0 ]; then files=("$@"); else mapfile -t files < <(find . -path ./.git -prune -o \( -name '*.html' -o -name '*.css' \) -size -400k -print | sort); fi
hits=0
check() { # label, grep flags, pattern
  local label="$1" flags="$2" pat="$3" out
  out=$(grep -n $flags -- "$pat" "${files[@]}" 2>/dev/null | grep -v -E 'data:image|<svg|<path|transform:|&[a-z]+;' | head -40)
  if [ -n "$out" ]; then printf '\n## %s\n%s\n' "$label" "$out"; hits=$((hits + $(printf '%s\n' "$out" | wc -l))); fi
}
check "Em dashes" "-E" "—|&mdash;"
check "Semicolons in prose" "-E" ">[^<]*;[^<]*[a-z][^<]*<"
check "Arrows used as decoration" "-E" "→|↗|←|↓|&rarr;|&larr;"
check "Emoji" "-P" "[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}✨✅]"
check "Generic sans fonts" "-iE" "font-family:[^;]*(inter|roboto|poppins|montserrat|space grotesk|plus jakarta|system-ui|-apple-system|segoe)"
check "Gradients, blur, glass, glow" "-iE" "linear-gradient|radial-gradient|conic-gradient|backdrop-filter|filter:[^;]*blur|text-shadow:[^;]*rgba|box-shadow:[^;]*(rgba\([^)]*,\s*0?\.[5-9]|0 0 [2-9][0-9]px)"
check "Pill buttons" "-E" "border-radius:\s*(999px|9999px|50px|100px)"
check "Heavy drop shadows" "-E" "box-shadow:[^;]*[2-9][0-9]px [4-9][0-9]px"
check "Buzzwords" "-iwE" "seamless|leverage|elevate|empower|robust|delve|journey|passionate|curated|intentional|thoughtful|human-centered|impactful|unlock|transform|ecosystem|landscape|tapestry|testament|navigate|resonate|foster|showcase|stunning|vibrant|innovative|cutting-edge|world-class|game-changing|supercharge|streamline|synergy"
check "Stock phrases" "-iE" "it'?s not (just )?[a-z ]+, it'?s|not just [a-z ]+,? but|here'?s the thing|let'?s dive|in today'?s|at its core|along the way|building things|lifelong learner|problem[- ]solver|at the intersection|let'?s talk|get in touch|let'?s build|could it be|ready to"
check "Rhetorical question in a heading or CTA" "-E" "<(h[1-6]|a|button)[^>]*>[^<]*\?"
check "Rubric-style labels" "-iE" "(skill|skills|competenc)[^<]{0,4}:"
check "Stat tiles (big number over label)" "-iE" "class=\"[^\"]*(stat|big-number|kpi|metric-tile)[^\"]*\""
check "Icon card grids" "-iE" "class=\"[^\"]*(feature-card|icon-card|card-grid|features-grid)[^\"]*\""
check "Checkmark lists" "-E" "✓|✔|&check;"
check "Colons introducing lists in meta/alt" "-E" "(content|alt)=\"[^\"]*:[^\"]*,[^\"]*,[^\"]*\""
printf '\n%d lead(s) across %d file(s). Leads are not verdicts: read the page.\n' "$hits" "${#files[@]}"
