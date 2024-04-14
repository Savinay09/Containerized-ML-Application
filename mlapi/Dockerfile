FROM python:3.11-slim AS build-env


WORKDIR /app


RUN apt-get update \
    && apt-get install -y curl build-essential libffi-dev \
    && rm -rf /var/lib/apt/lists/*


ENV POETRY_VERSION=1.7.1

RUN curl -sSL https://install.python-poetry.org | python3 -


ENV PATH="/root/.local/bin:$PATH"


COPY pyproject.toml poetry.lock ./


RUN python -m venv /venv \
    && . /venv/bin/activate \
    && poetry install --no-dev


FROM python:3.11-slim

WORKDIR /app

COPY --from=build-env /venv /venv


ENV PATH="/venv/bin:$PATH"


COPY ./src /app/src


COPY ./distilbert-base-uncased-finetuned-sst2 /app/distilbert-base-uncased-finetuned-sst2


HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl --fail http://localhost:8000/health || exit 1


CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]