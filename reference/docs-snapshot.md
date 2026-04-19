# Claude Code docs — snapshot

_Pulled: (none yet — run `/what-thing:refresh-docs` to populate)_

## Sources

The canonical pages to ground recommendations in. Resolve exact URLs from the docs index on first refresh; these are the section names to look for on `https://docs.claude.com/`:

- Slash commands
- Agent skills
- Subagents
- Plugins
- MCP server configuration
- Hooks
- Output styles
- Settings

---

## How this file is used

`/what-thing:pick` reads this file to cite authoritative sources when making a recommendation. The bundled `reference/primitives.md` is the plugin's own interpretation; this file holds dated excerpts from the official docs so recommendations can point the user at the URL Anthropic themselves publishes.

When this snapshot is empty or stale, recommendations will still work — they fall back to `reference/primitives.md` — but citations will be generic ("see the Claude Code docs") rather than linked.

Run `/what-thing:refresh-docs` to populate or refresh.

---

## (Excerpts populate below after first refresh)
