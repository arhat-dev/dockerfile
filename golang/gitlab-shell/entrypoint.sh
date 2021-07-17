#!/bin/bash

set -ex

# ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitlab-shell/scripts/process-wrapper

KEYS_DIRECTORY="${KEYS_DIRECTORY:-/etc/ssh}"

if ls "$KEYS_DIRECTORY/ssh_host_"* 1> /dev/null 2>&1; then
  echo "Using existing Host Keys"

  if [ "$KEYS_DIRECTORY" != "/etc/ssh" ]; then
    cp "$KEYS_DIRECTORY/ssh_host_"* "/etc/ssh/"
  fi
else
  echo "Generating Host Keys"

  ssh-keygen -A

  if [ "$KEYS_DIRECTORY" != "/etc/ssh" ]; then
    mkdir -p "$KEYS_DIRECTORY"
    cp /etc/ssh/ssh_host_* "$KEYS_DIRECTORY/"
  fi
fi

if [ "${USE_GITLAB_LOGGER-0}" -eq 1 ]; then
  /usr/local/bin/gitlab-logger /var/log/gitlab-shell &
else
  if command -v xtail >/dev/null; then
    xtail /var/log/gitlab-shell &
  else
    touch /var/log/gitlab-shell/ssh.log
    tail -f /var/log/gitlab-shell/* &
  fi
fi

/usr/sbin/sshd -D -E /var/log/gitlab-shell/ssh.log
