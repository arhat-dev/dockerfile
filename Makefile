MAKECMDGOALS ?= base-go

# arch name mapping
arm64 := arm64v8
armv7 := arm32v7
amd64 := amd64

include scripts/base.mk

include scripts/go.mk
include scripts/python.mk

.PHONY: images-base
images-base:
	./scripts/build-targets.sh base

.PHONY: images-builder
images-builder:
	./scripts/build-targets.sh builder

.PHONY: images-container
images-container:
	./scripts/build-targets.sh container

.PHONY: images-push
images-push:
	./scripts/build-targets.sh push
