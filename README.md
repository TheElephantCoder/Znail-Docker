# 🌐 Znail Network Emulator - Dockerized 🚀

Welcome to the **Dockerized Znail Network Emulator**! 🎉\
Znail lets you emulate real-world network conditions (latency, bandwidth
limits, packet loss, etc.) using Linux **tc/netem**.\
This Docker image makes it easy to run Znail on your favorite device,
including **Raspberry Pi** 🥧.

------------------------------------------------------------------------

## ✨ Features

-   🐳 Fully containerized Znail (no extra setup required)
-   ⚡ Runs on **amd64**, **arm64**, and **arm/v7** (works on Raspberry
    Pi)
-   🛠️ Traffic shaping using `tc/netem`
-   📊 Web UI served via Flask + Gunicorn
-   ❤️ Includes `/healthz` endpoint for monitoring

------------------------------------------------------------------------

## 📥 How to Run

### 🔹 Quick Start

``` bash
docker run -d --name znail   --net=host   --privileged   --restart unless-stopped   ghcr.io/<org-or-user>/znail:latest
```

👉 Open your browser: <http://localhost:5000>\
(or replace `localhost` with your Raspberry Pi's IP).

### 🔹 With Docker Compose

`docker-compose.yml`:

``` yaml
services:
  znail:
    image: ghcr.io/TheElephantCoder/znail-dockerized:latest
    container_name: znail
    network_mode: host
    privileged: true
    restart: unless-stopped
```

Run:

``` bash
docker compose up -d
```


## Try in GitHub Codespaces

You can open this project directly in a GitHub Codespace and test the Docker image:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=Znail-Dockerized&owner=TheElephantCoder)


> ⚠️ Note: In GitHub Codespaces the container runs without `--privileged` and `--net=host`, so you’ll only see the web UI (not real netem functionality). On a Pi or Linux host, run with:
> ```bash
> docker run -d --name znail \
>   --net=host \
>   --privileged \
>   --restart unless-stopped \
>   ghcr.io/TheElephantCoder/znail-dockerized:latest
> ```

------------------------------------------------------------------------

## 🛠️ Build Instructions

Build locally if you want to customize or develop Znail:

``` bash
git clone https://github.com/znailnetem/znail.git
cd znail

# Build the Docker image
docker build -t znail-local .

# Run it
docker run -d --name znail   --net=host   --privileged   znail-local
```

Multi-arch build (e.g., amd64, arm64, arm/v7):

``` bash
docker buildx create --use --name znailbuilder
docker run --privileged --rm tonistiigi/binfmt --install all

docker buildx build   --platform linux/amd64,linux/arm64,linux/arm/v7   -t ghcr.io/<org-or-user>/znail:latest   --push .
```

------------------------------------------------------------------------

## 🔍 Health Check

Check if Znail is alive:

``` bash
curl -sf http://localhost:5000/healthz
# -> ok
```

------------------------------------------------------------------------

## ⚠️ Notes

-   🖧 Znail is designed to be placed **in-line between two network
    interfaces** (for example, Ethernet + USB NIC) to actually intercept
    and shape traffic.
-   🛡️ Requires `--privileged` for `tc/netem` access.
-   🌍 No license file currently provided.

------------------------------------------------------------------------

## 🙏 Credits

Znail-Dockerized is **not a fork of Znail itself**, but a containerization project to make it easier to run Znail in Docker.

- **Znail Network Emulator**  
  Created and maintained by the [Znail team](https://github.com/znailnetem/znail).  
  This project would not exist without their excellent work on the emulator.

- **Dockerization & Multi-Arch Build**  
  Packaged and maintained by [TheElephantCoder](https://github.com/TheElephantCoder).

- **Libraries / Tools**  
  - [Flask](https://palletsprojects.com/p/flask/) – web framework  
  - [Flask-RESTX](https://github.com/python-restx/flask-restx) – API toolkit (used as replacement for flask-restplus)  
  - [Gunicorn](https://gunicorn.org/) – WSGI server for production  
  - [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/) – multi-arch image builds

If you use or build on this image, please consider ⭐ starring the [original Znail repository](https://github.com/znailnetem/znail) to support the upstream project.

------------------------------------------------------------------------

🎯 Now you're ready to emulate networks with **Znail in Docker**! 🎯
