---
description: Generate a valid 'claude mcp add' command from a plain English description of what MCP server the user wants to install
argument-hint: "<description of MCP server you want, e.g. 'install notion' or 'connect to my postgres database'>"
allowed-tools: Bash
---

The user wants to install an MCP server. Their request: $ARGUMENTS

Generate the exact `claude mcp add` command to fulfil this request.

## Command Syntax Reference

### HTTP Servers (Recommended)
```
claude mcp add --transport http <name> <url>
```
Optional flags: `--scope [local|project|user]`, `--header "<key>: <value>"`, `--env <KEY>=<value>`

### SSE Servers (Deprecated — use HTTP when available)
```
claude mcp add --transport sse <name> <url>
```

### Stdio Servers (Local/npm packages)
```
claude mcp add --transport stdio <name> [--env KEY=value] -- <command> [args...]
```
The `--` separator is required. All `--env` flags go before `--`.

## Available MCP Servers by Category

### Development & Testing
- **Sentry**: `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` (OAuth)
- **Socket**: `claude mcp add --transport http socket https://mcp.socket.dev/` (OAuth)
- **Hugging Face**: `claude mcp add --transport http hugging-face https://huggingface.co/mcp` (OAuth)
- **Jam**: `claude mcp add --transport http jam https://mcp.jam.dev/mcp` (OAuth)
- **GitHub**: `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` (OAuth)

### Project Management
- **Asana**: `claude mcp add --transport sse asana https://mcp.asana.com/sse` (OAuth, SSE)
- **Atlassian** (Jira/Confluence): `claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse` (OAuth, SSE)
- **Linear**: `claude mcp add --transport http linear https://mcp.linear.app/mcp` (OAuth)
- **Notion**: `claude mcp add --transport http notion https://mcp.notion.com/mcp` (OAuth)
- **Intercom**: `claude mcp add --transport http intercom https://mcp.intercom.com/mcp` (OAuth)
- **Box**: `claude mcp add --transport http box https://mcp.box.com/` (OAuth)
- **Fireflies**: `claude mcp add --transport http fireflies https://api.fireflies.ai/mcp` (OAuth)
- **Monday**: `claude mcp add --transport sse monday https://mcp.monday.com/sse` (OAuth, SSE)
- **ClickUp**: `claude mcp add --transport stdio clickup --env CLICKUP_API_KEY=YOUR_KEY --env CLICKUP_TEAM_ID=YOUR_ID -- npx -y @hauptsache.net/clickup-mcp`

### Databases & Data
- **Airtable**: `claude mcp add --transport stdio airtable --env AIRTABLE_API_KEY=YOUR_KEY -- npx -y airtable-mcp-server`
- **Daloopa** (financial data): `claude mcp add --transport http daloopa https://mcp.daloopa.com/server/mcp` (OAuth)
- **HubSpot**: `claude mcp add --transport http hubspot https://mcp.hubspot.com/anthropic` (OAuth)
- **PostgreSQL/databases** (Bytebase DBHub): `claude mcp add --transport stdio <name> -- npx -y @bytebase/dbhub --dsn "postgresql://user:pass@host:5432/database"`

### Payments & Commerce
- **PayPal**: `claude mcp add --transport http paypal https://mcp.paypal.com/mcp` (OAuth)
- **Plaid**: `claude mcp add --transport sse plaid https://api.dashboard.plaid.com/mcp/sse` (OAuth, SSE)
- **Square**: `claude mcp add --transport sse square https://mcp.squareup.com/sse` (OAuth, SSE)
- **Stripe**: `claude mcp add --transport http stripe https://mcp.stripe.com` (OAuth)

### Design & Media
- **Figma**: `claude mcp add --transport http figma-remote-mcp https://mcp.figma.com/mcp` (OAuth)
- **invideo**: `claude mcp add --transport sse invideo https://mcp.invideo.io/sse` (OAuth, SSE)
- **Canva**: `claude mcp add --transport http canva https://mcp.canva.com/mcp` (OAuth)

### Infrastructure & DevOps
- **Netlify**: `claude mcp add --transport http netlify https://netlify-mcp.netlify.app/mcp` (OAuth)
- **Vercel**: `claude mcp add --transport http vercel https://mcp.vercel.com/` (OAuth)
- **Stytch**: `claude mcp add --transport http stytch http://mcp.stytch.dev/mcp` (OAuth)

## Command Generation Rules

1. **Name**: lowercase, hyphens for spaces/non-alphanumeric (e.g. "My Server" → "my-server")
2. **Transport priority**: HTTP over SSE; stdio for local/npm packages
3. **Scope**: default to `local` (no flag needed); suggest `project` for team tools, `user` for personal cross-project tools
4. **API key placeholders**: use descriptive names like `YOUR_AIRTABLE_API_KEY`
5. **OAuth servers**: just provide the URL — the user authenticates afterwards with `/mcp` inside Claude Code
6. **Stdio `--env` flags**: must appear before the `--` separator
7. **Windows note**: stdio servers with `npx` need a `cmd /c` wrapper on non-WSL Windows

## Your Task

1. Identify the server the user wants from the catalog above, or make a reasonable inference from their description.
2. Output the exact command on a single line.
3. If the server requires OAuth, add a brief note: "After adding, authenticate by running `/mcp` inside Claude Code."
4. If the server needs an API key, show the placeholder and tell the user where to replace it.
5. If the request is genuinely ambiguous or the server is not in the catalog, say so clearly and provide the closest match or a template.
6. Do not add unnecessary explanation — keep the response concise.
