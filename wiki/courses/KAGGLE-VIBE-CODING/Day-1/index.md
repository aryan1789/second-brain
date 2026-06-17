---
title: Day 1 - The New SDLC With Vibe Coding
type: source-summary
sources: [raw/lecture-notes/KAGGLE-VIBE-CODING/Day-1/podcast-transcript.md, raw/lecture-notes/KAGGLE-VIBE-CODING/Day-1/whitepaper-the-new-sdlc-with-vibe-coding.pdf]
related: []
created: 16-06-2026
last-updated: 16-06-2026
---

# Day 1 - The New SDLC With Vibe Coding

Source: companion podcast + whitepaper "The New SDLC With Vibe Coding" (Addy Osmani, Shubham Saboo, Sokratis Kartakis, May 2026), Day 1 of the Kaggle x Google 5-Day AI Agents Intensive course.

## Core thesis

Software engineering's biggest shift since high-level languages: the developer's interface moves from **syntax to intent**. As of early 2026, 85% of developers use AI coding agents (51% daily), and ~41% of new code is AI-generated.

## Vibe coding vs. agentic engineering

- **Vibe coding** (Karpathy, Feb 2025): describe what you want in natural language, accept the output, paste errors back to get fixes. Fast, trial-and-error, "does it seem to work?"
- **Agentic engineering** (Karpathy/Osmani, early 2026): same AI, but wrapped in formal specs, automated test suites, evals, and CI/CD gates.
- The real differentiator isn't *whether* AI is used — it's **how outputs are verified**: tests check deterministic code, evals check non-deterministic agent reasoning/trajectories. Without both, it's vibe coding no matter how polished the prompt.

## Context engineering (replaces prompt engineering)

Six types of context every agent needs:
1. **Instructions** — agent's role, goals, boundaries
2. **Knowledge** — architecture docs, API specs, style guides
3. **Memory** — short-term session logs + long-term project state
4. **Examples** — reference patterns from the codebase
5. **Tools** — APIs/CLIs/filesystems the agent can use
6. **Guardrails** — hard constraints that block bad actions before execution

Split into **static context** (always loaded — AGENTS.md/CLAUDE.md, persona, rules) vs **dynamic context** (loaded on demand — Agent Skills, RAG results, tool outputs). Dumping everything into static context causes **context rot** — too much noise dilutes the model's attention and degrades output, even with huge context windows.

## The new SDLC

- **Requirements**: shifts from static docs to a live conversation + rapid prototyping
- **Architecture**: still the most human-centric phase (trade-offs AI can't fully grasp)
- **Implementation**: drops from weeks to hours, but METR found experienced devs were actually ~19% *slower* on some tasks due to verification/debugging overhead
- **Testing**: adds **trajectory evaluation** — grading *how* the agent got the answer (right tools, permission checks), not just the final output. A clean result that skipped a security check is a worse failure than a visible syntax error
- **Maintenance**: legacy "spaghetti" codebases become tractable for AI-driven refactoring

## The factory model & the harness

- **Factory model**: the developer's output is no longer code — it's the *system that produces code* (specs, agents, tests, feedback loops, guardrails).
- **Agent = Model + Harness**, and the model is only ~10% of capability. The harness (instructions/rule files, tools, sandboxes, orchestration, hooks/guardrails, observability) drives ~90%.
- On Terminal-Bench 2.0, one team went from outside the top 30 to top 5 by changing *only* the harness, no model change. Most agent failures are **configuration failures**, not model failures.

## Conductor vs. orchestrator, and the 80% problem

- **Conductor mode**: real-time, keystroke-level pairing (Cursor, Copilot) — for debugging and unfamiliar code.
- **Orchestrator mode**: async, high-level delegation to background agents (Google Jules, Copilot agent mode) — assign a goal, review the PR later.
- **The 80% problem**: AI nails ~80% of boilerplate/standard implementation; the remaining 20% (edge cases, business logic, integration nuance) needs human judgment. Productivity comes from focusing expertise on that 20%, not from blindly accepting everything.

## The token economy

- **Vibe coding** = low CapEx, high OpEx — cheap to start, but trial-and-error burns tokens and creates a "maintenance tax" (like a high-interest credit card).
- **Agentic engineering** = high CapEx, low OpEx — heavy upfront investment in specs/sandboxes/evals, much lower marginal cost per feature (a fixed-rate mortgage).
- **Intelligent model routing**: send complex reasoning to frontier models, simple/deterministic tasks (formatting, basic tests) to small cheap models — can cut costs by orders of magnitude.

## Whitepaper extras (beyond the podcast)

- **Building agents themselves** (not just code): Google's **Agents CLI** (built on ADK) bundles skills for the full build → evaluate → deploy → observe loop from any coding agent's terminal. Coordination across multi-agent systems uses **MCP** (tool access) and **A2A protocol** (cross-agent delegation). Anthropic's team reportedly built a working C compiler in Rust over two weeks using agent teams, with humans only setting direction and reviewing.
- **Concrete checklists** for individuals (start with a 10-line AGENTS.md, write tests/evals before code, review everything that ships), engineering leaders (treat AGENTS.md/evals as versioned code, "set the bar at the eval not the demo"), and organizations (build the eval/observability substrate before scaling, adopt MCP/A2A, hire for judgment over typing speed).

## Closing line

> "Generation is solved. Verification, judgment, and direction are the new craft."
