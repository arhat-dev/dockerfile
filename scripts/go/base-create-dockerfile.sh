#!/bin/sh

dockerhub_arch="${1}"
qemu_arch="${2}"
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

base_image="docker.io/${dockerhub_arch}/golang:${GO_VERSION}-${suffix}"
dockerfile="base/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"

if [ "${MATRIX_ARCH}" = "amd64" ]; then
  case "${MATRIX_ROOTFS}" in
  debian)
    cat <<EOF >"${dockerfile}"
FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}-amd64.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
    exit 0
    ;;
  alpine)
    cat <<EOF >"${dockerfile}"
FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
    exit 0
    ;;
  esac
fi

cat <<EOF >"${dockerfile}"
FROM docker.io/multiarch/qemu-user-static:x86_64-${qemu_arch}-${QEMU_VERSION} as qemu
FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=qemu /usr/bin/qemu* /usr/bin/

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
