#!/bin/sh

docker_platform_arch="${1}"

py_ver="${MATRIX_LANGUAGE#python}"
suffix=""
case "${MATRIX_ROOTFS}" in
debian)
  suffix="${DEBIAN_VERSION}"
  ;;
alpine)
  suffix="alpine${ALPINE_VERSION}"
  ;;
*)
  echo "Unknown rootfs ${MATRIX_ROOTFS}"
  exit 1
  ;;
esac

cat <<EOF > "container/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM --platform=linux/${docker_platform_arch} ghcr.io/arhat-dev/builder-${MATRIX_LANGUAGE}:${MATRIX_ROOTFS}-${MATRIX_ARCH} as builder
FROM --platform=linux/${docker_platform_arch} docker.io/library/python:${py_ver}-${suffix}

ONBUILD COPY --from=builder /app /app

WORKDIR /app

COPY scripts/python/entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "python", "/app/main.py" ]
EOF