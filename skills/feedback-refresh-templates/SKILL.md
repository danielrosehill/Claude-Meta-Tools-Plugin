---
name: feedback-refresh-templates
description: Refresh cached Anthropic claude-code issue-form templates and detect drift or new template types. Use when the user says "refresh templates", "update feedback templates", "check for template changes", or when a previous feedback-skill run reported drift. Also discovers newly-added issue-template types in the upstream repo.
---

# Refreshing cached issue-form templates

This plugin fetches templates live at run time, but also caches copies for offline fallback. This skill refreshes those cached copies and surfaces any template drift or new template types.

## Procedure

### 1. Run the refresh script

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/refresh-templates.sh"
```

Output lines start with `OK`, `UPDATE`, `NEW`, or `NEW TEMPLATE TYPE DETECTED`.

### 2. Interpret output

- **OK** — no change, skip.
- **UPDATE** / **NEW** — cache was refreshed. Show the user the diff if they want (`git diff` the templates dir after running, since the plugin repo is checked in).
- **NEW TEMPLATE TYPE DETECTED: foo.yml** — Anthropic added a new issue form. This plugin **doesn't yet have a skill for it**. Offer to scaffold a new skill:
  1. Create `skills/<slug>/templates/<file>.yml` and fetch the template.
  2. Create `skills/<slug>/SKILL.md` — copy the structure of `skills/bug/SKILL.md` and adapt the `name`, `description`, URL, and type-specific guidance.
  3. Note to the user to bump the plugin version and publish.

### 3. Commit changes

If anything changed and the plugin repo is a git checkout, offer to commit + push:

```bash
cd "${CLAUDE_PLUGIN_ROOT}"
git add skills/*/templates/
git commit -m "chore: refresh cached issue-form templates"
git push
```

Commit all changes and push — don't leave template drift sitting uncommitted locally.

### 4. Report

Tell the user:
- Which templates updated (with a short description of what changed, from the diff).
- Whether new template types were detected (and whether a scaffold is needed).
- Whether the plugin repo was committed/pushed.
