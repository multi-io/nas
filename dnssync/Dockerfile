FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

WORKDIR /app

COPY pyproject.toml uv.lock .python-version README.md ./
COPY src ./src

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-editable --no-group dev

FROM python:3.13-slim AS runner

RUN useradd --user-group --home-dir=/app --create-home app

# Copy the environment
WORKDIR /app
COPY --from=builder --chown=app:app /app/.venv /app/.venv

# Run the application
ENV PYTHONPATH=/app/.venv/lib/python3.13/site-packages
CMD ["/app/.venv/bin/dnssync"]
