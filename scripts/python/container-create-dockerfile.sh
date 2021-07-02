#!/bin/sh

dockerhub_arch="${1}"

py_ver="${MATRIX_LANGUAGE#python}"
suffix=""
case "${MATRIX_ROOTFS}" in
debian)
  suffix="slim-${DEBIAN_VERSION}"
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
FROM docker.io/${dockerhub_arch}/python:${py_ver}-${suffix}

WORKDIR /app

COPY scripts/python/entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "python", "/app/main.py" ]
EOF
