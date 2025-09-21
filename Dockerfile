# Znail container — multi-arch friendly, Raspberry Pi Compatible
FROM python:3.11-slim

# OS deps for tc/netem & basic networking tools
RUN apt-get update && apt-get install -y --no-install-recommends \
      iproute2 iptables ethtool bridge-utils dnsmasq procps curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first for layer caching
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# flask_restplus is abandoned; Znail imports it. Use flask-restx via shim.
RUN pip install --no-cache-dir flask-restx gunicorn
RUN printf "from flask_restx import *\n" > /app/flask_restplus.py

# Copy application source
COPY znail ./znail

# WSGI wrapper (imports app + adds /healthz)
COPY wsgi.py ./wsgi.py

ENV PYTHONUNBUFFERED=1
EXPOSE 5000

# Start with gunicorn (no proxy/auth here)
CMD ["gunicorn", "-b", "0.0.0.0:5000", "wsgi:app", "--workers", "2", "--timeout", "60"]

# Basic liveness check
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD curl -fsS http://127.0.0.1:5000/healthz || exit 1
