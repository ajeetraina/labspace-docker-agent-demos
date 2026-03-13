#!/usr/bin/env bash
# Run this script from inside your cloned labspace-docker-agent-demos directory
# Usage: bash add-demo-files.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_REPO="https://github.com/ajeetraina/docker-agent-demo.git"
DEMO_DIR="/tmp/docker-agent-demo-$$"

echo "==> Cloning source demo repo..."
git clone "$DEMO_REPO" "$DEMO_DIR"

# ── project/ demo files ────────────────────────────────────────────────────────
echo "==> Copying demo files into project/..."

mkdir -p project/weather-dashboard
cp "$DEMO_DIR/weather-dashboard/weather.yaml" project/weather-dashboard/
cp "$DEMO_DIR/weather-dashboard/README.md"    project/weather-dashboard/

mkdir -p project/swag-store/single-agent
cp "$DEMO_DIR/swag-store/single-agent/cagent.yaml" project/swag-store/single-agent/
cp "$DEMO_DIR/swag-store/single-agent/README.md"   project/swag-store/single-agent/

mkdir -p project/swag-store/multi-agent
cp "$DEMO_DIR/swag-store/multi-agent/docker-agent.yaml" project/swag-store/multi-agent/
cp "$DEMO_DIR/swag-store/multi-agent/README.md"         project/swag-store/multi-agent/

# ── labspace/labspace.yaml ─────────────────────────────────────────────────────
echo "==> Writing labspace/labspace.yaml..."
cat > labspace/labspace.yaml << 'EOF'
metadata:
  id: ajeetraina/docker-agent-demos
  sourceRepo: github.com/ajeetraina/labspace-docker-agent-demos
  contentVersion: abcd123 # Will be filled in during CI

title: Docker Agent Demos
description: |
  Build and deploy real applications — a weather dashboard, a single-agent swag store, and
  a multi-agent swag store — using Docker Agent's YAML-driven AI agent framework.

sections:
  - title: Introduction
    contentPath: 01-introduction.md
  - title: Weather Dashboard
    contentPath: 02-weather-dashboard.md
  - title: Single-Agent Swag Store
    contentPath: 03-single-agent-swag-store.md
  - title: Multi-Agent Swag Store
    contentPath: 04-multi-agent-swag-store.md
  - title: Wrap-Up
    contentPath: 05-conclusion.md

services:
  - id: app
    url: http://localhost:8080
    title: App
    icon: web
EOF

# ── labspace/01-introduction.md ───────────────────────────────────────────────
echo "==> Writing labspace/01-introduction.md..."
cat > labspace/01-introduction.md << 'EOF'
# Introduction

👋 Welcome to the **Docker Agent Demos** lab!

By the end of this lab, you will:

- Understand what Docker Agent is and how YAML-driven agents work
- Run an AI agent that builds and deploys a live weather dashboard
- Deploy a Docker Swag Store using a single AI agent
- Orchestrate a full 5-agent pipeline where each agent handles a specialized role

---

## 🤖 What is Docker Agent?

Docker Agent is a framework for defining and running AI agents using a simple YAML file. Each agent:

- Has a **model** (e.g. GPT-4o)
- Has an **instruction** — a plain-language prompt describing what it should do
- Has access to **toolsets** like `filesystem`, `shell`, and `todo`
- Can optionally **delegate work to sub-agents**

You describe the goal in YAML. Docker Agent takes care of the rest — writing files, running commands, building images, and deploying containers.

---

## ✅ Verify your environment

Start by confirming Docker is available in the workspace:

```bash
docker version
```

You should see both a Client and a Server version printed. If so, you're ready to go.

Check that `docker agent` is available:

```bash
docker agent --version
```

> [!NOTE]
> If `docker agent` is not yet available as a CLI subcommand, the demos can also be run with the standalone `docker-agent` binary. The YAML files in this lab are compatible with both.

Next, confirm the demo files are in place:

```bash
ls
```

You should see three directories: `weather-dashboard/`, `swag-store/single-agent/`, and `swag-store/multi-agent/`. Each contains a YAML agent definition and a README.

---

Ready? Move to the next section to deploy your first agent.
EOF

# ── labspace/02-weather-dashboard.md ──────────────────────────────────────────
echo "==> Writing labspace/02-weather-dashboard.md..."
cat > labspace/02-weather-dashboard.md << 'EOF'
# Weather Dashboard

In this section, you'll use a single AI agent to build and deploy a **production-quality weather dashboard** for Bengaluru, India — styled after AccuWeather, served from an nginx container on port 8080.

The agent will:

1. Fetch live weather data from the Open-Meteo API (no API key needed)
2. Write a complete single-file HTML app with a hero, stats grid, hourly forecast, 7-day forecast, and animated background
3. Build a Docker image and run it on port 8080

---

## How it works

Open the agent definition to see how the whole thing is described:

```bash no-run-button
cat weather-dashboard/weather.yaml
```

The YAML defines one `root` agent with a GPT-4o model and step-by-step instructions. The `filesystem` and `shell` toolsets give it the ability to write files and run Docker commands.

---

## Run the weather agent

1. Change into the weather-dashboard directory:

    ```bash
    cd weather-dashboard
    ```

2. Launch the agent with the prompt below:

    ```bash
    docker agent run weather.yaml "Build and deploy a production AccuWeather-style weather dashboard for Bengaluru, India. Create ./weather-dashboard/index.html as a complete single-file HTML app that fetches live weather from Open-Meteo API, shows current temperature, hourly forecast, 7-day forecast, and weather stats. Build a Docker image using nginx:alpine, run it on port 8080, and confirm it is live at http://localhost:8080"
    ```

    > [!NOTE]
    > The agent will stream its progress to the terminal — you'll see it creating files, building images, and verifying the deployment in real time.

3. When the agent prints `✅ Weather Dashboard is LIVE at http://localhost:8080`, open the app:

    ::tabLink[Open Weather Dashboard]{href="http://localhost:8080" title="App" id="app"}

---

## What did the agent do?

Run these commands to inspect the outputs:

```bash
ls weather-dashboard/
```

```bash
docker images weather-dashboard:demo
```

```bash
docker ps --filter name=weather-dashboard
```

The agent built a real Docker image and started a container. The HTML file fetches live weather data from Open-Meteo every time the page loads.

---

> [!TIP]
> Go back to the parent directory before moving on:
> ```bash
> cd ..
> ```
EOF

# ── labspace/03-single-agent-swag-store.md ────────────────────────────────────
echo "==> Writing labspace/03-single-agent-swag-store.md..."
cat > labspace/03-single-agent-swag-store.md << 'EOF'
# Single-Agent Swag Store

In this section, a **single AI agent** will build and deploy the complete **Docker Swag Store** — a branded e-commerce frontend with 8 products, a shopping cart sidebar, category filters, and toast notifications.

---

## The agent definition

Take a look at the agent YAML:

```bash no-run-button
cat swag-store/single-agent/cagent.yaml
```

Notice:
- One `root` agent with GPT-4o
- Detailed step-by-step instructions (the agent follows them in order)
- `filesystem`, `shell`, and `todo` toolsets

---

## Run the single-agent store

> [!IMPORTANT]
> If the weather dashboard is still running on port 8080, stop it first:
> ```bash
> docker rm -f weather-dashboard
> ```

1. Change into the single-agent directory:

    ```bash
    cd swag-store/single-agent
    ```

2. Run the agent:

    ```bash
    docker agent run cagent.yaml "Build and deploy a Docker Swag Store. Single HTML file with 8 products (T-Shirt $29.99, Hoodie $59.99, Mug $14.99, Sticker Pack $9.99, Cap $24.99, Tote Bag $19.99, Socks $12.99, Laptop Sleeve $34.99), shopping cart sidebar, category filters, toast notifications, Docker brand colors #1D63ED and #030F1C. Package with nginx:alpine and keep it running on port 8080."
    ```

3. When you see `✅ Docker Swag Store is LIVE at http://localhost:8080`, open the store:

    ::tabLink[Open Swag Store]{href="http://localhost:8080" title="App" id="app"}

---

## Explore the outputs

```bash
docker images docker-swag-store:demo
```

```bash
docker ps --filter name=swag-store
```

Try the store — add items to the cart, use the category filters, and check the toast notifications.

---

## Key takeaway

One agent. One YAML. One prompt. Full deployment — no manual steps.

> [!TIP]
> Go back up before the next section:
> ```bash
> cd ../..
> ```
EOF

# ── labspace/04-multi-agent-swag-store.md ─────────────────────────────────────
echo "==> Writing labspace/04-multi-agent-swag-store.md..."
cat > labspace/04-multi-agent-swag-store.md << 'EOF'
# Multi-Agent Swag Store

Now you'll run the **multi-agent** version of the same Swag Store. Instead of one agent doing everything, a **root orchestrator** delegates to **5 specialized sub-agents** — each with a distinct role.

---

## The agent pipeline

```mermaid
graph TD
    Root["🧠 root (orchestrator)"] --> Spec["📋 spec_agent\nProduct & UI spec"]
    Root --> Code["💻 code_agent\nBuild the HTML app"]
    Root --> Test["🧪 test_agent\nValidate the output"]
    Root --> Review["🔍 review_agent\nCode quality review"]
    Root --> Deploy["🚀 deploy_agent\nDockerize & deploy"]
```

---

## What each agent does

| Agent | Role | Toolsets |
|---|---|---|
| `root` | Orchestrates and delegates | `todo`, `think` |
| `spec_agent` | Writes `spec.md` with brand, products, and UI spec | `filesystem`, `todo` |
| `code_agent` | Reads spec, writes the complete `index.html` | `filesystem`, `todo`, `shell` |
| `test_agent` | Validates HTML, writes `test-report.md` | `filesystem`, `todo` |
| `review_agent` | Reviews quality, writes `review-report.md` | `filesystem`, `todo`, `think` |
| `deploy_agent` | Writes Dockerfile, builds image, deploys | `filesystem`, `shell`, `todo` |

---

## Run the multi-agent store

> [!IMPORTANT]
> Stop any existing container on port 8080 first:
> ```bash
> docker rm -f swag-store weather-dashboard 2>/dev/null; true
> ```

1. Change into the multi-agent directory:

    ```bash
    cd swag-store/multi-agent
    ```

2. Launch the agent pipeline:

    ```bash
    docker agent run docker-agent.yaml "Build and deploy a Docker-branded Swag Store. Create a product spec, build a complete single HTML file with 8 products, shopping cart, category filters and toast notifications using Docker brand colors #1D63ED and #030F1C, validate all components, review code quality, then Dockerize with nginx:alpine and deploy to port 8080. Keep the container running after deployment."
    ```

3. When you see the final success message, open the store:

    ::tabLink[Open Swag Store (Multi-Agent)]{href="http://localhost:8080" title="App" id="app"}

---

## Inspect the agent artifacts

```bash
ls ../../swag-store/
```

You'll find `spec.md`, `index.html`, `test-report.md`, `review-report.md`, and `Dockerfile`.

```bash
cat ../../swag-store/test-report.md
```

```bash
cat ../../swag-store/review-report.md
```

---

## Single vs Multi: what's the difference?

| | Single-Agent | Multi-Agent |
|---|---|---|
| Agents | 1 | 5 |
| Specialization | Generalist | Each agent is an expert |
| Artifacts | `index.html`, `Dockerfile` | `spec.md`, `index.html`, `test-report.md`, `review-report.md`, `Dockerfile` |
| Use case | Simple tasks, fast execution | Complex tasks needing validation and review gates |

> [!TIP]
> Go back up before the final section:
> ```bash
> cd ../..
> ```
EOF

# ── labspace/05-conclusion.md ─────────────────────────────────────────────────
echo "==> Writing labspace/05-conclusion.md..."
cat > labspace/05-conclusion.md << 'EOF'
# Wrap-Up

You've completed the **Docker Agent Demos** lab! 🎉

---

## ✅ What you accomplished

- **Verified** the Docker Agent environment
- **Deployed a weather dashboard** using a single agent that fetched live data, generated HTML, and containerized it with nginx
- **Built a Swag Store** with a single generalist agent — one YAML, one prompt, full deployment
- **Orchestrated a 5-agent pipeline** where specialized agents wrote specs, built code, ran tests, reviewed quality, and deployed

---

## 🧠 Key concepts to take away

**Agents are the new microservices.** Just as microservices split a monolith into focused services, multi-agent systems split a complex task into focused agents — each doing one thing well.

**YAML is your orchestration layer.** You describe the goal, the tools, and the team. Docker Agent handles execution.

**Delegation > monoliths.** A root orchestrator that delegates to specialists produces better outputs — with built-in quality gates — than any single agent trying to do everything.

---

## 🚀 Next steps

- Explore the [Docker Agent documentation](https://docs.docker.com/agent/) to learn about all available toolsets
- Try customizing `weather.yaml` to target a different city
- Add a 6th agent to the multi-agent pipeline — a `notify_agent` that posts the deploy result to Slack
- Browse the [Collabnix community](https://collabnix.com) for more Docker and AI agent tutorials

---

🐳 Well done — you shipped three apps with AI agents today!
EOF

# ── compose.override.yaml ─────────────────────────────────────────────────────
echo "==> Writing compose.override.yaml..."
cat > compose.override.yaml << 'EOF'
services:
  configurator:
    environment:
      PROJECT_CLONE_URL: https://github.com/ajeetraina/labspace-docker-agent-demos

  workspace:
    image: dockersamples/labspace-workspace-base
EOF

# ── Remove old placeholder labspace files ─────────────────────────────────────
echo "==> Removing old placeholder labspace files..."
rm -f labspace/02-main-content.md labspace/03-conclusion.md

# ── Cleanup temp clone ────────────────────────────────────────────────────────
rm -rf "$DEMO_DIR"

echo ""
echo "==> All files written. Committing..."
git add .
git status

echo ""
echo "==> Ready to commit. Run:"
echo "    git commit -m 'Add docker-agent-demo examples: weather dashboard, single-agent and multi-agent swag store'"
echo "    git push"
