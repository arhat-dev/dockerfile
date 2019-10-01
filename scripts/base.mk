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
	$(DOCKERPUSH) $(IMAGE_NAME)

#
# Builder Images
#
.build-builder-image:
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:builder-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := $(DOCKERFILE:$(LANGUAGE)-%=%))
	$(eval MANIFEST_TAG := $(firstword $(subst -, , $(DOCKERFILE))))
	$(eval DOCKERFILE := builder/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(eval IMAGE_REPO := $(DOCKER_REPO)/builder-$(LANGUAGE))
	$(eval IMAGE_TAG := $(MAKECMDGOALS:builder-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) -t $(IMAGE_REPO):$(IMAGE_TAG) .
	$(DOCKERPUSH) $(IMAGE_REPO):$(IMAGE_TAG)

	./scripts/manifest.sh create $(IMAGE_REPO) $(IMAGE_TAG) $(MANIFEST_TAG)
	./scripts/manifest.sh annotate $(IMAGE_REPO) $(IMAGE_TAG) $(MANIFEST_TAG) $(ARCH)
	./scripts/manifest.sh push $(IMAGE_REPO) $(MANIFEST_TAG)

#
# Container Images (for scratch)
#
.build-scratch-container-image:
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE).dockerfile)
	$(eval IMAGE_NAME := $(DOCKER_REPO)/$(LANGUAGE):$(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) -t $(IMAGE_NAME) .
	$(DOCKERPUSH) $(IMAGE_NAME)

#
# Container Images
#
.build-container-image:
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval MANIFEST_TAG := $(firstword $(subst -, , $(DOCKERFILE))))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(eval IMAGE_REPO := $(DOCKER_REPO)/$(LANGUAGE))
	$(eval IMAGE_TAG := $(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) --build-arg DOCKER_ARCH=$($(ARCH)) -t $(IMAGE_REPO):$(IMAGE_TAG) .
	$(DOCKERPUSH) $(IMAGE_REPO):$(IMAGE_TAG)

	./scripts/manifest.sh create $(IMAGE_REPO) $(IMAGE_TAG) $(MANIFEST_TAG)
	./scripts/manifest.sh annotate $(IMAGE_REPO) $(IMAGE_TAG) $(MANIFEST_TAG) $(ARCH)
	./scripts/manifest.sh push $(IMAGE_REPO) $(MANIFEST_TAG)
