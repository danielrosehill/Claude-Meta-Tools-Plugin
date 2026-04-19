# Decision rules

This is the logic `/what-thing:pick` applies after the diagnostic interview. Rules are ordered — apply the first one that fires.

---

## Rule 1 — Event-triggered and mandatory → Hook

If the user said the behavior must happen automatically when a specific event occurs (before a tool call, after Claude stops, on every prompt submit, when a file is edited) and the behavior is not discretionary — it must run every time — the answer is a **hook** in `settings.json`.

Skills, commands, and memory cannot enforce automatic behavior. Only hooks can.

---

## Rule 2 — External system → MCP server

If the workflow needs to reach an external system — an API, database, SaaS product, hardware device, or stateful service — and the interaction is non-trivial (auth, streaming, binary data, persistent connections, many endpoints), the answer is an **MCP server**.

Exceptions where MCP is overkill even with an external system:

- A single `curl` call fits in a slash command prompt. → Slash command.
- The user already has a CLI installed. → Slash command that invokes the CLI via `Bash`.
- The user has explicitly said they prefer to avoid MCP (check stored context). → Prefer a slash command wrapping a CLI if feasible, and say so.

---

## Rule 3 — Sub-task needing isolation → Subagent

If the workflow needs its own fresh context window, its own system prompt, a restricted tool set, or will run in parallel with other work, the answer is a **subagent**.

Typical signals: long research, code review as a second opinion, parallel probes, specialized persona, work that would otherwise blow up the main context.

---

## Rule 4 — Auto-triggered workflow → Skill

If the user wants Claude to recognize the situation and apply the workflow without being told ("whenever I ask to do X, do Y"), and the workflow is multi-step or branching enough that a slash command prompt would be unwieldy, the answer is a **skill**.

Signals for skill over slash command:

- "Claude should just know to do this" → skill
- Progressive disclosure (several reference files, loaded only when needed) → skill
- The workflow has steps, conditions, or multiple files → skill

---

## Rule 5 — Shortcut for a known action → Slash command

If the user will type a shortcut to invoke a reusable prompt or workflow, and it is essentially a prompt template with arguments, the answer is a **slash command**.

This is the default for "I want a quick way to do X that I'll type". Don't over-engineer — a 20-line command beats a skill for simple cases.

---

## Rule 6 — Session-wide behavior change → Output style

If the user wants a fundamentally different mode of operation for a whole session (different persona, different defaults, different narration style), the answer is an **output style**.

Rare — most people don't need this. Only fire this rule if the user explicitly describes session-wide behavior.

---

## Rule 7 — Persistent at-a-glance info → Status line

If the user wants something visible in the status bar at all times, the answer is a **status line** command.

---

## After the primitive — pick the scope

Once the primitive is chosen, pick the scope. Check stored user context first; if it answers the question, use it.

- **Just for me, available everywhere** → user scope (`~/.claude/...`)
- **Shared with a team via a specific repo** → project scope (`.claude/...` in the repo)
- **Distributed publicly or to multiple people** → plugin
- **Two or more related primitives that ship together** → plugin, regardless of audience

If the user has no stored preference and the choice could go either way, ask one question — "just for you, or for a team?" — and apply.

---

## The plugin rule

A **plugin** is not an alternative to the other primitives — it is a packaging layer. The real question is "what primitives do I need?" first; "should I bundle them as a plugin?" second.

Bundle as a plugin when:
- Two or more primitives travel together
- You want a versioned, installable unit
- You want to distribute

Do not bundle as a plugin when:
- It's a single slash command or skill for your own use — just put it in `~/.claude/`

---

## Common confusions — named tiebreakers

### Skill vs slash command

Both can encode a workflow. The deciding question: *do you want to type a trigger, or should Claude notice the situation?*

- Type a trigger → command
- Claude notices → skill

Secondary: skills support progressive disclosure (multiple files, loaded on demand); commands are a single prompt file. If you have reference material to load only sometimes, that pushes toward a skill.

### Skill vs subagent

Both can be auto-invoked. The deciding question: *does it need its own context window?*

- Same context, applied inline → skill
- Fresh context, isolated tools, returns a summary → subagent

### Slash command vs MCP server

Both can reach external systems. The deciding question: *is it more than a `curl` / CLI call?*

- Single API call, no state → slash command with `Bash`
- Auth, multiple endpoints, streaming, state → MCP server

### Hook vs skill

Both can react to events. The deciding question: *must this always run?*

- Must always run → hook
- Runs when appropriate, judged by Claude → skill

### User scope vs project scope vs plugin

- Just me, everywhere → user
- This repo, shared with collaborators via git → project
- Distributed as a unit → plugin

---

## When two primitives genuinely tie

Say so. Do not pick arbitrarily. Give the user the tradeoff in one sentence per option and let them choose. Typical tie: "a short slash command" vs "a skill that auto-triggers" — both work; the real question is whether the user wants to type it or wants Claude to notice.
