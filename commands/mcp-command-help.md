---
description: Show the full Claude Code MCP command syntax reference, including management commands, scopes, authentication types, and platform-specific notes
---

Display a comprehensive reference for Claude Code MCP commands.

## Command Structure

### HTTP Servers (Recommended)
```bash
claude mcp add --transport http <name> <url>
```
Optional flags:
- `--scope [local|project|user]`
- `--header "<key>: <value>"`
- `--env <KEY>=<value>`

Examples:
```bash
claude mcp add --transport http notion https://mcp.notion.com/mcp
claude mcp add --transport http api --header "Authorization: Bearer token" https://api.example.com/mcp
```

### SSE Servers (Deprecated)
```bash
claude mcp add --transport sse <name> <url>
```
Same optional flags as HTTP. Prefer HTTP when a server supports it.

### Stdio Servers (Local / npm packages)
```bash
claude mcp add --transport stdio <name> [--env KEY=value] -- <command> [args...]
```
The `--` separator is required. Everything before `--` are Claude flags; everything after is the server command.

Examples:
```bash
claude mcp add --transport stdio airtable --env AIRTABLE_API_KEY=YOUR_KEY -- npx -y airtable-mcp-server
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub --dsn "postgresql://user:pass@host:5432/mydb"
```

## Management Commands

```bash
claude mcp list                          # List all configured servers
claude mcp get <name>                    # Get details for a server
claude mcp remove <name>                 # Remove a server
claude mcp add-json <name> '<json>'      # Add server from JSON config
claude mcp add-from-claude-desktop       # Import from Claude Desktop (macOS/WSL only)
claude mcp reset-project-choices         # Reset .mcp.json approval choices
```

Within Claude Code:
```
/mcp    # Check server status and authenticate OAuth servers
```

## Configuration Scopes

| Scope | Storage | Use When |
|-------|---------|----------|
| `local` (default) | User settings, project-specific | Personal use on one project |
| `project` | `.mcp.json` in repo root | Shared with your team |
| `user` | User settings, all projects | Personal cross-project tools |

Precedence: local > project > user > enterprise

## Authentication Types

**OAuth** — Remote servers using OAuth 2.0
- Add the server, then authenticate with `/mcp` in Claude Code
- Works with HTTP and SSE transports

**API Key** — Via environment variables
- Pass with `--env KEY=value` (for stdio, before the `--` separator)
- Multiple keys: `--env KEY1=val1 --env KEY2=val2`

**Headers** — For HTTP/SSE servers
- Pass with `--header "Key: Value"`

## JSON Configuration Format

For `claude mcp add-json`:

HTTP server:
```json
{
  "type": "http",
  "url": "https://api.example.com/mcp",
  "headers": { "Authorization": "Bearer token" }
}
```

Stdio server:
```json
{
  "type": "stdio",
  "command": "/path/to/server",
  "args": ["--flag", "value"],
  "env": { "API_KEY": "value" }
}
```

## Variable Expansion in .mcp.json

Supported syntax:
- `${VAR}` — expands to the environment variable value
- `${VAR:-default}` — uses default if VAR is not set

Can be used in: `command`, `args`, `env`, `url`, `headers`

Example:
```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": { "Authorization": "Bearer ${API_TOKEN}" }
    }
  }
}
```

## Platform-Specific Notes

**Windows (non-WSL)** — stdio servers with `npx` require a `cmd /c` wrapper:
```bash
claude mcp add --transport stdio server -- cmd /c npx -y package-name
```

**macOS / WSL** — can import from Claude Desktop:
```bash
claude mcp add-from-claude-desktop
```

## Troubleshooting

Increase server startup timeout:
```bash
MCP_TIMEOUT=10000 claude    # 10 seconds
```

Allow larger outputs:
```bash
MAX_MCP_OUTPUT_TOKENS=50000 claude
```

Check status and re-authenticate:
```
/mcp    # shows status; select "Clear authentication" to reset OAuth
```

Present this reference clearly to the user, highlighting the sections most relevant to their question if they asked a specific one.
