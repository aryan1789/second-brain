---
title: Multi-Agent AI Systems Architecture
type: concept
sources: raw/claude-exports/Multi-agent-weather-and-time-system-on-Cloud-Run.md
related: [AI Agents, Agent SDK, Orchestration, LLMs, Cloud Deployment, Parallel Processing]
created: 14-05-2026
last-updated: 12-06-2026
---

## Overview

Multi-agent systems decompose complex tasks into smaller specialist agents that coordinate to produce a unified output. Each agent handles a specific domain or subtask and communicates via a shared execution context.

## Core Concepts

### Agent Types

#### Sequential Agent
- Executes agents one after another in a pipeline
- Each agent's output feeds into the next
- Used when tasks have dependencies

#### Parallel Agent
- Executes multiple agents simultaneously (fan-out)
- Combines results at convergence point
- Used for independent, concurrent tasks
- Reduces latency vs. sequential execution

#### Specialist Agent
- Focused on a single domain or API
- Clear instructions to prevent hallucination
- Examples: weather_agent, time_agent, merger_agent

### Session State & Communication

**Output Keys:** Each agent assigns its result to a state variable
```
weather_agent → output_key="weather_result"
time_agent    → output_key="time_result"
```

**Template Substitution:** Instructions can reference state variables
```
"Use the weather_result and time_result variables..."
```

## Practical Architecture Example

### Weather + Time Query System

```
SequentialAgent (root)
├── ParallelAgent (fan-out)
│   ├── weather_agent (queries Open-Meteo API)
│   └── time_agent (queries time service)
└── merger_agent (combines into coherent response)
```

**Benefits:**
- Weather and time queries run in parallel (faster)
- Merger agent reads both results and formats for user
- Clear separation of concerns
- Easy to test individual agents

## Implementation Patterns

### Custom Function Tools
- Agents equipped with tools performing specific tasks
- Example: `tools=[get_weather_function, get_time_function]`
- Error handling: Return standardized format `{"status": "error", ...}`

### Tight Instructions
- Be explicit about constraints
- Example: "do NOT mention X" prevents hallucination
- Specialist focus prevents scope creep

### Real API Integration
- Connect to external services (Open-Meteo, Google Time API)
- Handle rate limits and quota management
- Graceful error handling with fallbacks

## Deployment Considerations

### Local Development
- `adk web` — interactive dev UI with event trace debugging
- `adk run` — local execution
- Event trace shows agent execution flow and state transitions

### Cloud Deployment
- `adk deploy cloud_run` — deploy to Google Cloud Run
- API key management via environment variables (not hardcoded)
- `--with_ui` flag exposes dev UI (fine for demos, remove for production)

### Resource Constraints

**Free-Tier Gemini Quotas:**
- ~20 requests per day (RPD) per model
- Multi-agent systems burn 3+ requests per turn
- Different models have separate quota buckets
- Fallback to preview models when capped

**Environment Setup:**
- OneDrive + SQLite = silent "database full" errors; use `C:\dev\` instead
- Virtual environments hardcode paths; recreate after moving
- `.env` in `.gitignore` BEFORE first commit; rotate keys if leaked

## Common Agent Patterns

### Writer + Critic Loop
- Writer agent generates content
- Critic agent reviews and suggests improvements
- Iterate until quality criteria met

### Do-This-While-I-Sleep
- Background agent performs long-running task
- User notified when complete
- Useful for time-consuming operations

### Semantic Search
- Query parsing agent
- Vector search agent
- Result synthesis agent

### Meta-Agents (Hackathon Example)
- Devpost generator — structures submission format
- Demo script generator — creates talking points
- Rubric checker — evaluates against judging criteria
- Time budget agent — suggests what to cut under time pressure

## Advanced Topics

### LLM-Driven Delegation
- Root agent decides which sub-agents to use
- Dynamic agent selection based on input
- More flexible than static pipelines

### State Persistence
- Maintain context across agent calls
- Share variables between stages
- Enable complex workflows

### Monitoring and Debugging
- Dev UI event trace shows execution order
- Log agent decisions and state transitions
- Essential for troubleshooting complex orchestrations

## Gotchas and Lessons

1. **Pre-building project agents is risky** — theme unknown until event starts; fits often forced
2. **Meta-agents are safer** — solve logistics (Devpost, demos, scoring) independent of project
3. **Quota management is critical** — batch requests, use fallback models, monitor consumption
4. **Keep venvs in standard locations** — moving them breaks hardcoded paths
5. **Secure API keys early** — gitignore before first commit

## Related Concepts

(To be expanded as more pages are created)
