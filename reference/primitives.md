# Claude Code primitives — canonical reference

The **extension surface** of Claude Code is the collective term for every way you can extend or customize the harness. Individual mechanisms within it are called **primitives**. This file defines each primitive, its invocation model, its install scope, and the "use this when…" signal that makes it the right pick.

---

## Slash command

**What it is** — A markdown file whose contents are injected into the conversation as a user prompt when the command is typed.

**Invocation** — User types `/name` (or `/namespace:name` when from a plugin).

**Install scope** —
- User: `~/.claude/commands/<name>.md`
- Project: `.claude/commands/<name>.md` (checked into the repo, shared with anyone who clones it)
- Plugin: bundled under `commands/` in a plugin repo

**File shape** — Markdown body becomes the prompt. `$ARGUMENTS` is substituted with whatever follows the command. Optional frontmatter for description, argument hints, tool allowlist.

**Use this when** —
- The thing is essentially a reusable prompt template — you want to type one shortcut and inject a longer instruction.
- You (or your users) know exactly when to invoke it. It is not auto-triggered.
- It does not need its own context window or tool isolation.

**Not this when** — You want Claude to decide when to apply it (→ skill), or it should run as a sub-task with its own scratch space (→ subagent).

---

## Skill

**What it is** — A directory with a `SKILL.md` whose YAML frontmatter describes when to use it. Claude reads the frontmatter of all available skills and auto-invokes the matching one when the current task fits. Skills support progressive disclosure — the main `SKILL.md` is always loaded, but it can reference additional files the model reads only when needed.

**Invocation** — Auto-triggered by Claude when the task matches the `description` field. Can also be invoked explicitly via the `Skill` tool or (when bundled in a plugin) as `/namespace:skill-name`.

**Install scope** —
- User: `~/.claude/skills/<name>/SKILL.md`
- Plugin: `skills/<name>/SKILL.md` in a plugin repo

**File shape** — Frontmatter requires `name` and `description`. The description is the matching signal — write it so Claude recognizes relevant situations. Body contains instructions and may reference other files in the skill directory.

**Use this when** —
- Claude should recognize the situation and apply the workflow without being told — "whenever the user asks to do X, do Y".
- The workflow is long enough or branching enough that inlining it as a command prompt would be unwieldy.
- You want progressive disclosure — several files, loaded only when needed.

**Not this when** — The user will always type a shortcut to invoke it (→ slash command). Or it should run in a fresh context (→ subagent).

---

## Subagent

**What it is** — A specialized agent definition with its own system prompt, tool allowlist, and isolated context window. Delegated work runs as a sub-session; only the final result returns to the parent.

**Invocation** — The parent Claude invokes it via the `Agent` tool, either because the user asked explicitly or because the subagent's description matches the task.

**Install scope** —
- User: `~/.claude/agents/<name>.md`
- Project: `.claude/agents/<name>.md`
- Plugin: `agents/` in a plugin repo

**File shape** — Frontmatter with `name`, `description`, optional `tools` allowlist and `model`. Body is the subagent's system prompt.

**Use this when** —
- You need a fresh context window — long research, a parallel probe, or work that would blow up the main conversation.
- The task should run with a restricted tool set or a specialized persona.
- You want several parallel independent sub-tasks.

**Not this when** — The work is short and contextual; stay inline. Or the user will always type a shortcut (→ slash command). Or Claude should auto-apply a workflow without the overhead of a separate session (→ skill).

---

## Plugin

**What it is** — A packaged bundle of slash commands, skills, subagents, hooks, and/or MCP servers, distributed as a single installable unit. Listed in a marketplace and installed via `/plugin install`.

**Invocation** — Not invoked directly. A plugin ships primitives; those primitives are invoked individually. Commands and skills from a plugin are namespaced: `/<plugin-name>:<command>`.

**Install scope** — User-scope on install. Lives under `~/.claude/plugins/cache/…`.

**File shape** — Repo with `.claude-plugin/plugin.json` declaring name, version, and which primitives it ships.

**Use this when** —
- You have two or more related primitives that should travel together.
- You want to distribute something to other people (public or internal marketplace).
- You want version-controlled, updatable releases rather than hand-edited files in `~/.claude/`.

**Not this when** — A single slash command or skill does the job; no need for the packaging overhead.

---

## MCP server

**What it is** — An external process (local binary, Docker container, remote HTTP service) that speaks the Model Context Protocol. Exposes tools, resources, and prompts that Claude can call during a session.

**Invocation** — Claude calls the server's tools mid-session, same as it calls built-in tools.

**Install scope** —
- User: registered via `claude mcp add` in user settings
- Project: `.mcp.json` in the repo
- Plugin: declared in the plugin's manifest

**File shape** — The server itself is a program you run. Registration is a small JSON/config entry pointing at a command, URL, or container.

**Use this when** —
- You need to reach an external system — an API, database, SaaS product, hardware device, or your own service.
- You want to expose capabilities that can't be expressed as a prompt (real auth, stateful sessions, streaming, binary data).
- Multiple clients (Claude Code, Claude.ai, Cursor, etc.) should share the same integration.

**Not this when** — A slash command with `curl` in it would be enough. Or the user already has a CLI and you can just run it with `Bash`. MCP servers are process-weight; don't reach for one casually.

---

## Hook

**What it is** — A shell command the harness fires on a specific event. Not a primitive Claude invokes — the harness invokes it, and Claude sees the output (or the block, if the hook exits non-zero).

**Events** — `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `Stop`, `SubagentStop`, `Notification`, plus others as they ship.

**Invocation** — Automatic, on the configured event. Not user-triggered, not Claude-triggered.

**Install scope** — Configured in `settings.json` (user, project, or local).

**Use this when** —
- You want deterministic behavior on a trigger — always run a linter after file edits, always log every prompt, always block a dangerous command.
- The behavior must not depend on Claude deciding to do it.
- "From now on when X, do Y" — memory and skills cannot fulfill automatic behavior; only hooks can.

**Not this when** — The behavior is discretionary, not mandatory. Skills and commands are for discretion; hooks are for enforcement.

---

## Output style

**What it is** — Alternative instructions that replace or modify the default Claude Code system prompt for a session. Changes persona, defaults, and behavior wholesale.

**Invocation** — Selected via `/output-style` or config for the session.

**Install scope** — User (`~/.claude/output-styles/`) or project.

**Use this when** —
- You want a fundamentally different mode of operation for a whole session — e.g. a "pair programming" style that narrates more, or a "terse ops" style.
- The change is session-wide, not task-specific.

**Not this when** — You want task-specific behavior. That's a skill or command.

---

## Status line

**What it is** — A shell command whose stdout is rendered in the Claude Code status bar.

**Invocation** — Re-run by the harness on a cadence.

**Install scope** — User config.

**Use this when** — You want persistent at-a-glance information (git branch, API costs, model, custom state) visible during every session.

---

## Settings / permissions / env vars

Not a primitive in the "extension" sense, but worth naming: `settings.json` configures permissions (which tools Claude can use without asking), hooks, MCP servers, environment variables, and a lot more. Many "how do I make Claude stop asking me to approve X?" questions are actually settings questions, not primitive questions.
