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
