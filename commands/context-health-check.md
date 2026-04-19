---
description: Run a structured health check on the current conversation context and report its quality score with actionable recommendations
allowed-tools: []
---

Run a structured health check on the current conversation context.

Analyse the full conversation history and produce a brief report covering the following dimensions. Score each out of 5 and give one line of commentary.

## Dimensions

**Relevance** (5 = all context is still directly useful, 1 = most context is stale or off-topic)
How much of the accumulated context would genuinely help answer a new question in the current thread?

**Focus** (5 = single coherent topic/task, 1 = many unrelated topics mixed together)
Has the conversation stayed on one goal, or has it sprawled across multiple unrelated tasks?

**Error accumulation** (5 = no dead ends or failed attempts, 1 = significant noise from failures and retries)
Have failed tool calls, incorrect assumptions, or conflicting instructions built up in the history?

**Length efficiency** (5 = concise for the work done, 1 = very long relative to what was accomplished)
Is the conversation length proportionate to the value of work completed?

## Output format

Produce a short table:

| Dimension | Score | Note |
|---|---|---|
| Relevance | /5 | ... |
| Focus | /5 | ... |
| Error accumulation | /5 | ... |
| Length efficiency | /5 | ... |
| **Overall** | /20 | |

Then give an overall verdict:

- **18-20**: Healthy — continue the conversation.
- **12-17**: Moderate — consider summarising the key outcomes and starting fresh for the next distinct task.
- **Below 12**: Start fresh — too much accumulated noise; the user will get better results in a new session.

If the verdict is "start fresh" or "moderate," suggest a concise handoff summary the user could paste into a new session to carry forward the essential information without the bloat.
