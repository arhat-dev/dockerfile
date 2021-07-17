#!/bin/bash

set -ex

# ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitlab-shell/scripts/healthcheck

# Check that sshd is running
/bin/ps "$(cat /srv/sshd/sshd.pid)"
