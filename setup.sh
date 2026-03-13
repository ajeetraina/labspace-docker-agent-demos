#!/bin/bash
# =============================================================================
# Docker Agent Demos — Labspace Setup Script
# Fixes "legacy layout" error by creating the required .labspace structure
#
# Usage (from repo root):
#   chmod +x setup-labspace.sh && ./setup-labspace.sh
#
# Then start in dev mode:
#   CONTENT_PATH=$PWD docker compose \
#     -f oci://dockersamples/labspace-content-dev \
#     -f .labspace/compose.override.yaml up
# =============================================================================

set -e
REPO_ROOT="$(pwd)"

echo ""
echo "🐳 Docker Agent Demos — Labspace Setup"
echo "======================================="

# ── 1. .labspace/ ─────────────────────────────────────────────────────────────
mkdir -p "$REPO_ROOT/.labspace"

cat > "$REPO_ROOT/.labspace/compose.override.yaml" << 'EOF'
services:
  workspace:
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY:-}
EOF
echo "✅ .labspace/compose.override.yaml"

# ── 2. labspace.yaml ──────────────────────────────────────────────────────────
cat > "$REPO_ROOT/labspace.yaml" << 'EOF'
title: "Docker Agent — Build & Deploy Apps with AI Agents"
description: |
  Learn to use Docker Agent to build and deploy real applications using
  AI agents defined in a single YAML file. Go from a 1-agent quickstart
  to a full 5-agent SDLC pipeline — spec, code, test, review, deploy.
  No code required. Just YAML and a prompt.
difficulty: intermediate
tags:
  - docker-agent
  - ai-agents
  - multi-agent
  - yaml
  - deployment
EOF
echo "✅ labspace.yaml"

# ── 3. Directory tree ─────────────────────────────────────────────────────────
mkdir -p "$REPO_ROOT/labspace/lab01-weather-dashboard"
mkdir -p "$REPO_ROOT/labspace/lab02-swag-store-single-agent"
mkdir -p "$REPO_ROOT/labspace/lab03-swag-store-multi-agent"
echo "✅ labspace/ directories"

# ── 4. labspace/README.md ─────────────────────────────────────────────────────
cat > "$REPO_ROOT/labspace/README.md" << 'EOF'
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
EOF
echo "✅ labspace/README.md"

# ── 5. Lab 01 ─────────────────────────────────────────────────────────────────
cat > "$REPO_ROOT/labspace/lab01-weather-dashboard/README.md" << 'EOF'
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
EOF

cat > "$REPO_ROOT/labspace/lab01-weather-dashboard/docker-agent.yaml" << 'EOF'
version: "2"

models:
  smart:
    provider: openai
    model: gpt-4o
    max_tokens: 16000

agents:
  root:
    model: smart
    description: "Orchestrates 5 agents to build and deploy a weather dashboard for Bengaluru"
    instruction: |
      You are the root orchestrator. Delegate to 5 sub-agents IN ORDER.
      Wait for each to complete before calling the next.
      1. spec_agent   — write the technical specification
      2. code_agent   — build the complete HTML application
      3. test_agent   — validate the HTML output
      4. review_agent — review code quality
      5. deploy_agent — build Docker image and run on port 8080
      After all complete print:
      "✅ Weather Dashboard is LIVE at http://localhost:8080
       Built by 5 AI agents — one YAML, one prompt."
    sub_agents: [spec_agent, code_agent, test_agent, review_agent, deploy_agent]
    toolsets:
      - type: todo
      - type: think

  spec_agent:
    model: smart
    description: "Writes the technical specification"
    instruction: |
      You are a product manager. Use todo to track steps.
      STEP 1 — Create directory ./weather-dashboard/
      STEP 2 — Write ./weather-dashboard/spec.md:
        - Live data: Open-Meteo API (free, no key):
          https://api.open-meteo.com/v1/forecast?latitude=12.9716&longitude=77.5946&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,wind_direction_10m,precipitation,visibility,surface_pressure&hourly=temperature_2m,weather_code,precipitation_probability&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,sunrise,sunset&timezone=Asia%2FKolkata&forecast_days=7
        - Sections: Hero, Hourly 12h, 7-day, Stats grid 6 cards
        - Dark navy #070f1e, glassmorphism, responsive, animated bg
        - Deploy: nginx:alpine port 8080
      STEP 3 — Confirm written
    toolsets:
      - type: filesystem
      - type: todo

  code_agent:
    model: smart
    description: "Builds the complete weather dashboard HTML"
    instruction: |
      You are a senior frontend engineer. Use todo to track steps.
      STEP 1 — Read ./weather-dashboard/spec.md
      STEP 2 — Write COMPLETE HTML to ./weather-dashboard/index.html
        A) Fetch from Open-Meteo:
           https://api.open-meteo.com/v1/forecast?latitude=12.9716&longitude=77.5946&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,wind_direction_10m,precipitation,visibility,surface_pressure&hourly=temperature_2m,weather_code,precipitation_probability&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,sunrise,sunset&timezone=Asia%2FKolkata&forecast_days=7
        B) HERO — big temp, emoji icon, condition, feels-like, "Bengaluru, Karnataka", updated time
        C) STATS — 6 cards: Humidity, Wind, Precipitation, Visibility, Pressure, UV(=6)
        D) HOURLY — 12h horizontal scroll, time + icon + temp
        E) 7-DAY — day, icon, high/low, rain%, sunrise/sunset
        F) ANIMATED BG — CSS keyframes: sunny=warm orange, rainy=blue/grey, cloudy=muted
        G) DESIGN — #070f1e bg, glassmorphism cards, fade-in, responsive,
           loading spinner, error state,
           footer: "Powered by Open-Meteo • Built with Docker Agent"
        H) WMO CODES — 0=☀️ Clear, 1-2=🌤️ Partly Cloudy, 3=☁️ Overcast,
           45-48=🌫️ Foggy, 51-55=🌦️ Drizzle, 61-65=🌧️ Rain,
           80-82=🌧️ Showers, 95=⛈️ Thunderstorm
        Write COMPLETE file. Do not truncate.
      STEP 3 — Confirm written
    toolsets:
      - type: filesystem
      - type: todo
      - type: shell

  test_agent:
    model: smart
    description: "Validates the weather dashboard HTML"
    instruction: |
      You are a QA engineer. Use todo to track steps.
      STEP 1 — Read ./weather-dashboard/index.html
      STEP 2 — Check each (PASS/FAIL):
        [ ] DOCTYPE html present
        [ ] "Bengaluru" in title or body
        [ ] Open-Meteo API URL in JS
        [ ] Hero, Hourly, 7-day, Stats sections present
        [ ] fetch() call present
        [ ] CSS animations present
        [ ] Media queries present
      STEP 3 — Write ./weather-dashboard/test-report.md
      STEP 4 — Print summary
    toolsets:
      - type: filesystem
      - type: todo

  review_agent:
    model: smart
    description: "Reviews code quality"
    instruction: |
      You are a senior engineer. Use todo to track steps.
      STEP 1 — Read ./weather-dashboard/index.html
      STEP 2 — Read ./weather-dashboard/test-report.md
      STEP 3 — Review: quality, a11y, performance, security, responsiveness
      STEP 4 — Write ./weather-dashboard/review-report.md with score /10
      STEP 5 — Summarize
    toolsets:
      - type: filesystem
      - type: todo
      - type: think

  deploy_agent:
    model: smart
    description: "Dockerizes and deploys the weather dashboard"
    instruction: |
      You are a DevOps engineer. Use todo to track steps.
      STEP 1 — Confirm ./weather-dashboard/index.html exists
      STEP 2 — Write ./weather-dashboard/Dockerfile:
               FROM nginx:alpine
               COPY index.html /usr/share/nginx/html/index.html
               EXPOSE 80
      STEP 3 — docker build -t weather-dashboard:demo ./weather-dashboard/
      STEP 4 — docker rm -f weather-dashboard 2>/dev/null || true
      STEP 5 — docker run -d --name weather-dashboard -p 8080:80 weather-dashboard:demo
               DO NOT stop this container.
      STEP 6 — sleep 3 && curl -s http://localhost:8080 | grep -c "Bengaluru"
      STEP 7 — docker images weather-dashboard:demo --format "Size: {{.Size}}"
      STEP 8 — Print: "✅ Weather Dashboard LIVE at http://localhost:8080"
    toolsets:
      - type: filesystem
      - type: shell
      - type: todo
EOF
echo "✅ Lab 01 files"

# ── 6. Lab 02 ─────────────────────────────────────────────────────────────────
cat > "$REPO_ROOT/labspace/lab02-swag-store-single-agent/README.md" << 'EOF'
# Lab 2 — Docker Swag Store (Single Agent) 🛍️

Build a complete Docker-branded e-commerce store with **one agent**.

## Architecture

```
root (single agent)
 ├── 1. Create ./swag-store/
 ├── 2. Write index.html
 │       ├── Header (Docker logo + cart badge)
 │       ├── Hero ("Wear the Whale 🐳")
 │       ├── Filter bar (All/Apparel/Accessories/Stickers)
 │       ├── 8 product cards with add-to-cart
 │       ├── Cart sidebar (qty, subtotal, checkout)
 │       ├── Toast notifications
 │       └── Footer
 ├── 3. Write Dockerfile
 ├── 4. docker build
 └── 5. docker run -p 8080:80  ✅ stays running
```

## Run

```bash
export OPENAI_API_KEY=your_key_here
docker agent run single-agent.yaml \
  "Build and deploy the Docker Swag Store"
```

Open **http://localhost:8080**
EOF

cat > "$REPO_ROOT/labspace/lab02-swag-store-single-agent/single-agent.yaml" << 'EOF'
version: "2"

models:
  smart:
    provider: openai
    model: gpt-4o
    max_tokens: 16000

agents:
  root:
    model: smart
    description: "Builds and deploys a Docker Swag Store in one shot"
    instruction: |
      You are a senior full-stack engineer. Use todo to track every step.

      STEP 1 — Create ./swag-store/

      STEP 2 — Write COMPLETE HTML to ./swag-store/index.html:
        A) HEADER — Docker whale SVG, "Docker Swag Store", cart badge, #1D63ED nav
        B) HERO — "Wear the Whale 🐳", CTA "Shop Now" scrolls to products, animated whale
        C) FILTER BAR — All/Apparel/Accessories/Stickers, active=#1D63ED, JS filter
        D) PRODUCTS (8 cards: emoji image, name, category, price, Add to Cart, hover lift):
           1. Docker Captain T-Shirt  $29.99  Apparel     👕  bg:#1D63ED
           2. Docker Hoodie           $59.99  Apparel     🧥  bg:#2d3748
           3. Docker Whale Mug        $14.99  Accessories ☕  bg:#e2e8f0
           4. Docker Sticker Pack     $9.99   Stickers    🎨  bg:#fef3c7
           5. Docker Cap              $24.99  Apparel     🧢  bg:#1D63ED
           6. Docker Tote Bag         $19.99  Accessories 👜  bg:#d4edda
           7. Docker Socks 3-pack     $12.99  Apparel     🧦  bg:#f8d7da
           8. Docker Laptop Sleeve    $34.99  Accessories 💻  bg:#030F1C
        E) CART SIDEBAR — slide-in right, items+qty+price, remove btn, subtotal,
           checkout alert "Thanks for supporting Docker! 🐳", backdrop close
        F) TOAST — bottom-right, "✅ {name} added to cart!", auto-dismiss 3s
        G) FOOTER — "© 2025 Docker, Inc. — Made with ❤️ and containers"
        H) DESIGN — Docker colors (#1D63ED, #030F1C), responsive 1-4 col grid,
           DM Sans via Google Fonts, smooth transitions, vanilla JS, zero deps
        Write COMPLETE file. Do not truncate.

      STEP 3 — Write ./swag-store/Dockerfile:
               FROM nginx:alpine
               COPY index.html /usr/share/nginx/html/index.html
               EXPOSE 80
      STEP 4 — docker build -t docker-swag-store:demo ./swag-store/
      STEP 5 — docker rm -f swag-store 2>/dev/null || true
      STEP 6 — docker run -d --name swag-store -p 8080:80 docker-swag-store:demo
               DO NOT stop this container.
      STEP 7 — sleep 2 && curl -s http://localhost:8080 | grep -c "Docker Swag Store"
      STEP 8 — Print: "✅ Docker Swag Store LIVE at http://localhost:8080"
    toolsets:
      - type: filesystem
      - type: shell
      - type: todo
EOF
echo "✅ Lab 02 files"

# ── 7. Lab 03 ─────────────────────────────────────────────────────────────────
cat > "$REPO_ROOT/labspace/lab03-swag-store-multi-agent/README.md" << 'EOF'
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
EOF

cat > "$REPO_ROOT/labspace/lab03-swag-store-multi-agent/multi-agent.yaml" << 'EOF'
version: "2"

models:
  smart:
    provider: openai
    model: gpt-4o
    max_tokens: 16000

agents:
  root:
    model: smart
    description: "Orchestrates 5 agents to build and deploy the Docker Swag Store"
    instruction: |
      You are the root orchestrator. Delegate IN ORDER, wait for each.
      1. spec_agent   — product + UI specification
      2. code_agent   — complete HTML application
      3. test_agent   — validate all features
      4. review_agent — code quality + brand review
      5. deploy_agent — Dockerize + deploy port 8080
      After all complete print:
      "✅ Docker Swag Store LIVE at http://localhost:8080
       Built by 5 AI agents — one YAML, one prompt."
    sub_agents: [spec_agent, code_agent, test_agent, review_agent, deploy_agent]
    toolsets:
      - type: todo
      - type: think

  spec_agent:
    model: smart
    description: "Writes product and UI specification"
    instruction: |
      Use todo to track steps.
      STEP 1 — Create ./swag-store/
      STEP 2 — Write ./swag-store/spec.md:
        - Brand: #1D63ED, #030F1C, #FFFFFF
        - 8 products: T-Shirt $29.99, Hoodie $59.99, Mug $14.99,
          Stickers $9.99, Cap $24.99, Tote $19.99, Socks $12.99, Sleeve $34.99
        - Sections: Header, Hero, Filters, Grid, Cart, Toasts, Footer
        - Tech: vanilla JS, DM Sans, zero deps, nginx:alpine port 8080
      STEP 3 — Confirm
    toolsets:
      - type: filesystem
      - type: todo

  code_agent:
    model: smart
    description: "Builds the complete Docker Swag Store HTML"
    instruction: |
      Use todo to track steps.
      STEP 1 — Read ./swag-store/spec.md
      STEP 2 — Write COMPLETE HTML to ./swag-store/index.html:
        A) HEADER — Docker whale SVG, store name, cart badge, #1D63ED nav
        B) HERO — "Wear the Whale 🐳", CTA, animated whale
        C) FILTERS — All/Apparel/Accessories/Stickers, active=#1D63ED
        D) PRODUCTS:
           1. T-Shirt $29.99 👕  2. Hoodie $59.99 🧥   3. Mug $14.99 ☕
           4. Stickers $9.99 🎨  5. Cap $24.99 🧢      6. Tote $19.99 👜
           7. Socks $12.99 🧦   8. Sleeve $34.99 💻
        E) CART — slide-in, items, subtotal, checkout alert, backdrop
        F) TOAST — bottom-right, auto-dismiss 3s
        G) FOOTER — "© 2025 Docker, Inc. — Made with ❤️ and containers"
        H) DESIGN — Docker colors, responsive, DM Sans, smooth CSS
        Write COMPLETE file. Do not truncate.
      STEP 3 — Confirm
    toolsets:
      - type: filesystem
      - type: todo
      - type: shell

  test_agent:
    model: smart
    description: "Validates all Docker Swag Store features"
    instruction: |
      Use todo to track steps.
      STEP 1 — Read ./swag-store/index.html
      STEP 2 — Check each (PASS/FAIL):
        [ ] DOCTYPE html
        [ ] "Docker Swag Store" in title
        [ ] All 8 product names present
        [ ] 8 "Add to Cart" buttons
        [ ] Cart sidebar present
        [ ] 4 filter buttons present
        [ ] Cart JS (add/remove/subtotal)
        [ ] Filter JS
        [ ] Toast HTML/JS
        [ ] Media queries
        [ ] #1D63ED color used
        [ ] Self-contained (no broken CDN)
      STEP 3 — Write ./swag-store/test-report.md
      STEP 4 — Print summary
    toolsets:
      - type: filesystem
      - type: todo

  review_agent:
    model: smart
    description: "Reviews code quality, accessibility, brand consistency"
    instruction: |
      Use todo to track steps.
      STEP 1 — Read ./swag-store/index.html
      STEP 2 — Read ./swag-store/test-report.md
      STEP 3 — Review: quality, a11y, perf, security, brand, mobile
      STEP 4 — Write ./swag-store/review-report.md with score /10
      STEP 5 — Summarize
    toolsets:
      - type: filesystem
      - type: todo
      - type: think

  deploy_agent:
    model: smart
    description: "Dockerizes and deploys the Docker Swag Store"
    instruction: |
      Use todo to track steps.
      STEP 1 — Confirm ./swag-store/index.html exists
      STEP 2 — Write ./swag-store/Dockerfile:
               FROM nginx:alpine
               COPY index.html /usr/share/nginx/html/index.html
               EXPOSE 80
      STEP 3 — docker build -t docker-swag-store:demo ./swag-store/
      STEP 4 — docker rm -f swag-store 2>/dev/null || true
      STEP 5 — docker run -d --name swag-store -p 8080:80 docker-swag-store:demo
               DO NOT stop this container.
      STEP 6 — sleep 3 && curl -s http://localhost:8080 | grep -c "Docker Swag Store"
      STEP 7 — docker images docker-swag-store:demo --format "Size: {{.Size}}"
      STEP 8 — Print: "✅ Docker Swag Store LIVE at http://localhost:8080"
    toolsets:
      - type: filesystem
      - type: shell
      - type: todo
EOF
echo "✅ Lab 03 files"

# ── 8. Summary ────────────────────────────────────────────────────────────────
echo ""
echo "================================================"
echo "🎉 Setup complete! Files created:"
echo "================================================"
find "$REPO_ROOT/.labspace" "$REPO_ROOT/labspace" \
     "$REPO_ROOT/labspace.yaml" -type f 2>/dev/null | \
     sort | sed "s|$REPO_ROOT/||"
echo ""
echo "Start labspace in dev mode:"
echo ""
echo "  CONTENT_PATH=\$PWD docker compose \\"
echo "    -f oci://dockersamples/labspace-content-dev \\"
echo "    -f .labspace/compose.override.yaml up"
echo ""
echo "Then open http://localhost:3030 🐳"
echo ""
