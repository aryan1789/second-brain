---
title: Agent-to-Agent Protocol (A2A)
type: entity
sources: [raw/articles/kaggle-google-5day-agents-day2-podcast-transcript.md]
related: [Model Context Protocol (MCP), Multi-Agent AI Systems Architecture, Agentic Engineering]
created: 17-06-2026
last-updated: 17-06-2026
---

# Agent-to-Agent Protocol (A2A)

## Core Idea

A2A is a communication protocol that lets AI agents delegate tasks to other specialist AI agents across different networks and programming languages. It is *not* the same as MCP: MCP connects agents to passive tools (bounded domain), while A2A connects agents to other agents (unbounded domain). The distinction matters because unbounded agents require ongoing negotiation, whereas tools just return a result.

## Intuition: Why Not Just Use MCP for Agents?

A standard tool operates in a **bounded domain** — it's a passive instrument. You call it, it returns something. Fire-and-forget. Like swinging a hammer.

An AI specialist operates in an **unbounded domain** — it's a collaborative partner. Like hiring a contractor to renovate your kitchen: you can't just hand them a blueprint and walk away. They'll find unexpected wiring behind the drywall, need to pause and negotiate trade-offs, ask for a bigger budget, and then resume.

Treating an agent like a tool triggers the **goto problem**: control flow leaves your structured, predictable environment and enters an unpredictable multi-turn state. The orchestrator may never receive the expected output — the sub-agent just gets lost in the weeds.

A2A isolates and manages that collaborative routing while keeping the orchestrator in control.

## Key Mechanisms

### Agent Cards

The standardized CV of a specialist agent. Published to an agent registry, an agent card specifies:
- What the agent can do (capabilities)
- How to interact with it (input/output schemas)
- Its security and data-handling policies

Orchestrators discover and evaluate specialists by reading their agent cards — the machines literally read each other's resumes.

### Agent Registries

Directories where agents publish their cards. Can be:
- Public marketplaces (e.g. Google Cloud Marketplace)
- Private internal registries

### Agent as a Service (AaaS)

Agent cards introduce a new monetization model: a developer builds a specialist agent (e.g. a real-time regulatory compliance agent), lists it on a marketplace, and enterprise orchestrators dynamically hire it. Pricing: typically a base fee + token usage.

### L402 — Permissionless Microtransactions

For sub-cent, high-frequency calls where corporate billing overhead is impractical. Mechanism:

1. Orchestrator calls specialist agent's endpoint
2. Server returns **HTTP 402 Payment Required** (historically unused status code) with a machine-readable Lightning Network invoice
3. Calling agent autonomously pays the invoice
4. Retries the request with a **macaroon** — a cryptographic proof-of-payment token
5. Transaction is stateless; no human involved

This enables autonomous agent-to-agent economies where agents hire, evaluate, and pay each other in milliseconds.

## In Practice

```
# Conceptual A2A flow (pseudocode)

# 1. Orchestrator discovers specialist
card = registry.lookup("regulatory-compliance-agent")
# card.capabilities → ["check_gdpr", "check_sox", "generate_audit_trail"]
# card.interaction_schema → {input: {regulation: str, document: str}, output: {compliant: bool, issues: list}}

# 2. Orchestrator sends task — not a tool call, but a delegation
task_id = a2a_client.delegate(
    agent=card.endpoint,
    task="Check GDPR compliance for this privacy policy",
    payload={"document": policy_text},
    budget={"max_tokens": 50000}
)

# 3. Agent works asynchronously, may call back with clarification requests
# 4. Orchestrator receives final result when agent finishes
result = a2a_client.poll(task_id)
```

## Bounded vs. Unbounded: The Decision Rule

| Signal | Use MCP (tool) | Use A2A (agent) |
|--------|---------------|-----------------|
| Single deterministic operation? | Yes | |
| Fire-and-forget, result immediate? | Yes | |
| Requires multi-turn conversation? | | Yes |
| May pause and request clarification? | | Yes |
| May itself call other tools/agents? | | Yes |
| Output depends on complex reasoning? | | Yes |

## Common Pitfalls

- **Treating agents as tools** — causes the goto problem; orchestrator loses control of the conversation state
- **No agent card / ad-hoc delegation** — breaks interoperability; other orchestrators can't discover or evaluate your agent
- **Skipping L402 for microtransactions** — corporate billing for sub-cent calls kills the economics; L402 is the right primitive

## Related Concepts

- [[Model Context Protocol (MCP)]] — for connecting agents to passive tools (bounded domain)
- [[Multi-Agent AI Systems Architecture]] — Sequential, Parallel, and Specialist agent patterns
