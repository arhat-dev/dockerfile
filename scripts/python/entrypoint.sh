#!/bin/sh

set -e

# shellcheck disable=SC1091
. /app/.venv/bin/activate

# shellcheck disable=SC2068
exec $@
