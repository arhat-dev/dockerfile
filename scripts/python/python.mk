# python3.6

base-python3.6-alpine-armv6: .build-base-image
base-python3.6-alpine-armv7: .build-base-image
base-python3.6-alpine-arm64: .build-base-image
base-python3.6-alpine-amd64: .build-base-image

builder-python3.6-alpine-armv6: .build-builder-image
builder-python3.6-alpine-armv7: .build-builder-image
builder-python3.6-alpine-arm64: .build-builder-image
builder-python3.6-alpine-amd64: .build-builder-image

python3.6-alpine-armv6: .build-container-image
python3.6-alpine-armv7: .build-container-image
python3.6-alpine-arm64: .build-container-image
python3.6-alpine-amd64: .build-container-image

base-python3.6-debian-armv7: .build-base-image
base-python3.6-debian-arm64: .build-base-image
base-python3.6-debian-amd64: .build-base-image

builder-python3.6-debian-armv7: .build-builder-image
builder-python3.6-debian-arm64: .build-builder-image
builder-python3.6-debian-amd64: .build-builder-image

python3.6-debian-armv7: .build-container-image
python3.6-debian-arm64: .build-container-image
python3.6-debian-amd64: .build-container-image

# python3.7

base-python3.7-alpine-armv6: .build-base-image
base-python3.7-alpine-armv7: .build-base-image
base-python3.7-alpine-arm64: .build-base-image
base-python3.7-alpine-amd64: .build-base-image

builder-python3.7-alpine-armv6: .build-builder-image
builder-python3.7-alpine-armv7: .build-builder-image
builder-python3.7-alpine-arm64: .build-builder-image
builder-python3.7-alpine-amd64: .build-builder-image

python3.7-alpine-armv6: .build-container-image
python3.7-alpine-armv7: .build-container-image
python3.7-alpine-arm64: .build-container-image
python3.7-alpine-amd64: .build-container-image

base-python3.7-debian-armv7: .build-base-image
base-python3.7-debian-arm64: .build-base-image
base-python3.7-debian-amd64: .build-base-image

builder-python3.7-debian-armv7: .build-builder-image
builder-python3.7-debian-arm64: .build-builder-image
builder-python3.7-debian-amd64: .build-builder-image

python3.7-debian-armv7: .build-container-image
python3.7-debian-arm64: .build-container-image
python3.7-debian-amd64: .build-container-image

# python3.8

base-python3.8-alpine-armv6: .build-base-image
base-python3.8-alpine-armv7: .build-base-image
base-python3.8-alpine-arm64: .build-base-image
base-python3.8-alpine-amd64: .build-base-image

builder-python3.8-alpine-armv6: .build-builder-image
builder-python3.8-alpine-armv7: .build-builder-image
builder-python3.8-alpine-arm64: .build-builder-image
builder-python3.8-alpine-amd64: .build-builder-image

python3.8-alpine-armv6: .build-container-image
python3.8-alpine-armv7: .build-container-image
python3.8-alpine-arm64: .build-container-image
python3.8-alpine-amd64: .build-container-image

base-python3.8-debian-armv7: .build-base-image
base-python3.8-debian-arm64: .build-base-image
base-python3.8-debian-amd64: .build-base-image

builder-python3.8-debian-armv7: .build-builder-image
builder-python3.8-debian-arm64: .build-builder-image
builder-python3.8-debian-amd64: .build-builder-image

python3.8-debian-armv7: .build-container-image
python3.8-debian-arm64: .build-container-image
python3.8-debian-amd64: .build-container-image

images-base-python:
	./scripts/build-targets.sh base python

images-builder-python:
	./scripts/build-targets.sh builder python

images-container-python:
	./scripts/build-targets.sh container python
