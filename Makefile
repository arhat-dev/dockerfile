MAKECMDGOALS ?= base-go

# arch name mapping for DOCKER_ARCH
arm64 := arm64v8
armv7 := arm32v7
armv6 := arm32v6
amd64 := amd64
ppc64le := ppc64le
s390x := s390x
x86 := i386
mips64le := mips64le

include scripts/base.mk

include scripts/app/app.mk
include scripts/go/go.mk
include scripts/python/python.mk
include scripts/rust/rust.mk

images-base: images-base-go images-base-rust images-base-python
images-builder: images-builder-go images-builder-rust images-builder-python
images-container: images-container-go images-container-rust images-container-python

images-app:
	./scripts/build-targets.sh app
