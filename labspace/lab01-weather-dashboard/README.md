# Lab 1 — Weather Dashboard 🌤️

Build a live AccuWeather-style weather dashboard for Bengaluru
using a 5-agent SDLC pipeline. Uses Open-Meteo (free, no API key).

## Pipeline

```
root
 ├─▶ spec_agent    → spec.md
 ├─▶ code_agent    → index.html  (hero, hourly, 7-day, stats, animation)
 ├─▶ test_agent    → test-report.md
 ├─▶ review_agent  → review-report.md  (score /10)
 └─▶ deploy_agent  → docker run -p 8080:80  ✅ stays running
```

## Run

```bash
export OPENAI_API_KEY=your_key_here
docker agent run docker-agent.yaml \
  "Build and deploy the Bengaluru weather dashboard"
```

Open **http://localhost:8080**
