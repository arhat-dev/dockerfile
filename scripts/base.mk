DOCKERBUILD := docker build
DOCKERPUSH := docker push

DOCKER_REPO := arhatdev

#
# Base Images
#
.build-base-image:
	$(eval DOCKERFILE := $(MAKECMDGOALS:base-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := base/$(LANGUAGE)/$(DOCKERFILE:$(LANGUAGE)-%=%).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/base-$(LANGUAGE):$(MAKECMDGOALS:base-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) -t $(IMAGE_NAME) .

#
# Builder Images
#
.build-builder-image:
	$(eval DOCKERFILE := $(MAKECMDGOALS:builder-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := builder/$(LANGUAGE)/$(DOCKERFILE:$(LANGUAGE)-%=%).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/builder-$(LANGUAGE):$(MAKECMDGOALS:builder-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) -t $(IMAGE_NAME) .

#
# Multi-arch Builder Images
#
.build-multi-arch-builder-image:
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:builder-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := $(DOCKERFILE:$(LANGUAGE)-%=%))
	$(eval DOCKERFILE := builder/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/builder-$(LANGUAGE):$(MAKECMDGOALS:builder-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) -t $(IMAGE_NAME) .

#
# Container Images (for scratch)
#
.build-container-image:
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(LANGUAGE):$(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) -t $(IMAGE_NAME) .

#
# Multi-arch Container Images
#
.build-multi-arch-container-image:
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(LANGUAGE):$(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) \
		--build-arg DOCKER_ARCH=$($(ARCH)) -t $(IMAGE_NAME) .

#
# Push images
#
.push-image:
	$(eval IMAGE_PREFIX := $(MAKECMDGOALS:push-%=%))
	$(eval TARGET := $(IMAGE_PREFIX:base-%=%))
	$(eval TARGET := $(TARGET:builder-%=%))

	$(eval LANGUAGE := $(firstword $(subst -, ,$(TARGET))))
	$(eval ROOTFS := $(TARGET:$(LANGUAGE)-%=%))
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(IMAGE_PREFIX:-$(ROOTFS)=):$(ROOTFS))
	
	$(DOCKERPUSH) $(IMAGE_NAME)
