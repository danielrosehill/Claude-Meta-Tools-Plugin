---
description: Prune a bloated CLAUDE.md to its essentials and offload supplementary context into an agent-context/ directory.
---

Review the CLAUDE.md in this repository.

It is bloated. Work through these tasks:

## Prune

Reduce CLAUDE.md to the minimum length needed for an AI agent to gain the essential details of this project. "Essential details" means enough information to establish foundational context and understand the key purpose of the repository or codebase.

Remove anything that is supplementary, overly verbose, or not immediately necessary for an agent to begin working effectively.

## Nest

Take any extraneous-but-useful context that you removed and do the following:

- Create a folder called `agent-context/` at the root of the repository.
- Within that folder, create individual files for specific aspects of the context. Each file should have a descriptive filename that clearly identifies the topic it covers.

## Update CLAUDE.md

Add a brief reference to the `agent-context/` folder at the end of the pruned CLAUDE.md, for example:

> Additional context to assist with this project can be found in the `agent-context/` folder. Review the relevant files before asking the user questions.
