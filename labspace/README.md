# Docker Agent Labs 🐳

> **One YAML file. One prompt. A fully deployed application.**

## How Docker Agent Works

```
 $ docker agent run agent.yaml "Build a weather dashboard"
                          │
                          ▼
 ┌────────────────────────────────────────────────────┐
 │              Docker Agent Runtime                  │
 │  ┌─────────────┐  ┌──────────────┐  ┌──────────┐  │
 │  │ AI Provider │  │    Agents    │  │ Toolsets │  │
 │  │  OpenAI     │  │  root agent  │  │filesystem│  │
 │  │  Anthropic  │  │  sub-agents  │  │shell     │  │
 │  │  Gemini     │  │  (YAML def)  │  │todo ←KEY │  │
 │  │  Local DMR  │  └──────────────┘  │think     │  │
 │  └─────────────┘                   │MCP servers│  │
 │                                    └──────────┘  │
 └────────────────────────────────────────────────────┘
                          │
                          ▼
          ✅  http://localhost:8080  (live app!)
```

## Labs

| Lab | What You Build | Agents | Time |
|-----|---------------|--------|------|
| [Lab 1](./lab01-weather-dashboard/) | AccuWeather-style dashboard for Bengaluru | 5 | ~3 min |
| [Lab 2](./lab02-swag-store-single-agent/) | Docker Swag Store | 1 | ~2 min |
| [Lab 3](./lab03-swag-store-multi-agent/) | Docker Swag Store with full SDLC | 5 | ~5 min |

## Prerequisites

```bash
docker agent --version          # Docker Desktop 4.40+
export OPENAI_API_KEY=sk-...    # Your OpenAI key
```

## The Key Insight

Always add `- type: todo` to every agent's toolsets.
Without it, agents *describe* what they'd do. With it, they *actually do it*.
