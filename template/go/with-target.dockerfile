ARG TARGET="my-app"

FROM arhatdev/builder-go:stretch as builder
FROM arhatdev/go:scratch
