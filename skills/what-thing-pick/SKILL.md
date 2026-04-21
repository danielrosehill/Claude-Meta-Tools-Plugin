---
name: what-thing-pick
description: Decide which Claude Code primitive (skill, subagent, slash command, plugin, MCP server, hook, output style) to use for a workflow idea. Triggers on "should I build this as a skill", "how do I extend Claude Code for X", "skill vs command vs plugin", "where should this live", or any question about choosing between Claude Code extension mechanisms.
---

# Pick the right Claude Code primitive

Your job is to help the user pick the right **primitive** and **install scope** for a Claude Code extension they want to build. You interview them briefly, ground your reasoning in the bundled reference docs, and produce a specific recommendation with next steps.

## Step 1 — Load context

Before asking anything, read these files (relative to the plugin root):

1. `reference/primitives.md` — canonical definitions of each primitive
2. `reference/decision-rules.md` — the decision tree you apply
3. `reference/docs-snapshot.md` — key excerpts from the official Anthropic docs

Then check for persistent user context at `<plugin-data-dir>/context.md` — where `<plugin-data-dir>` resolves as `$CLAUDE_USER_DATA/meta-tools/` if `CLAUDE_USER_DATA` is set; otherwise `$XDG_DATA_HOME/claude-plugins/meta-tools/` if `XDG_DATA_HOME` is set; otherwise `~/.local/share/claude-plugins/meta-tools/`. See the canonical convention in the `meta-tools:plugin-data-storage` skill. If it exists, read it — it contains the user's development patterns (solo vs team, public vs private, MCP comfort level, etc.) and should shape your recommendation. If it doesn't exist, proceed without it but mention at the end that `/what-thing:set-context` can tailor future recommendations.

## Step 2 — Understand the goal

The user has typed `/what-thing:pick` possibly with arguments describing their goal: $ARGUMENTS

If they've described the goal clearly, restate it back in one sentence and move on. If the argument is empty or vague, ask: *"In one or two sentences, what do you want Claude to do for you?"*

## Step 3 — Diagnostic interview

Ask only the questions you still need to answer — skip any that the user already covered or that their stored context answers. Target 3–5 questions max. Do not ask them all at once; go one or two at a time, conversationally.

Core diagnostics (adapt wording to the situation):

1. **Invocation** — Should Claude do this automatically when relevant, or should you type a command to trigger it?
2. **External systems** — Does this need to talk to an external API, service, database, or existing tool (GitHub, Notion, your own service, etc.)?
3. **Sub-task isolation** — Does it need its own fresh context window / system prompt / tool restrictions, or should it run inline in the current session?
4. **Trigger event** — Does it need to run deterministically when something happens (before a tool call, after Claude stops, on every prompt submit), rather than when you or Claude decide to invoke it?
5. **Audience** — Is this just for you, for a team/repo, or for public distribution?
6. **Bundle size** — Is this one small thing, or a related set of commands/skills/agents you want to ship together?

Use stored context to skip audience/distribution questions if already known.

## Step 4 — Apply the decision rules

Consult `reference/decision-rules.md` and identify the primary primitive. Note where two primitives overlap (common — e.g. skill vs command) and name the specific reason one wins for this user.

## Step 5 — Recommend

Return a single recommendation with this structure. Keep it tight.

```
## Recommendation: <primitive name> at <scope>

**Why this over the alternatives:** <2–3 sentences, naming the closest runner-up and the deciding factor>

**Where it lives:** <exact path, e.g. ~/.claude/skills/my-thing/SKILL.md>

**Next step:** <the exact skill or command they should run next, or the exact file to create>

**Official docs:** <relevant URL from docs-snapshot.md>
```

If the user has no stored context and it would have materially changed the recommendation (e.g. team vs solo), add one line suggesting they run `/what-thing:set-context`.

## Style

- Concise. No preamble. No recap of the user's question back at them beyond the one-sentence restatement in Step 2.
- Assume the user is technically competent but may not know the precise primitive vocabulary yet — link to `reference/primitives.md` if they need a definition.
- Do not implement the thing. Your job ends at the recommendation. If the user wants you to build it, that's a follow-up turn.
- When two primitives genuinely tie, say so explicitly and give the tradeoff rather than picking arbitrarily.
