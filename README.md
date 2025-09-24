# 🌐 Znail Network Emulator - Dockerized 🚀

![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white) ![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![YAML](https://img.shields.io/badge/yaml-%23ffffff.svg?style=for-the-badge&logo=yaml&logoColor=151515) ![Raspberry Pi](https://img.shields.io/badge/-Raspberry_Pi-C51A4A?style=for-the-badge&logo=Raspberry-Pi) ![Gunicorn](https://img.shields.io/badge/gunicorn-%298729.svg?style=for-the-badge&logo=gunicorn&logoColor=white) ![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)





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
docker run -d --name znail   --net=host   --privileged   --restart unless-stopped   ghcr.io/TheElephantCoder/znail-docker:latest
```

👉 Open your browser: <http://localhost:5000>\
(or replace `localhost` with your Raspberry Pi's IP).

### 🔹 With Docker Compose

`docker-compose.yml`:

``` yaml
services:
  znail:
    image: ghcr.io/TheElephantCoder/znail-docker:latest
    container_name: znail-docker
    network_mode: host
    privileged: true
    restart: unless-stopped
```

Run:

``` bash
docker compose up -d
```

---------------------------------

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

docker buildx build   --platform linux/amd64,linux/arm64,linux/arm/v7   -t ghcr.io/znailnetem/znail:latest   --push .
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

Znail-Docker is **not a fork of Znail itself**, but a containerization project to make it easier to run Znail in Docker.

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

If you use or build on this image, please consider ⭐ starring the [original Znail repository](https://github.com/znailnetem/znail) to support the upstream project. All proceeds from Sponsorships for this repo will go to the original Znail Repository.

------------------------------------------------------------------------

🎯 Now you're ready to emulate networks with **Znail in Docker**! 🎯
