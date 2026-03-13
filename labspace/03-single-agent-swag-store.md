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
