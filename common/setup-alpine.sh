#!/bin/sh

set -eux

apk update
apk add --no-cache \
  wget build-base curl git make bash ca-certificates
