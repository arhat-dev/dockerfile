DOCKERBUILD := docker build
DOCKERPUSH := docker push
DOCKERMANIFEST := docker manifest

DOCKER_REPO := arhatdev

QEMU_VERSION := v4.0.0-2

#
# Base Images
#
.build-base-image:
	$(eval DOCKERFILE := $(MAKECMDGOALS:base-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := base/$(LANGUAGE)/$(DOCKERFILE:$(LANGUAGE)-%=%).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/base-$(LANGUAGE):$(MAKECMDGOALS:base-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg QEMU_VERSION=$(QEMU_VERSION) -t $(IMAGE_NAME) .

#
# Builder Images
#
.build-builder-image: .docker-login
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:builder-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := $(DOCKERFILE:$(LANGUAGE)-%=%))
	$(eval MANIFEST_NAME := $(DOCKER_REPO)/builder-$(LANGUAGE):$(firstword $(subst -, , $(DOCKERFILE)))-latest)
	$(eval DOCKERFILE := builder/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/builder-$(LANGUAGE):$(MAKECMDGOALS:builder-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) -t $(IMAGE_NAME) .

	$(eval MANIFEST_ARCH := $(ARCH:v7=))
	$(eval MANIFEST_ARCH := $(MANIFEST_ARCH:v6=))
	$(eval MANIFEST_VARIANT := $(ARCH:amd64%=%))
	$(eval MANIFEST_VARIANT := $(MANIFEST_VARIANT:arm64%=%))
	$(eval MANIFEST_VARIANT := $(MANIFEST_VARIANT:arm%=%))
	$(eval MANIFEST_ARGS := --arch $(MANIFEST_ARCH) --os linux)
	$(if $(MANIFEST_VARIANT),$(eval MANIFEST_ARGS := $(MANIFEST_ARGS) --variant $(MANIFEST_VARIANT)),)

	$(DOCKERMANIFEST) create $(MANIFEST_NAME) $(IMAGE_NAME) || $(DOCKERMANIFEST) create $(MANIFEST_NAME) --amend $(IMAGE_NAME)
	$(DOCKERMANIFEST) annotate $(MANIFEST_NAME) $(IMAGE_NAME) $(MANIFEST_ARGS)
	$(DOCKERMANIFEST) push $(MANIFEST_NAME)

#
# Container Images (for scratch)
#
.build-scratch-container-image:
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(LANGUAGE):$(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) -t $(IMAGE_NAME) .

#
# Container Images
#
.build-container-image: .docker-login
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval MANIFEST_NAME := $(DOCKER_REPO)/$(LANGUAGE):$(firstword $(subst -, , $(DOCKERFILE)))-latest)
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(LANGUAGE):$(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) \
		--build-arg DOCKER_ARCH=$($(ARCH)) -t $(IMAGE_NAME) .
	
	$(eval MANIFEST_ARCH := $(ARCH:v7=))
	$(eval MANIFEST_ARCH := $(MANIFEST_ARCH:v6=))
	$(eval MANIFEST_VARIANT := $(ARCH:amd64%=%))
	$(eval MANIFEST_VARIANT := $(MANIFEST_VARIANT:arm64%=%))
	$(eval MANIFEST_VARIANT := $(MANIFEST_VARIANT:arm%=%))
	$(eval MANIFEST_ARGS := --arch $(MANIFEST_ARCH) --os linux)
	$(if $(MANIFEST_VARIANT),$(eval MANIFEST_ARGS := $(MANIFEST_ARGS) --variant $(MANIFEST_VARIANT)),)

	$(DOCKERMANIFEST) create $(MANIFEST_NAME) $(IMAGE_NAME) || $(DOCKERMANIFEST) create $(MANIFEST_NAME) --amend $(IMAGE_NAME)
	$(DOCKERMANIFEST) annotate $(MANIFEST_NAME) $(IMAGE_NAME) $(MANIFEST_ARGS)
	$(DOCKERMANIFEST) push $(MANIFEST_NAME)

#
# Push images
#
.push-image:
	$(DOCKERPUSH) $(DOCKER_REPO)/$(MAKECMDGOALS:push-%=%)

.docker-login:
	docker login -u=$(DOCKER_USERNAME) -p=$(DOCKER_PASSWORD) || true
