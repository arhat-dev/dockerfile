ARG TARGET="my-app"

FROM ghcr.io/arhat-dev/builder-go:debian as builder
FROM ghcr.io/arhat-dev/go:scratch
ENTRYPOINT [ "/my-app" ]
