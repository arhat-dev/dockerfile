MAKECMDGOALS ?= base-go

# arch name mapping
arm64 := arm64v8
armv7 := arm32v7
armv6 := arm32v6
amd64 := amd64

include scripts/base.mk

include scripts/go/go.mk
include scripts/python/python.mk

.PHONY: images-base
images-base:
	./scripts/build-targets.sh base

.PHONY: images-builder
images-builder:
	./scripts/build-targets.sh builder

.PHONY: images-container
images-container:
	./scripts/build-targets.sh container

.PHONY: images-app
images-app:
	./scripts/build-targets.sh app
