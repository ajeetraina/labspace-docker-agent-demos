# Lab 3 — Docker Swag Store (Multi-Agent) 🛍️🤖

Same store as Lab 2, built by a **5-agent SDLC pipeline**.

## Pipeline

```
root
 ├─▶ spec_agent    → spec.md        (products, brand, layout)
 ├─▶ code_agent    → index.html     (full store app)
 ├─▶ test_agent    → test-report.md (12 checks PASS/FAIL)
 ├─▶ review_agent  → review-report.md (score /10)
 └─▶ deploy_agent  → docker run -p 8080:80  ✅ stays running
```

## Run

```bash
export OPENAI_API_KEY=your_key_here
docker agent run multi-agent.yaml \
  "Build and deploy the Docker Swag Store"
```

Open **http://localhost:8080**

## Lab 2 vs Lab 3

| | Lab 2 (1 agent) | Lab 3 (5 agents) |
|--|-----------------|-----------------|
| Speed | ~2 min | ~5 min |
| Output files | 2 | 5 |
| Best for | Demo | Workshop |
