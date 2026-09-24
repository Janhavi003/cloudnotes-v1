# syntax=docker/dockerfile:1

# -----------------------------
# Build stage
# -----------------------------
FROM python:3.11-slim AS build

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV=/opt/venv

WORKDIR /build

RUN python -m venv "$VIRTUAL_ENV" \
    && "$VIRTUAL_ENV/bin/pip" install --upgrade pip wheel

COPY requirements.txt .
RUN "$VIRTUAL_ENV/bin/pip" install --no-cache-dir --no-compile -r requirements.txt

# -----------------------------
# Runtime stage
# -----------------------------
FROM python:3.11-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH" \
    PORT=5000

WORKDIR /app

# Copy only the runtime virtualenv and application files.
COPY --from=build /opt/venv /opt/venv
COPY app.py requirements.txt ./
COPY api ./api
COPY utils ./utils
COPY templates ./templates
COPY static ./static
COPY database ./database
COPY uploads ./uploads

RUN useradd --create-home --uid 10001 cloudnotes \
    && chown -R cloudnotes:cloudnotes /app

USER cloudnotes

EXPOSE 5000

CMD ["python", "app.py"]
