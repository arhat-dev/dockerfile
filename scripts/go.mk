# always latest
base-go-debian: .build-base-image

push-base-go: .push-image


builder-go-debian: .build-builder-image

push-builder-go: .push-image


go-scratch: .build-container-image

go-alpine-armv6: .build-multi-arch-container-image
go-alpine-armv7: .build-multi-arch-container-image
go-alpine-arm64: .build-multi-arch-container-image
go-alpine-amd64: .build-multi-arch-container-image

go-debian-armv6: .build-multi-arch-container-image
go-debian-armv7: .build-multi-arch-container-image
go-debian-arm64: .build-multi-arch-container-image
go-debian-amd64: .build-multi-arch-container-image

push-go: .push-image
