# TARGET for python is only used to triger `pipenv install` (non-empty)
ARG TARGET="foo"

FROM ghcr.io/arhat-dev/builder-python3.7:alpine-armv7 as builder
FROM ghcr.io/arhat-dev/python3.7:alpine-armv7
