#!/bin/sh

set -ex

apk --no-cache add ca-certificates wget build-base curl

pip3 install pipenv
