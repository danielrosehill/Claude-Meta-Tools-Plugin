---
name: feedback-bug
description: File a well-formed bug report against anthropics/claude-code. Use when the user wants to "report a bug", "file a bug", "open an issue", or describes unexpected/broken behavior in Claude Code they want Anthropic to fix. Interviews the user against Anthropic's live bug_report.yml issue form, renders the body exactly as the form expects, and submits via `gh issue create`.
---

# Filing a bug report against anthropics/claude-code

You are helping the user file a bug report that will pass Anthropic's issue-form validation on first submission. The target repo is **anthropics/claude-code**.

## The self-healing principle

Anthropic's issue templates change. Do **not** rely on the field list in your head or on any hardcoded mapping. On every invocation, fetch the live template and build the report from whatever fields it currently declares.

## Step-by-step procedure

### 1. Fetch the live template

Try the live copy first, fall back to the cached copy in this skill's `templates/` directory.

```bash
LIVE_URL="https://raw.githubusercontent.com/anthropics/claude-code/main/.github/ISSUE_TEMPLATE/bug_report.yml"
CACHE="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/../..}/skills/bug/templates/bug_report.yml"
TEMPLATE="$(mktemp --suffix=.yml)"
if curl -fsSL "$LIVE_URL" -o "$TEMPLATE"; then
  echo "Using live template"
else
  cp "$CACHE" "$TEMPLATE"
  echo "WARN: live fetch failed, using cached template"
fi
```

If the live fetch succeeds **and** differs from cache, note it to the user at the end ("template has drifted, consider running /refresh-templates").

### 2. Parse the template

The template is a GitHub issue-form YAML. Read it (use the Read tool) and extract:

- Top-level `title:` prefix (e.g. `"[BUG] "`)
- Top-level `labels:` array
- `body:` — each item with `type`, `id`, `attributes` (`label`, `description`, `options`, `placeholder`, `value`), and optional `validations.required`

Skip `type: markdown` items — they are display-only instructions for the human filler, not input fields.

### 3. Gather field values

For each non-markdown body item, collect a value:

| Type          | How to gather                                                                              | How to render in body                                                  |
|---------------|--------------------------------------------------------------------------------------------|------------------------------------------------------------------------|
| `checkboxes`  | For each option, confirm with the user (default: checked if the statement is accurate)     | `- [x] Label text` / `- [ ] Label text`, one per line                  |
| `textarea`    | Ask the user (or reuse what they already told you in conversation)                          | Plain text, preserve newlines. If `render: shell` wrap in ```` ```shell ```` ```` ``` ```` fence |
| `input`       | Ask the user                                                                                | Single line                                                            |
| `dropdown`    | Offer the options; pick the best match from what the user has said (ask if ambiguous)       | The selected option text verbatim                                      |
| empty/skipped | If `validations.required: false`                                                             | `_No response_`                                                        |

**Preferred source order for each field**:
1. What the user has already described in this conversation.
2. What you can infer from the environment (e.g. `claude --version`, `uname`, terminal).
3. Ask the user directly. Batch your questions — ask for everything you still need in one go, not field-by-field.

**Environment auto-fill**: For obvious fields, just run the command and use the output. Don't ask the user what `claude --version` returns — run it.

### 4. Build the issue body

The rendered body is a flat markdown document where each non-markdown field becomes:

```
### {attributes.label}

{rendered value}

```

Order matches the template's `body:` order. Blank line between sections.

### 5. Build the title

Title format: `{template.title}{user's one-line summary}`. The `title` prefix from the template (e.g. `"[BUG] "`) is already set — append a concise description of the bug. Keep under ~90 chars.

### 6. Preview and confirm

Before submission, show the user:
- Final title
- Final body (full)
- Labels that will be applied
- Target repo: `anthropics/claude-code`

Ask: "Submit to GitHub now? (yes/no/edit)". On `edit`, let them specify which section to revise.

### 7. Submit

```bash
gh issue create \
  --repo anthropics/claude-code \
  --title "$TITLE" \
  --body-file "$BODY_FILE" \
  $(for l in "${LABELS[@]}"; do echo --label "$l"; done)
```

**Important**: labels from the template may not all be settable by external contributors (some repos restrict label application). If `gh issue create` rejects a label, retry without `--label` and note to the user that labels will be applied by Anthropic's triage.

After success, print the issue URL.

### 8. Post-submission

- Offer to update the local cache (`templates/bug_report.yml`) if the live template had drifted.
- If an archive directory is configured (e.g. the user has pointed you at one, or a `CLAUDE_CODE_FEEDBACK_ARCHIVE` env var is set), offer to save a copy of the submitted report there.

## Rules and guardrails

- **Don't invent facts.** If you don't know the user's Claude Code version, run `claude --version`. If you don't know the OS, run `uname -a`. Don't guess.
- **Don't pre-check items the user hasn't confirmed.** The preflight checkboxes assert things like "I have searched existing issues" — ask the user, don't assume.
- **Search existing issues first.** Before drafting, run `gh search issues --repo anthropics/claude-code --state open --label bug "$KEYWORDS"` and surface any close matches. Ask the user if any of the hits are actually the same bug — if yes, offer to add a comment instead of opening a new issue.
- **One bug per report.** If the user describes several issues, file them separately (or ask which to file first).
- **No secrets in reports.** Scan the error output / repro steps for API keys, tokens, emails, hostnames, usernames — redact before submission and flag to the user what you redacted. Don't include private contact info.
