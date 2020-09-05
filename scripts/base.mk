DOCKERBUILD := docker build
DOCKERPUSH := docker push

DOCKERHUB_REPO := docker.io/arhatdev
GITHUBPKG_REPO := ghcr.io/arhat-dev

#
# Base Images
#
.build-base-image:
	$(eval DOCKERFILE := $(MAKECMDGOALS:base-%=%))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(DOCKERFILE))))
	$(eval DOCKERFILE := base/$(LANGUAGE)/$(DOCKERFILE:$(LANGUAGE)-%=%).dockerfile)
	$(eval IMAGE_NAME := base-$(LANGUAGE):$(MAKECMDGOALS:base-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(DOCKERHUB_REPO)/$(IMAGE_NAME) \
		-t $(GITHUBPKG_REPO)/$(IMAGE_NAME) .

	$(DOCKERPUSH) $(DOCKERHUB_REPO)/$(IMAGE_NAME)
	$(DOCKERPUSH) $(GITHUBPKG_REPO)/$(IMAGE_NAME)

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
	$(eval IMAGE_NAME := builder-$(LANGUAGE))
	$(eval IMAGE_TAG := $(MAKECMDGOALS:builder-$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) --build-arg ARCH=$(ARCH) \
		-t $(DOCKERHUB_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(GITHUBPKG_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) .

	$(DOCKERPUSH) $(DOCKERHUB_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
	$(DOCKERPUSH) $(GITHUBPKG_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

	./scripts/manifest.sh create $(DOCKERHUB_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG)
	./scripts/manifest.sh annotate $(DOCKERHUB_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG) $(ARCH)
	./scripts/manifest.sh push $(DOCKERHUB_REPO)/$(IMAGE_NAME) $(MANIFEST_TAG)

	./scripts/manifest.sh create $(GITHUBPKG_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG)
	./scripts/manifest.sh annotate $(GITHUBPKG_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG) $(ARCH)
	./scripts/manifest.sh push $(GITHUBPKG_REPO)/$(IMAGE_NAME) $(MANIFEST_TAG)

#
# Container Images (for scratch)
#
.build-scratch-container-image:
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE).dockerfile)
	$(eval IMAGE_NAME := $(LANGUAGE):$(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) \
		-t $(DOCKERHUB_REPO)/$(IMAGE_NAME) \
		-t $(GITHUBPKG_REPO)/$(IMAGE_NAME) .

	$(DOCKERPUSH) $(DOCKERHUB_REPO)/$(IMAGE_NAME)
	$(DOCKERPUSH) $(GITHUBPKG_REPO)/$(IMAGE_NAME)

#
# Container Images
#
.build-container-image:
	$(eval ARCH := $(lastword $(subst -, ,$(MAKECMDGOALS))))
	$(eval LANGUAGE := $(firstword $(subst -, ,$(MAKECMDGOALS))))
	$(eval DOCKERFILE := $(MAKECMDGOALS:$(firstword $(subst -, ,$(MAKECMDGOALS)))-%=%))
	$(eval MANIFEST_TAG := $(firstword $(subst -, , $(DOCKERFILE))))
	$(eval DOCKERFILE := container/$(LANGUAGE)/$(DOCKERFILE:-$(ARCH)=).dockerfile)
	$(eval IMAGE_NAME := $(LANGUAGE))
	$(eval IMAGE_TAG := $(MAKECMDGOALS:$(LANGUAGE)-%=%))

	$(DOCKERBUILD) -f $(DOCKERFILE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg DOCKER_ARCH=$($(ARCH)) \
		-t $(DOCKERHUB_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(GITHUBPKG_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) .

	$(DOCKERPUSH) $(DOCKERHUB_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
	$(DOCKERPUSH) $(GITHUBPKG_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

	./scripts/manifest.sh create $(DOCKERHUB_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG)
	./scripts/manifest.sh annotate $(DOCKERHUB_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG) $(ARCH)
	./scripts/manifest.sh push $(DOCKERHUB_REPO)/$(IMAGE_NAME) $(MANIFEST_TAG)

	./scripts/manifest.sh create $(GITHUBPKG_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG)
	./scripts/manifest.sh annotate $(GITHUBPKG_REPO)/$(IMAGE_NAME) $(IMAGE_TAG) $(MANIFEST_TAG) $(ARCH)
	./scripts/manifest.sh push $(GITHUBPKG_REPO)/$(IMAGE_NAME) $(MANIFEST_TAG)
