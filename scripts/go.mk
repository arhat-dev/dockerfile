# always latest
base-go-stretch: .build-base-image

push-base-go-stretch: .push-image

builder-go-stretch: .build-builder-image

push-builder-go-stretch: .push-image

go-scratch: .build-container-image
go-alpine-arm64: .build-multi-arch-container-image
go-alpine-armv7: .build-multi-arch-container-image
go-alpine-amd64: .build-multi-arch-container-image

push-go-scratch: .push-image
push-go-alpine-arm64: .push-image
push-go-alpine-armv7: .push-image
push-go-alpine-amd64: .push-image
