ARG TARGET="my-app"

FROM arhatdev/builder-go:debian as builder
FROM arhatdev/go:scratch
ENTRYPOINT [ "/my-app" ]
