# TARGET for python is only used to triger `pipenv install` (non-empty)
ARG TARGET="foo"

FROM arhatdev/builder-python3.7-alpine-armv7:onbuild as builder
FROM arhatdev/python3.7-alpine-armv7:onbuild
