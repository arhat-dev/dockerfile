# TARGET for python is only used to triger `pipenv install` (non-empty)
ARG TARGET="foo"

FROM arhatdev/builder-python-alpine-armv7:onbuild as builder
FROM arhatdev/python-alpine-armv7:onbuild
