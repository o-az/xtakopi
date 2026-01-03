# syntax=docker/dockerfile:1
FROM python:3.14-slim-trixie AS python

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV PATH="/root/.local/bin:$PATH"

RUN uv tool install takopi

FROM python:3.14-slim-trixie AS runtime

ENV PATH="/root/.bun/bin:/root/.local/bin:$PATH"
ENV NODE_ENV="production"

RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
  curl \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY --from=oven/bun /usr/local/bin/bun /root/.bun/bin/bun

RUN bun add --global opencode-ai@latest
RUN curl --silent --fail --show-error --location --get \
    --url https://github.com/openai/codex/releases/download/rust-v0.78.0-alpha.10/codex-x86_64-unknown-linux-musl.tar.gz \
    > codex.tar.gz \
    && tar -xzf codex.tar.gz -C /usr/local/bin \
    && mv /usr/local/bin/codex-x86_64-unknown-linux-musl /usr/local/bin/codex \
    && chmod +x /usr/local/bin/codex

COPY --from=python /root/.local/bin/takopi /root/.local/bin/takopi
COPY --from=python /root/.local/share/uv/tools/takopi /root/.local/share/uv/tools/takopi

WORKDIR /usr/src/app

COPY . .

RUN mkdir -p ~/.codex ~/.takopi \
  && cp codex.toml ~/.codex/config.toml \
  && cp takopi.toml ~/.takopi/takopi.toml \
  && mkdir -p ~/.config/opencode \
  && cp opencode.json ~/.config/opencode/opencode.json \
  && cp bunfig.toml ~/.bunfig.toml \
  && chmod +x entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
CMD ["takopi", "--debug"]
