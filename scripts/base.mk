DOCKERBUILD := docker build
DOCKERPUSH := docker push

DOCKER_REPO := arhatdev

#
# Base Images
#
.build-base-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := $(MAKECMDGOALS:base-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := base/$(LANGUAGE)/$(DOCKERFILE:$(LANGUAGE)-%=%).dockerfile)

	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

#
# Builder Images
#
.build-builder-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval DOCKERFILE := $(MAKECMDGOALS:builder-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := builder/$(LANGUAGE)/$(DOCKERFILE:$(LANGUAGE)-%=%).dockerfile)

	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

#
# Multi-arch Builder Images
#
.build-multi-arch-builder-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:builder-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := $(DOCKERFILE:$(LANGUAGE)-%=%))
	$(eval DOCKERFILE := builder/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

#
# Container Images (for scratch)
#
.build-container-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE).dockerfile)

	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

#
# Multi-arch Container Images
#
.build-multi-arch-container-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS))
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)

	$(DOCKERBUILD) -f $(DOCKERFILE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg DOCKER_ARCH=$($(ARCH)) \
		-t $(IMAGE_NAME):latest -t $(IMAGE_NAME):onbuild .

#
# Push images
#
.push-image:
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(MAKECMDGOALS:push-%=%))
	$(DOCKERPUSH) $(IMAGE_NAME)
