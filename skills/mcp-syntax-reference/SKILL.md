---
name: mcp-syntax-reference
description: Teaches Claude the correct syntax for all Claude Code 'claude mcp add' command variants, covering HTTP, SSE, and stdio transports, scope options, authentication patterns, and command generation rules for MCP server installation.
---

# MCP Command Syntax Reference

This skill provides Claude with complete, authoritative knowledge of how to construct valid `claude mcp add` commands for Claude Code.

## Transport Types

### HTTP (Recommended)
```
claude mcp add --transport http <name> <url>
```

### SSE (Deprecated — prefer HTTP)
```
claude mcp add --transport sse <name> <url>
```

### Stdio (Local / npm packages)
```
claude mcp add --transport stdio <name> [--env KEY=value ...] -- <command> [args...]
```
The `--` separator is mandatory. `--env` flags and `--scope` must appear before `--`.

## Optional Flags (HTTP, SSE, Stdio)

- `--scope [local|project|user]` — configuration scope (default: `local`)
- `--header "<key>: <value>"` — HTTP/SSE only, repeatable
- `--env <KEY>=<value>` — set environment variable, repeatable; for stdio must precede `--`

## Scope Semantics

| Scope | Where stored | Who sees it |
|-------|-------------|-------------|
| `local` | User settings, per-project | Only the current user, current project |
| `project` | `.mcp.json` in repo root | Everyone who clones the repo |
| `user` | User settings, global | Only the current user, all projects |

Precedence (highest to lowest): local → project → user → enterprise

## Authentication Patterns

**OAuth** — add the server URL, then run `/mcp` inside Claude Code to authenticate.

**API Key via env** — `--env API_KEY=value`; use placeholder names like `YOUR_API_KEY` when the actual value is unknown.

**Bearer token via header** — `--header "Authorization: Bearer <token>"` for HTTP/SSE.

## Command Generation Rules

1. **Normalise the server name**: lowercase, replace spaces and non-alphanumeric characters with hyphens. Example: "My API" → `my-api`.
2. **Transport selection**: HTTP > SSE > Stdio. Use stdio for packages run via `npx`, `node`, or a local binary.
3. **Env flag placement**: for stdio, all `--env` flags must come before `--`.
4. **OAuth servers**: output only the `claude mcp add` command; note that the user must authenticate afterwards with `/mcp`.
5. **API key placeholders**: use descriptive uppercase names (`YOUR_AIRTABLE_API_KEY`) so the user knows exactly what to replace.
6. **Scope default**: omit `--scope` unless the user specifies a preference (default is `local`).
7. **Windows stdio**: on non-WSL Windows, `npx` commands require a `cmd /c` prefix after `--`.

## Management Commands

```bash
claude mcp list                      # list configured servers
claude mcp get <name>                # show details
claude mcp remove <name>             # delete a server
claude mcp add-json <name> '<json>'  # add from JSON blob
claude mcp add-from-claude-desktop   # import from Claude Desktop (macOS/WSL)
claude mcp reset-project-choices     # reset .mcp.json approval state
```

## JSON Config Formats

HTTP:
```json
{ "type": "http", "url": "https://...", "headers": { "Authorization": "Bearer token" } }
```

Stdio:
```json
{ "type": "stdio", "command": "/path/to/bin", "args": ["--flag"], "env": { "KEY": "value" } }
```

## Variable Expansion in .mcp.json

- `${VAR}` — value of environment variable VAR
- `${VAR:-default}` — VAR if set, otherwise "default"

Supported in: `command`, `args`, `env`, `url`, `headers`

## Environment Variables for Tuning

- `MCP_TIMEOUT=<ms>` — server startup timeout (e.g. `10000` for 10 s)
- `MAX_MCP_OUTPUT_TOKENS=<n>` — max output tokens per response (default 25 000; warning at 10 000)
