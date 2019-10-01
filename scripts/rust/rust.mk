# rust

base-rust-debian-armv7: .build-base-image
base-rust-debian-arm64: .build-base-image
base-rust-debian-amd64: .build-base-image

builder-rust-debian-armv7: .build-builder-image
builder-rust-debian-arm64: .build-builder-image
builder-rust-debian-amd64: .build-builder-image

rust-scratch: .build-scratch-container-image

rust-debian-armv7: .build-container-image
rust-debian-arm64: .build-container-image
rust-debian-amd64: .build-container-image

rust-alpine-armv6: .build-container-image
rust-alpine-armv7: .build-container-image
rust-alpine-arm64: .build-container-image
rust-alpine-amd64: .build-container-image

