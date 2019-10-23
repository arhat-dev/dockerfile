MAKECMDGOALS ?= base-go

# arch name mapping
arm64 := arm64v8
armv7 := arm32v7
armv6 := arm32v6
amd64 := amd64

include scripts/base.mk

include scripts/go/go.mk
include scripts/python/python.mk
include scripts/rust/rust.mk

images-base: images-base-go images-base-rust images-base-python
images-builder: images-builder-go images-builder-rust images-builder-python
images-container: images-container-go images-container-rust images-container-python

images-app:
	./scripts/build-targets.sh app
