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

## ✅ Set up your environment

### 1. Verify Docker is running

```bash
docker version
```

You should see both a Client and a Server version. If so, Docker is ready.

### 2. Install Docker Agent

Run the following commands to install Docker Agent as a CLI plugin:

```bash
curl -L -o /tmp/docker-agent https://github.com/docker/docker-agent/releases/latest/download/docker-agent-linux-amd64
```

```bash
mkdir -p ~/.docker/cli-plugins
mv /tmp/docker-agent ~/.docker/cli-plugins/docker-agent
chmod +x ~/.docker/cli-plugins/docker-agent
```

### 3. Verify the install

```bash
docker agent version
```

You should see output showing the Docker Agent version.

### 4. Confirm the demo files are in place

```bash
ls
```

You should see three directories: `weather-dashboard/`, `swag-store/single-agent/`, and `swag-store/multi-agent/`. Each contains a YAML agent definition and a README.

---

Ready? Move to the next section to deploy your first agent.
