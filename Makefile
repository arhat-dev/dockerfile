DOCKERBUILD := docker build
DOCKERPUSH := docker push

DOCKER_REPO := arhatdev

MAKECMDGOALS ?= base-go

# arch name mapping
arm64 := arm64v8
armv7 := arm32v7
amd64 := amd64

#
# Base Images
#
.build-base-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := base/$(MAKECMDGOALS:base-%=%).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

base-go: .build-base-image
base-python3.6-alpine-armv7: .build-base-image
base-python3.6-alpine-arm64: .build-base-image
base-python3.6-alpine-amd64: .build-base-image
base-python3.7-alpine-armv7: .build-base-image
base-python3.7-alpine-arm64: .build-base-image
base-python3.7-alpine-amd64: .build-base-image

#
# Builder Images
#
.build-builder-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := builder/$(MAKECMDGOALS:builder-%=%).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

builder-go: .build-builder-image

#
# Multi-arch builder
#
.build-multi-arch-builder-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:builder-%=%))
	$(eval DOCKERFILE := builder/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

builder-python3.6-alpine-armv7: .build-multi-arch-builder-image
builder-python3.6-alpine-arm64: .build-multi-arch-builder-image
builder-python3.6-alpine-amd64: .build-multi-arch-builder-image
builder-python3.7-alpine-armv7: .build-multi-arch-builder-image
builder-python3.7-alpine-arm64: .build-multi-arch-builder-image
builder-python3.7-alpine-amd64: .build-multi-arch-builder-image

#
# Container Images
#
.build-container-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := container/$(firstword $(subst -, ,$(MAKECMDGOALS)))/$(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

go-scratch: .build-container-image
go-alpine: .build-container-image
go-ci: .build-container-image

#
# Multi-arch container
#
.build-multi-arch-container-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := container/$(firstword $(subst -, ,$(MAKECMDGOALS)))/$(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := $(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg DOCKER_ARCH=$($(ARCH)) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

python3.6-alpine-armv7: .build-multi-arch-container-image
python3.6-alpine-arm64: .build-multi-arch-container-image
python3.6-alpine-amd64: .build-multi-arch-container-image
python3.7-alpine-armv7: .build-multi-arch-container-image
python3.7-alpine-arm64: .build-multi-arch-container-image
python3.7-alpine-amd64: .build-multi-arch-container-image

#
# Push images
#
.push-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS:push-%=%))
	$(DOCKERPUSH) $(IMAGE_NAME):latest
	$(DOCKERPUSH) $(IMAGE_NAME):onbuild

push-base-go: .push-image
push-base-python3.6-alpine-armv7: .push-image
push-base-python3.6-alpine-arm64: .push-image
push-base-python3.6-alpine-amd64: .push-image
push-base-python3.7-alpine-armv7: .push-image
push-base-python3.7-alpine-arm64: .push-image
push-base-python3.7-alpine-amd64: .push-image

push-builder-go: .push-image
push-builder-python3.6-alpine-armv7: .push-image
push-builder-python3.6-alpine-arm64: .push-image
push-builder-python3.6-alpine-amd64: .push-image
push-builder-python3.7-alpine-armv7: .push-image
push-builder-python3.7-alpine-arm64: .push-image
push-builder-python3.7-alpine-amd64: .push-image

push-go-alpine: .push-image
push-go-ci: .push-image
push-go-scratch: .push-image

push-python3.6-alpine-armv7: .push-image
push-python3.6-alpine-arm64: .push-image
push-python3.6-alpine-amd64: .push-image
push-python3.7-alpine-armv7: .push-image
push-python3.7-alpine-arm64: .push-image
push-python3.7-alpine-amd64: .push-image
