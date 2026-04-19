---
name: what-thing-refresh-docs
description: Re-fetch the official Anthropic Claude Code documentation pages that this plugin grounds its recommendations in, and update reference/docs-snapshot.md with a fresh dated excerpt. Use when the user asks to refresh, update, or re-pull the Claude Code docs the plugin uses.
---

# Refresh the docs snapshot

Your job is to re-fetch the canonical Claude Code documentation pages and rewrite `reference/docs-snapshot.md` (relative to this plugin root) so `/what-thing:pick` reasons from current information.

## Step 1 — Identify URLs to fetch

Read the existing `reference/docs-snapshot.md`. At the top of the file is a `## Sources` list of URLs. Use those as the authoritative list.

If a source list is missing or the user asks you to add URLs, use these canonical starting points on `https://docs.claude.com/`:

- Slash commands
- Skills (agent skills)
- Subagents
- Plugins
- MCP server usage in Claude Code
- Hooks
- Output styles
- Settings

(Resolve the exact URLs by checking the docs site navigation — do not guess exact paths; fetch the docs index first if unsure.)

## Step 2 — Fetch

Use `WebFetch` for each URL. For each page, extract:

- The primitive's one-paragraph definition
- Its invocation model (auto vs manual, event-triggered, etc.)
- Its install scopes
- The canonical file path / layout
- Any "when to use" or "choose between" guidance the docs themselves offer

## Step 3 — Rewrite docs-snapshot.md

Replace the contents of `reference/docs-snapshot.md` with:

```markdown
# Claude Code docs — snapshot

_Pulled: YYYY-MM-DD (today)_

## Sources

- <URL 1>
- <URL 2>
...

---

## <Primitive name>

<Excerpt / summary per Step 2 above>

---

## <Next primitive>

...
```

Keep excerpts compact — a few sentences to a short paragraph per primitive. The goal is a reference the `pick` skill can scan quickly, not a full re-hosting of the docs.

## Step 4 — Confirm

Show the user the date stamp, the list of URLs pulled, and any primitives where the docs have meaningfully changed versus the previous snapshot (if you can tell from diff). Point out if any new primitive has shipped that isn't yet in `reference/primitives.md` — they may want to update that file too.

## Style

- Do not invent URLs. If a canonical URL can't be resolved, skip it and note it in the output.
- Respect robots and rate — fetch sequentially, not in parallel bursts.
- If `WebFetch` is not available in this session, say so and stop — do not fall back to training data.
