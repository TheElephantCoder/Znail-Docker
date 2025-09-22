# Dockerfile – builds a complete Znail image without needing znail/ in this repo
FROM python:3.11-slim

# OS deps (netem tools included; harmless in CI/Codespaces)
RUN apt-get update && apt-get install -y --no-install-recommends \
      git iproute2 iptables ethtool bridge-utils dnsmasq procps curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ----- Python deps from this repo (pinned) -----
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Map legacy flask_restplus -> flask-restx and add gunicorn (if not already)
RUN pip install --no-cache-dir flask-restx gunicorn
RUN printf "from flask_restx import *\n" > /app/flask_restplus.py

# ----- Fetch Znail source from upstream (no local znail/ needed) -----
ARG ZNAIL_REPO=https://github.com/znailnetem/znail.git
ARG ZNAIL_REF=main
RUN git clone --depth 1 --branch "${ZNAIL_REF}" "${ZNAIL_REPO}" /app/src

# WSGI wrapper to expose the Flask app + /healthz
COPY wsgi.py /app/src/wsgi.py

ENV PYTHONUNBUFFERED=1
WORKDIR /app/src
EXPOSE 5000

# Serve the app directly (no nginx/auth)
CMD ["gunicorn", "-b", "0.0.0.0:5000", "wsgi:app", "--workers", "2", "--timeout", "60"]

# Liveness probe
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD curl -fsS http://127.0.0.1:5000/healthz || exit 1
