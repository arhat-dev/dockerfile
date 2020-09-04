# base images
base-go-debian-armv7: .build-base-image
base-go-debian-arm64: .build-base-image
base-go-debian-amd64: .build-base-image
base-go-debian-i386: .build-base-image
base-go-debian-ppc64le: .build-base-image
base-go-debian-s390x: .build-base-image
base-go-debian-mips64le: .build-base-image

base-go-alpine-armv6: .build-base-image
base-go-alpine-armv7: .build-base-image
base-go-alpine-arm64: .build-base-image
base-go-alpine-amd64: .build-base-image
base-go-alpine-i386: .build-base-image
base-go-alpine-ppc64le: .build-base-image
base-go-alpine-s390x: .build-base-image

# builder images
builder-go-debian-armv7: .build-builder-image
builder-go-debian-arm64: .build-builder-image
builder-go-debian-amd64: .build-builder-image
builder-go-debian-i386: .build-builder-image
builder-go-debian-ppc64le: .build-builder-image
builder-go-debian-s390x: .build-builder-image
builder-go-debian-mips64le: .build-builder-image

builder-go-alpine-armv6: .build-builder-image
builder-go-alpine-armv7: .build-builder-image
builder-go-alpine-arm64: .build-builder-image
builder-go-alpine-amd64: .build-builder-image
builder-go-alpine-i386: .build-builder-image
builder-go-alpine-ppc64le: .build-builder-image
builder-go-alpine-s390x: .build-builder-image

# container images
go-scratch: .build-scratch-container-image

go-debian-armv7: .build-container-image
go-debian-arm64: .build-container-image
go-debian-amd64: .build-container-image
go-debian-i386: .build-container-image
go-debian-ppc64le: .build-container-image
go-debian-s390x: .build-container-image
go-debian-mips64le: .build-container-image

go-alpine-armv6: .build-container-image
go-alpine-armv7: .build-container-image
go-alpine-arm64: .build-container-image
go-alpine-amd64: .build-container-image
go-alpine-i386: .build-container-image
go-alpine-ppc64le: .build-container-image
go-alpine-s390x: .build-container-image

images-base-go:
	./scripts/build-targets.sh base go

images-builder-go:
	./scripts/build-targets.sh builder go

images-container-go:
	./scripts/build-targets.sh container go
