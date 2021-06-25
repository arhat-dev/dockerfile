#!/bin/sh

dockerhub_arch="${1}"
suffix=""

case "${MATRIX_ROOTFS}" in
debian)
  suffix="${DEBIAN_VERSION}"
  ;;
alpine)
  suffix="${ALPINE_VERSION}"
  ;;
*)
  echo "Unknown rootfs ${MATRIX_ROOTFS}"
  exit 1
  ;;
esac

cat <<EOF >"container/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM ghcr.io/arhat-dev/builder-${MATRIX_LANGUAGE}:${MATRIX_ROOTFS}-${MATRIX_ARCH} as builder
FROM docker.io/${dockerhub_arch}/${MATRIX_ROOTFS}:${suffix}

ONBUILD ARG TARGET
ONBUILD ARG APP=\${TARGET}
ONBUILD COPY --from=builder /app/build/\${TARGET} /\${APP}
EOF
