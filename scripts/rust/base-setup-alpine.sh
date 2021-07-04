#!/bin/sh

set -ex

apk update
apk add --no-cache \
    ca-certificates wget build-base curl git make bash
