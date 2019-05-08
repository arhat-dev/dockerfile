ARG TARGET="my-app"

FROM arhatdev/builder-go:onbuild as builder
FROM arhatdev/go-scratch:onbuild
