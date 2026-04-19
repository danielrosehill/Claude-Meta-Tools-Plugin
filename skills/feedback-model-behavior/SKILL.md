---
name: feedback-model-behavior
description: File a report about Claude's model behavior (bad responses, refusals, hallucinations, policy misfires, poor code quality) against anthropics/claude-code. Use when the user is unhappy with *what Claude said or did* — as opposed to a CLI/tool bug. Distinct from the bug skill, which covers CLI/harness issues.
---

# Filing a model-behavior report against anthropics/claude-code

Model-behavior reports are for complaints about **what the model produced** — wrong answer, bad code, unwarranted refusal, hallucinated API, broken tool call, off-topic response. Not for CLI bugs, not for feature requests, not for doc issues.

If the user's complaint is really about the CLI, hooks, permissions, MCP, settings — redirect to the `bug` skill. If it's about missing functionality, redirect to `feature-request`.

## Self-healing principle

Always fetch the live template; never assume the field list.

## Procedure

### 1. Fetch the live template

```bash
LIVE_URL="https://raw.githubusercontent.com/anthropics/claude-code/main/.github/ISSUE_TEMPLATE/model_behavior.yml"
CACHE="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/../..}/skills/model-behavior/templates/model_behavior.yml"
TEMPLATE="$(mktemp --suffix=.yml)"
curl -fsSL "$LIVE_URL" -o "$TEMPLATE" || cp "$CACHE" "$TEMPLATE"
```

### 2. Parse

Read the YAML, extract title prefix, labels, body array. Skip `type: markdown` items.

### 3. Gather values

Standard rendering rules (see `bug` skill for the full table). Key behaviors specific to model-behavior reports:

- **Capture the actual conversation**. The report is useless without the prompt + response. Ask the user to paste the exchange, or — if it's from the current session — offer to extract it from conversation history. **Redact any secrets, filenames that identify the user's work, or personal info** before including.
- **Capture the model ID**. Run `/model` or check recent output. Don't guess.
- **Capture Claude Code version** via `claude --version`.
- **Auto-fill environment fields** (OS, terminal) — don't ask the user to type things you can detect.

**Before drafting, search existing reports**:

```bash
gh search issues --repo anthropics/claude-code --label "model-behavior" "$KEYWORDS"
```

### 4. Build body, title, preview, submit

Same pattern as the bug skill:

- Body: `### {label}\n\n{value}\n\n` per non-markdown field, in order.
- Title: template prefix (e.g. `"[MODEL] "`) + one-line summary.
- Show preview, wait for `yes`/`no`/`edit`.
- Submit via `gh issue create`, retry without labels if any are rejected.

### 5. Post-submission

- Update cache if template drifted.
- If an archive directory is configured, offer to save a copy of the submitted report there.

## Rules

- **Redact aggressively.** Model transcripts often contain user code, filenames, secrets, prompts with private context. Default to redacting; confirm with the user before including anything that could be sensitive.
- **Include the full exchange**, not just the bad output. Reproducibility depends on the prompt.
- **Distinguish refusal from error.** A refusal ("I can't help with that") is a different report class than a wrong answer. State which.
- **One behavior per report.**
- **Don't lecture the user** on how to prompt better — this is their report, your job is to formalize it, not to second-guess it.
