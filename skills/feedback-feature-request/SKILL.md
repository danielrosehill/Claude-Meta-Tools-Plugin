---
name: feedback-feature-request
description: File a well-formed feature request against anthropics/claude-code. Use when the user wants to "request a feature", "suggest an enhancement", "propose an improvement", or describes something they wish Claude Code could do that it currently can't. Interviews the user against Anthropic's live feature_request.yml issue form and submits via `gh issue create`.
---

# Filing a feature request against anthropics/claude-code

You are helping the user file a feature request that will pass Anthropic's issue-form validation on first submission. Target repo: **anthropics/claude-code**.

## Self-healing principle

Issue templates change. Always fetch the live copy and build the report from its current fields. Never assume the field list from memory.

## Procedure

### 1. Fetch the live template

```bash
LIVE_URL="https://raw.githubusercontent.com/anthropics/claude-code/main/.github/ISSUE_TEMPLATE/feature_request.yml"
CACHE="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/../..}/skills/feature-request/templates/feature_request.yml"
TEMPLATE="$(mktemp --suffix=.yml)"
curl -fsSL "$LIVE_URL" -o "$TEMPLATE" || cp "$CACHE" "$TEMPLATE"
```

Note any drift between live and cache to mention to the user at the end.

### 2. Parse

Read the YAML, extract `title` prefix, `labels`, and the `body:` array. Skip `type: markdown` items.

### 3. Gather values

Same rendering rules as the bug skill — see table below:

| Type          | How to gather                                            | How to render                                                 |
|---------------|----------------------------------------------------------|---------------------------------------------------------------|
| `checkboxes`  | Confirm each with the user (default: accurate assertions checked) | `- [x] Label` / `- [ ] Label`, one per line          |
| `textarea`    | Ask the user, reuse what they already said                | Plain text, preserve newlines; use shell fence if `render: shell` |
| `input`       | Ask the user                                              | Single line                                                   |
| `dropdown`    | Offer options, best-match from context                    | Selected option text verbatim                                 |
| empty         | Only if `validations.required: false`                     | `_No response_`                                               |

**Batch questions**: ask for everything you still need in one go, not per-field.

**Before drafting, search existing requests**:

```bash
gh search issues --repo anthropics/claude-code --label enhancement "$KEYWORDS"
```

If a close match exists, surface it to the user — they may want to comment/+1 instead of opening a new one.

### 4. Build body

For each non-markdown field in order:

```
### {attributes.label}

{value}

```

### 5. Title

`{template.title prefix}{concise one-line description of the feature}`. Typically `"[FEATURE] "`. Keep under ~90 chars.

### 6. Preview and confirm

Show title, body, labels, target repo. Wait for `yes` / `no` / `edit`.

### 7. Submit

```bash
gh issue create --repo anthropics/claude-code \
  --title "$TITLE" --body-file "$BODY_FILE" \
  $(for l in "${LABELS[@]}"; do echo --label "$l"; done)
```

Fall back to no-labels if a label is rejected. Print the issue URL on success.

### 8. Post-submission

- Offer to update cache if template drifted.
- If an archive directory is configured (env var or user preference), offer to save a copy of the submitted request there.

## Rules

- **Frame the request as the problem, not the solution.** A well-formed FR explains *what the user is trying to do* and *what's blocking them*, then optionally proposes a shape for the solution. Don't let the user open with "please add a `--foo` flag" — draw out why.
- **One feature per request.** Split multi-feature asks.
- **Don't embellish.** If the user is vague, ask — don't invent use-cases they didn't describe.
- **No duplicates.** Run the search step even if the user is confident it's novel.
- **Redact secrets** from any config snippets before submission.
