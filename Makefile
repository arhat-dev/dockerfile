DOCKERBUILD := docker build
DOCKERPUSH := docker push

DEBIAN_HTTPS_MIRROR_SITE := mirrors.ocf.berkeley.edu
DOCKER_REPO := arhatdev

MAKECMDGOALS ?= base-go

#
# Base Images
#
.build-base-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := base/$(MAKECMDGOALS:base-%=%).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) \
		--build-arg MIRROR_SITE="$(DEBIAN_HTTPS_MIRROR_SITE)" \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

base-go: .build-base-image
base-nodejs: .build-base-image

#
# Builder Images
#
.build-builder-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := builder/$(MAKECMDGOALS:builder-%=%).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) \
		--build-arg MIRROR_SITE="$(DEBIAN_HTTPS_MIRROR_SITE)" \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

builder-go: .build-builder-image
builder-nodejs: .build-builder-image

#
# Container Images
#
.build-container-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := container/$(firstword $(subst -, ,$(MAKECMDGOALS)))/$(lastword $(subst -, ,$(MAKECMDGOALS))).dockerfile)
	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

go-scratch: .build-container-image
go-alpine: .build-container-image
go-ci: .build-container-image

#
# Push images
#
.push-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS:push-%=%))
	$(DOCKERPUSH) $(IMAGE_NAME):latest $(IMAGE_NAME):onbuild

push-base-go: .push-image
push-builder-go: .push-image

push-go-alpine: .push-image
push-go-ci: .push-image
push-go-scratch: .push-image
