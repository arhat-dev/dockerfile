ARG TARGET="my-app"

FROM arhatdev/builder-go-stretch:onbuild as builder
FROM arhatdev/go-scratch:onbuild
