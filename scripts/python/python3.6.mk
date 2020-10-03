# python3.6

base-python3.6-alpine-armv6: .build-base-image
base-python3.6-alpine-armv7: .build-base-image
base-python3.6-alpine-arm64: .build-base-image
base-python3.6-alpine-amd64: .build-base-image
base-python3.6-alpine-ppc64le: .build-base-image
base-python3.6-alpine-s390x: .build-base-image
base-python3.6-alpine-x86: .build-base-image

builder-python3.6-alpine-armv6: .build-builder-image
builder-python3.6-alpine-armv7: .build-builder-image
builder-python3.6-alpine-arm64: .build-builder-image
builder-python3.6-alpine-amd64: .build-builder-image
builder-python3.6-alpine-ppc64le: .build-builder-image
builder-python3.6-alpine-s390x: .build-builder-image
builder-python3.6-alpine-x86: .build-builder-image

python3.6-alpine-armv6: .build-container-image
python3.6-alpine-armv7: .build-container-image
python3.6-alpine-arm64: .build-container-image
python3.6-alpine-amd64: .build-container-image
python3.6-alpine-ppc64le: .build-container-image
python3.6-alpine-s390x: .build-container-image
python3.6-alpine-x86: .build-container-image

base-python3.6-debian-armv5: .build-base-image
base-python3.6-debian-armv7: .build-base-image
base-python3.6-debian-arm64: .build-base-image
base-python3.6-debian-amd64: .build-base-image
base-python3.6-debian-mips64le: .build-base-image
base-python3.6-debian-ppc64le: .build-base-image
base-python3.6-debian-s390x: .build-base-image
base-python3.6-debian-x86: .build-base-image

builder-python3.6-debian-armv5: .build-builder-image
builder-python3.6-debian-armv7: .build-builder-image
builder-python3.6-debian-arm64: .build-builder-image
builder-python3.6-debian-amd64: .build-builder-image
builder-python3.6-debian-mips64le: .build-builder-image
builder-python3.6-debian-ppc64le: .build-builder-image
builder-python3.6-debian-s390x: .build-builder-image
builder-python3.6-debian-x86: .build-builder-image

python3.6-debian-armv5: .build-container-image
python3.6-debian-armv7: .build-container-image
python3.6-debian-arm64: .build-container-image
python3.6-debian-amd64: .build-container-image
python3.6-debian-mips64le: .build-container-image
python3.6-debian-ppc64le: .build-container-image
python3.6-debian-s390x: .build-container-image
python3.6-debian-x86: .build-container-image

images-base-python3.6:
	./scripts/build-targets.sh base python3.6

images-builder-python3.6:
	./scripts/build-targets.sh builder python3.6

images-container-python3.6:
	./scripts/build-targets.sh container python3.6
