---
name: what-thing-help
description: Show a one-screen cheat sheet of Claude Code primitives (skill, subagent, slash command, plugin, MCP server, hook, output style) and when to use each. Use when the user asks for a quick reference, an overview of the Claude Code extension surface, or "what are all the ways I can extend Claude Code".
---

# What Thing — cheat sheet

Read `reference/primitives.md` (relative to this plugin root) and present the user with a compact cheat sheet derived from it.

Format as a terse table or short list — one line per primitive naming:

1. What it is (one phrase)
2. When to pick it (the canonical "use this when…" signal)
3. Where it installs

Do not dump the full reference file. The goal is a screenful they can scan in 15 seconds.

End with two pointers:

- *Want a recommendation for a specific idea?* → `/what-thing:pick <describe your idea>`
- *Want recommendations tailored to how you work?* → `/what-thing:set-context`
