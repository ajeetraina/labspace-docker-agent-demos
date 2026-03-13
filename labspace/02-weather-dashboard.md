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
cat weather.yaml
```

The YAML defines one `root` agent with a GPT-4o model and step-by-step instructions. The `filesystem` and `shell` toolsets give it the ability to write files and run Docker commands.

---

## Run the weather agent

1. Change into the weather-dashboard directory:

    ```bash
    cd weather-dashboard
    ```

2. Launch the agent:

    ```bash
    docker agent run weather.yaml "Build and deploy a production AccuWeather-style weather dashboard for Bengaluru, India. Write index.html as a complete single-file HTML app that fetches live weather from Open-Meteo API, shows current temperature, hourly forecast, 7-day forecast, and weather stats. Build a Docker image using nginx:alpine, run it on port 8080, and confirm it is live at http://localhost:8080"
    ```

    > [!NOTE]
    > The agent will stream its progress to the terminal — you'll see it creating files, building images, and verifying the deployment in real time.

3. When the agent prints `✅ Weather Dashboard is LIVE at http://localhost:8080`, open the app:

    ::tabLink[Open Weather Dashboard]{href="http://localhost:8080" title="App" id="app"}

---

## What did the agent do?

Run these commands to inspect the outputs:

```bash
ls
```

You should see `index.html` and `Dockerfile` in the current directory.

```bash
docker images weather-dashboard:demo
```

```bash
docker ps --filter name=weather-dashboard
```

---

> [!TIP]
> Go back to the parent directory before moving on:
> ```bash
> cd ..
> ```
