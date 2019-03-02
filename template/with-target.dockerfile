ARG TARGET="my-app"

FROM arhatdev/go-builder:onbuild as builder
FROM arhatdev/go-scratch:onbuild
