---
name: feedback-docs
description: File a documentation issue against anthropics/claude-code — missing docs, outdated docs, incorrect docs, or docs improvements. Use when the user says "the docs are wrong", "can't find docs for X", "the docs contradict the behavior", or similar.
---

# Filing a documentation issue against anthropics/claude-code

For complaints about Anthropic's Claude Code documentation: wrong, missing, outdated, unclear, or contradictory. Target repo: **anthropics/claude-code**.

## Self-healing principle

Always fetch the live template; never assume the field list.

## Procedure

### 1. Fetch the live template

```bash
LIVE_URL="https://raw.githubusercontent.com/anthropics/claude-code/main/.github/ISSUE_TEMPLATE/documentation.yml"
CACHE="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/../..}/skills/docs/templates/documentation.yml"
TEMPLATE="$(mktemp --suffix=.yml)"
curl -fsSL "$LIVE_URL" -o "$TEMPLATE" || cp "$CACHE" "$TEMPLATE"
```

### 2. Parse, 3. Gather, 4. Build body, 5. Title, 6. Preview, 7. Submit

Same mechanics as the `bug` skill. See that skill's SKILL.md for the full field-rendering table and submission pattern.

**Specific to docs reports**:

- **Always include the doc URL.** If the user didn't mention it, ask — a docs report without a URL is hard to triage.
- **Quote the problematic passage verbatim** (if there is one). Don't paraphrase. Anthropic's triagers need to find the exact text.
- **State what it should say** (or what's missing) if the user is confident.
- **Search first**: `gh search issues --repo anthropics/claude-code --label "documentation" "$KEYWORDS"`.

### 8. Post-submission

- Update cache if template drifted.
- If an archive directory is configured, offer to save a copy of the submitted report there.

## Rules

- **URL is mandatory** even if the template doesn't list it as required — a docs issue without a URL is hard to act on.
- **Don't file "docs should explain everything" reports**. Scope tight: one specific page, one specific claim or omission.
- **Redact** any private config shown in user quotes of docs they were following.
