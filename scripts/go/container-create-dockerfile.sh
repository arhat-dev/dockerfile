#!/bin/sh

docker_platform_arch="${1}"

cat <<EOF > "container/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM --platform=linux/${docker_platform_arch} ghcr.io/arhat-dev/builder-${MATRIX_LANGUAGE}:${MATRIX_ROOTFS}-${MATRIX_ARCH} as builder
FROM --platform=linux/${docker_platform_arch} docker.io/library/alpine:${ALPINE_VERSION}

ONBUILD ARG TARGET
ONBUILD ARG APP=\${TARGET}
ONBUILD COPY --from=builder /app/build/\${TARGET} /\${APP}
EOF
