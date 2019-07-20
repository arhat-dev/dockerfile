# python3.6

base-python3.6-alpine-armv6: .build-base-image
base-python3.6-alpine-armv7: .build-base-image
base-python3.6-alpine-arm64: .build-base-image
base-python3.6-alpine-amd64: .build-base-image

push-base-python3.6: .push-image

builder-python3.6-alpine-armv6: .build-builder-image
builder-python3.6-alpine-armv7: .build-builder-image
builder-python3.6-alpine-arm64: .build-builder-image
builder-python3.6-alpine-amd64: .build-builder-image

push-builder-python3.6: .push-image

python3.6-alpine-armv6: .build-container-image
python3.6-alpine-armv7: .build-container-image
python3.6-alpine-arm64: .build-container-image
python3.6-alpine-amd64: .build-container-image

push-python3.6: .push-image

# python3.7

base-python3.7-alpine-armv6: .build-base-image
base-python3.7-alpine-armv7: .build-base-image
base-python3.7-alpine-arm64: .build-base-image
base-python3.7-alpine-amd64: .build-base-image

push-base-python3.7: .push-image

builder-python3.7-alpine-armv6: .build-builder-image
builder-python3.7-alpine-armv7: .build-builder-image
builder-python3.7-alpine-arm64: .build-builder-image
builder-python3.7-alpine-amd64: .build-builder-image

push-builder-python3.7: .push-image

python3.7-alpine-armv6: .build-container-image
python3.7-alpine-armv7: .build-container-image
python3.7-alpine-arm64: .build-container-image
python3.7-alpine-amd64: .build-container-image

push-python3.7: .push-image
