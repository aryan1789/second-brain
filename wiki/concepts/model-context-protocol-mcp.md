---
title: Model Context Protocol (MCP)
type: entity
sources: [raw/articles/kaggle-google-5day-agents-day2-podcast-transcript.md]
related: [Multi-Agent AI Systems Architecture, Agent-to-Agent Protocol (A2A), Agentic Engineering]
created: 17-06-2026
last-updated: 17-06-2026
---

# Model Context Protocol (MCP)

## Core Idea

MCP is an open standard that lets any AI agent connect to any external tool or data source through a single, consistent interface — described as the "USB-C port for your agent's harness." Without it, connecting N models to M tools requires N×M bespoke integrations (O(N×M) complexity). With MCP, each model and each tool only needs to implement the protocol once, reducing complexity to O(N+M).

## Intuition

Think of POSIX: every Unix-like OS and every application that wants to talk to a filesystem or pipe just implements the POSIX interface. No one writes custom glue between each OS and each app. MCP is the POSIX of agent-tool integration. The agent asks the tool for its own instruction manual (schema + capabilities), rather than the developer hand-writing parsers for every tool's response format.

## How it works

### Transports

MCP separates the *protocol* from the *transport* layer. Two standard transports:

- **stdio** — standard input/output; direct process-to-process on the local machine, zero network overhead. Best for local development and rapid prototyping.
- **SSE (Server-Sent Events over HTTP)** — keeps a persistent open stream to a remote MCP endpoint. Used when the tool is hosted elsewhere.

### Vibe Coder workflow: discovery → configuration → connection

1. **Discovery** — find a pre-built MCP server:
   - Public registries: fast, but completely unvetted — treat as untrusted
   - Managed endpoints: officially maintained (e.g. Google's published MCP servers)
   - Internal registries: hosted on your own company's API gateway
2. **Configuration** — set scope and authenticate. *Never hardcode API keys in the agent prompt.* Use environment variables so the LLM never sees raw credentials.
3. **Connection** — the handshake where the agent queries the server for available tools, their schemas, and their input/output types. From here the agent can call tools without any custom parsing code.

## In Practice

```python
# Example: using a pre-built MCP server with stdio transport
# (pseudocode — actual SDK syntax varies by framework)

from mcp import MCPClient

client = MCPClient(transport="stdio", server_command=["python", "bigquery_mcp_server.py"])
tools = client.list_tools()          # agent fetches tool schemas at connection time
result = client.call_tool("query_table", {"dataset": "sales", "limit": 100})
```

**RAG-based tool loading** — don't load all 50 tool schemas at startup (attention dilution + context exhaustion). Instead, retrieve tool schemas dynamically: when the user asks about a calendar, retrieve the calendar MCP tool; drop it when the task is done.

```python
def load_tool_for_query(query: str, tool_registry: list[dict]) -> dict:
    # embed query, find closest matching tool schema, load it into context
    ...
```

## Common Pitfalls

- **Public registries are unvetted** — an untrusted MCP server can attempt to exfiltrate data. Use a service like **Model Armor** to inspect data flowing through the transport and block malicious payloads.
- **Prompt-patching for tool errors** — when an agent calls a tool with the wrong argument type, the reflex is to patch the system prompt ("stop passing strings"). This makes the system brittle. Instead: use the **MCP Inspector** tool (or Chrome DevTools on SSE) to examine the raw JSON-RPC packets. Fix the pipeline; don't yell at the model.
- **Weekend-project trap** — a custom REST wrapper saves 30 minutes today but makes you the permanent maintainer of that bridge. MCP makes you an orchestrator; custom wrappers make you a low-leverage conductor.

## Common Pitfalls

| Mistake | Effect | Fix |
|---------|--------|-----|
| Hardcoded API keys in prompt | LLM sees credentials; leaked in logs/traces | Use env vars, secrets managers |
| All 50 tools loaded at startup | Attention dilution, context overflow | RAG-based dynamic tool loading |
| Prompt-patching for tool errors | Brittle system, masks root cause | Inspect JSON-RPC packets, fix pipeline |
| Using unvetted public registry | Malicious data exfiltration | Gate with Model Armor |

## Related Concepts

- [[Agent-to-Agent Protocol (A2A)]] — companion protocol for agent-to-agent communication (agents are not tools — they operate in unbounded domains)
- [[Multi-Agent AI Systems Architecture]] — broader patterns for orchestrating multiple agents
