# always latest
base-go-stretch: .build-base-image

push-base-go: .push-image


builder-go-stretch: .build-builder-image

push-builder-go: .push-image


go-scratch: .build-container-image
go-alpine-arm64: .build-multi-arch-container-image
go-alpine-armv7: .build-multi-arch-container-image
go-alpine-amd64: .build-multi-arch-container-image
go-stretch-arm64: .build-multi-arch-container-image
go-stretch-armv7: .build-multi-arch-container-image
go-stretch-amd64: .build-multi-arch-container-image

push-go: .push-image
