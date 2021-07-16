#!/bin/sh

set -ex

# Ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitaly/scripts/process-wrapper

GITALY_CONFIG_FILE="${GITALY_CONFIG_FILE:-$CONFIG_TEMPLATE_DIRECTORY/config.toml}"

echo "Starting Gitaly"
/usr/local/bin/gitaly "$GITALY_CONFIG_FILE" >> /var/log/gitaly/gitaly.log 2>&1 &

if command -v xtail >/dev/null; then
    xtail /var/log/gitaly
else
    tail -f /var/log/gitaly/*
fi

wait
