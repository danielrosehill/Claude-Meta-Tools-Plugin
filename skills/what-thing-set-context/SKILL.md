---
name: what-thing-set-context
description: Capture the user's Claude Code development patterns (solo vs team, public vs private distribution, MCP comfort, default install scope) into ~/.claude/what-thing-context.md so future recommendations from /what-thing:pick are tailored. Use when the user asks to set, update, review, or clear their what-thing context.
---

# Set persistent context for What Thing

Your job is to interview the user briefly and write a short markdown file to `~/.claude/what-thing-context.md`. The `/what-thing:pick` skill reads this file before making recommendations, so the facts you capture here directly shape future advice.

## Step 1 — Check existing context

Read `~/.claude/what-thing-context.md` if it exists. If it does, show the user the current values and ask whether they want to update specific fields or rewrite from scratch.

If it does not exist, proceed to a fresh interview.

## Step 2 — Interview

Ask the questions one or two at a time, conversationally. Skip any the user has already answered.

1. **Solo or team?** Are you mostly building Claude Code extensions for yourself, or for a team/repo where others will use them too?
2. **Default distribution?** When you make something worth keeping, do you tend to publish it publicly on GitHub, keep it in a private repo, or leave it user-scoped on your machine?
3. **MCP comfort?** How do you feel about MCP servers — happy to run and maintain them, or prefer to avoid the extra moving parts unless the use case really demands it?
4. **Default scope preference?** Do you default to user-level extensions (available everywhere) or project-level (checked into the specific repo)?
5. **Anything else worth remembering?** Languages you mostly work in, tools you already have set up, constraints that should shape recommendations, etc.

Do not pad with extra questions. Five is the cap.

## Step 3 — Write the file

Write `~/.claude/what-thing-context.md` with this structure. Keep each field to one or two sentences — this file should stay short enough to fully load into context.

```markdown
# What Thing — user context

_Last updated: YYYY-MM-DD_

## Development pattern
<solo / team / mixed — one sentence>

## Default distribution
<public GitHub / private / local-only — one sentence>

## MCP server comfort
<happy to maintain / prefer to avoid / case-by-case — one sentence>

## Default install scope
<user / project / depends — one sentence>

## Other notes
<anything else the user wants remembered>
```

Fill in today's date (use the `currentDate` the harness already gave you if available, otherwise ask the user).

## Step 4 — Confirm

Show the user the final file contents and confirm it's saved at `~/.claude/what-thing-context.md`. Mention that they can edit it by hand any time.

## Style

- Short questions. No lectures about why the plugin needs this.
- Accept "skip" or "don't know" for any question — write `<not specified>` in that field.
- Do not write fields you didn't actually confirm with the user.
