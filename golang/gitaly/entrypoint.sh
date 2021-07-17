#!/bin/sh

set -ex

# Ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitaly/scripts/process-wrapper

GITALY_CONFIG_FILE="${GITALY_CONFIG_FILE:-$CONFIG_TEMPLATE_DIRECTORY/config.toml}"

echo "Starting Gitaly"

cd /srv/gitaly-ruby

bundle exec sh -c \
  "/usr/local/bin/gitaly \"$GITALY_CONFIG_FILE\" | tee /var/log/gitaly/gitaly.log 2>&1"
