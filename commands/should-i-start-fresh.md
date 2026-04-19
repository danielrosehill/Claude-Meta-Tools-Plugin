---
description: Evaluate whether the current conversation should continue or whether starting a new session would produce better results
argument-hint: "[optional: describe what you're about to ask next]"
allowed-tools: []
---

Evaluate whether the user should continue this conversation or start a fresh one.

## What to evaluate

Review the conversation history so far and consider:

1. **Topic drift** — Has the conversation covered multiple unrelated topics? Is the original task complete?
2. **Context relevance** — How much of the accumulated context (prior messages, tool calls, outputs) is actually relevant to what the user needs next?
3. **Context bloat** — Is the conversation long enough that irrelevant history is likely to degrade response quality?
4. **Unresolved errors** — Are there failed attempts, dead ends, or conflicting instructions piling up in the context?
5. **Natural break point** — Did the last task reach a clean conclusion?

If the user has described their next intended action (passed as an argument), factor that in: would the existing conversation history help or hinder that next task?

## How to respond

Give a clear recommendation in one of two forms:

**Continue this conversation** — if prior context is still relevant and helpful. Briefly explain what context is valuable.

**Start a new conversation** — if prior context is mostly irrelevant bloat, if topics have shifted substantially, or if accumulated errors could confuse future responses. Briefly explain why a clean slate helps.

Keep the recommendation concise: one verdict, two to four sentences of reasoning. Do not pad. Do not hedge excessively — commit to a recommendation.

If you recommend starting fresh, optionally suggest a crisp opening prompt the user could paste into the new session to get started immediately.
