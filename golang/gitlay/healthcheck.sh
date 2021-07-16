#!/bin/sh

set -ex

# ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitaly/scripts/healthcheck

# Check that gitaly is running
netstat -tulnp | grep -w 8075 | grep "[0-9]\+/gitaly"
