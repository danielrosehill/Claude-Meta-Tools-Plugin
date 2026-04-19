---
name: context-break-evaluator
description: Skill for evaluating whether a conversation has accumulated enough irrelevant context to warrant starting a new session. Applies structured criteria to distinguish valuable accumulated context from bloat that degrades response quality.
---

# Context Break Evaluator

## Purpose

This skill teaches you how to assess whether continuing a conversation will produce better or worse results than starting a new one. Context management is a critical but often overlooked factor in getting high-quality responses from AI agents.

## Core Concept

Every message added to a conversation increases context length. Longer context is not inherently better. Context becomes harmful when:

- Prior tasks are complete and their details are no longer relevant
- Failed attempts, corrections, and dead ends have accumulated
- The topic has shifted substantially from where the conversation began
- The model must sift through noise to find the signal

Starting a fresh conversation clears this noise. A well-timed context break often produces better results than continuing in a degraded session.

## Evaluation Framework

When asked to evaluate whether a user should start fresh, apply these criteria in order:

### 1. Task Completion Check
Has the primary task that opened this conversation been completed? If yes, and the user is moving to a new unrelated task, recommend a new conversation.

### 2. Relevance Audit
Estimate what percentage of the conversation history is directly relevant to the user's next request. If less than 30-40% is relevant, the irrelevant majority is likely to cause drift and degradation.

### 3. Error and Noise Accumulation
Count significant failed attempts, retried tool calls, conflicting instructions, or explicitly corrected misunderstandings. More than two or three of these in a single thread is a strong signal to start fresh.

### 4. Topic Coherence
If the conversation has touched more than two or three distinct, unrelated topics, the context is fragmented. Fragmented context confuses future responses.

### 5. Length Heuristic
Very long conversations (subjectively: many dozens of exchanges) accumulate compounding noise. Apply extra scrutiny before recommending continuation.

## Decision Rule

**Continue** if: the current task is ongoing, prior context is largely relevant, and there are few accumulated errors.

**Start fresh** if: the prior task is done, context relevance is low, significant errors have accumulated, or topics have diverged substantially.

**When in doubt**: recommend a fresh start. The cost of starting fresh is low (a brief re-orientation). The cost of degraded context is subtle but persistent.

## Handoff Summaries

When recommending a fresh start, always offer to generate a handoff summary — a compact paragraph the user can paste into the new session. A good handoff summary includes:

- The current state of whatever was being worked on
- Any decisions that were made
- The next action the user wants to take
- Any essential constraints or preferences to carry forward

Keep handoff summaries under 150 words.

## Tone

Be direct. Users asking this question want a verdict, not a hedge. Commit to a recommendation and explain it briefly. Avoid phrases like "it depends" without immediately resolving what it depends on.
