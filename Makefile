DOCKERBUILD := docker build
DOCKERPUSH := docker push

DEBIAN_HTTPS_MIRROR_SITE := mirrors.ocf.berkeley.edu
DOCKER_REPO := arhatdev

MAKECMDGOALS ?= go-builder

#
# Builders
#
.build-builder-image:
	$(eval TARGET := $(MAKECMDGOALS))
	$(DOCKERBUILD) \
		--build-arg MIRROR_SITE="$(DEBIAN_HTTPS_MIRROR_SITE)" \
		-t $(DOCKER_REPO)/$(TARGET):onbuild \
		-f builder/$(TARGET).dockerfile .

go-builder: .build-builder-image

#
# Containers
#
.build-container-image:
	$(eval TARGET := $(MAKECMDGOALS))
	$(DOCKERBUILD) \
		-t $(DOCKER_REPO)/$(TARGET):onbuild \
		-f container/$(TARGET).dockerfile .

go-scratch: .build-container-image
go-alpine: .build-container-image

#
# Push images
#
.push-image:
	$(eval TARGET := $(MAKECMDGOALS))
	$(DOCKERPUSH) $(DOCKER_REPO)/$(TARGET):onbuild

go-builder-push: .push-image
go-scratch-push: .push-image
go-alpine-push: .push-image
