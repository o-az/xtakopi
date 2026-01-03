#!/usr/bin/env bash

set -eou pipefail

bun /usr/src/app/setup.ts

exec "$@"
