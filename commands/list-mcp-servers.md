---
description: List all available MCP servers in the catalog, optionally filtered by category
argument-hint: "[category filter, e.g. 'payments', 'databases', 'devops']"
---

Display the available MCP servers from the curated catalog. If the user provided a category filter via $ARGUMENTS, show only servers matching that category. Otherwise show the full catalog grouped by category.

## Full Server Catalog

### Development & Testing Tools
| Server | Transport | Auth | Command |
|--------|-----------|------|---------|
| Sentry | HTTP | OAuth | `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` |
| Socket | HTTP | OAuth | `claude mcp add --transport http socket https://mcp.socket.dev/` |
| Hugging Face | HTTP | OAuth | `claude mcp add --transport http hugging-face https://huggingface.co/mcp` |
| Jam | HTTP | OAuth | `claude mcp add --transport http jam https://mcp.jam.dev/mcp` |
| GitHub | HTTP | OAuth | `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` |

### Project Management & Documentation
| Server | Transport | Auth | Command |
|--------|-----------|------|---------|
| Asana | SSE* | OAuth | `claude mcp add --transport sse asana https://mcp.asana.com/sse` |
| Atlassian | SSE* | OAuth | `claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse` |
| Linear | HTTP | OAuth | `claude mcp add --transport http linear https://mcp.linear.app/mcp` |
| Notion | HTTP | OAuth | `claude mcp add --transport http notion https://mcp.notion.com/mcp` |
| Intercom | HTTP | OAuth | `claude mcp add --transport http intercom https://mcp.intercom.com/mcp` |
| Box | HTTP | OAuth | `claude mcp add --transport http box https://mcp.box.com/` |
| Fireflies | HTTP | OAuth | `claude mcp add --transport http fireflies https://api.fireflies.ai/mcp` |
| Monday | SSE* | OAuth | `claude mcp add --transport sse monday https://mcp.monday.com/sse` |
| ClickUp | Stdio | API Key | `claude mcp add --transport stdio clickup --env CLICKUP_API_KEY=YOUR_KEY --env CLICKUP_TEAM_ID=YOUR_ID -- npx -y @hauptsache.net/clickup-mcp` |

### Databases & Data Management
| Server | Transport | Auth | Command |
|--------|-----------|------|---------|
| Airtable | Stdio | API Key | `claude mcp add --transport stdio airtable --env AIRTABLE_API_KEY=YOUR_KEY -- npx -y airtable-mcp-server` |
| Daloopa | HTTP | OAuth | `claude mcp add --transport http daloopa https://mcp.daloopa.com/server/mcp` |
| HubSpot | HTTP | OAuth | `claude mcp add --transport http hubspot https://mcp.hubspot.com/anthropic` |
| PostgreSQL (DBHub) | Stdio | DSN | `claude mcp add --transport stdio <name> -- npx -y @bytebase/dbhub --dsn "postgresql://user:pass@host:5432/db"` |

### Payments & Commerce
| Server | Transport | Auth | Command |
|--------|-----------|------|---------|
| PayPal | HTTP | OAuth | `claude mcp add --transport http paypal https://mcp.paypal.com/mcp` |
| Plaid | SSE* | OAuth | `claude mcp add --transport sse plaid https://api.dashboard.plaid.com/mcp/sse` |
| Square | SSE* | OAuth | `claude mcp add --transport sse square https://mcp.squareup.com/sse` |
| Stripe | HTTP | OAuth | `claude mcp add --transport http stripe https://mcp.stripe.com` |

### Design & Media
| Server | Transport | Auth | Command |
|--------|-----------|------|---------|
| Figma | HTTP | OAuth | `claude mcp add --transport http figma-remote-mcp https://mcp.figma.com/mcp` |
| invideo | SSE* | OAuth | `claude mcp add --transport sse invideo https://mcp.invideo.io/sse` |
| Canva | HTTP | OAuth | `claude mcp add --transport http canva https://mcp.canva.com/mcp` |

### Infrastructure & DevOps
| Server | Transport | Auth | Command |
|--------|-----------|------|---------|
| Netlify | HTTP | OAuth | `claude mcp add --transport http netlify https://netlify-mcp.netlify.app/mcp` |
| Vercel | HTTP | OAuth | `claude mcp add --transport http vercel https://mcp.vercel.com/` |
| Stytch | HTTP | OAuth | `claude mcp add --transport http stytch http://mcp.stytch.dev/mcp` |

### Automation & Integration
| Server | Notes |
|--------|-------|
| Zapier | Generate a user-specific URL at mcp.zapier.com, then use HTTP transport |
| Workato | MCP servers are programmatically generated — see Workato documentation |

*SSE transport is deprecated. These servers have not yet migrated to HTTP.

## Authentication Notes

- **OAuth servers**: After adding, run `/mcp` inside Claude Code to authenticate via browser.
- **API Key servers**: Replace placeholder values (e.g. `YOUR_KEY`) with your actual credentials.
- **Database DSN**: Replace the connection string with your actual database URL.

If the user asked to filter by category, show only the relevant table(s) and omit the rest.
