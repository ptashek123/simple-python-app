FROM python:3.11-slim AS builder

WORKDIR /app

COPY pyproject.toml ./
RUN pip install --upgrade pip && pip install "psycopg[binary]" .[test]

COPY . .

FROM builder AS test

CMD ["pytest", "tests"]

FROM python:3.11-slim

RUN useradd -m appuser

WORKDIR /app

COPY --from=builder /app /app

RUN pip install --no-cache-dir "psycopg[binary]" .

USER appuser

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8089"]
