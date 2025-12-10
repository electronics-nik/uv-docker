FROM python:3.12-slim

RUN apt-get update && apt-get install -y curl unzip \
    && curl -sSf https://install.astral.sh/uv.sh | bash \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.uv/bin:${PATH}"
