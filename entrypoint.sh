#!/usr/bin/env bash

set -eou pipefail

bun /usr/src/app/setup.ts

if [ -n "${OPENAI_API_KEY:-}" ]; then
  printenv OPENAI_API_KEY | codex login --with-api-key
fi

exec "$@"
