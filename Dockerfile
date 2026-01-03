# syntax=docker/dockerfile:1
FROM python:3.14-slim-trixie AS python

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV PATH="/root/.local/bin:$PATH"

RUN uv tool install takopi

FROM oven/bun AS bun

RUN bun add --global @openai/codex@latest
RUN which codex

FROM python:3.14-slim-trixie AS runtime

ENV PATH="/root/.bun/bin:/root/.local/bin:$PATH"

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY --from=bun /usr/local/bin/codex /root/.bun/bin/codex
COPY --from=oven/bun /usr/local/bin/bun /root/.bun/bin/bun
COPY --from=python /root/.local/bin/takopi /root/.local/bin/takopi
COPY --from=python /root/.local/share/uv/tools/takopi /root/.local/share/uv/tools/takopi

ENV NODE_ENV="production"

ARG TELEGRAM_CHAT_ID
ARG TELEGRAM_BOT_TOKEN

ENV TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}
ENV TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}

WORKDIR /usr/src/app

COPY . .

RUN mkdir -p ~/.codex ~/.takopi \
  && cp codex.toml ~/.codex/config.toml \
  && cp takopi.toml ~/.takopi/takopi.toml

RUN bun setup.ts

EXPOSE 8080

CMD ["takopi", "--debug"]
