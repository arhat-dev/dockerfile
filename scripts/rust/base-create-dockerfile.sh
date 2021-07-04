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

base_image="docker.io/${dockerhub_arch}/rust:${RUST_VERSION}-${suffix}"
dockerfile="base/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"

if [ "${MATRIX_ARCH}" = "amd64" ]; then
  case "${MATRIX_ROOTFS}" in
  debian)
    cat <<EOF >"${dockerfile}"
FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MIRROR_SITE

COPY scripts/${MATRIX_LANGUAGE}/base-setup-debian-amd64.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh

ENV PATH="${PATH}:/opt/arm-none-linux-gnueabihf/bin:/opt/aarch64-none-linux-gnu/bin"

COPY scripts/${MATRIX_LANGUAGE}/cargo-config/${MATRIX_ROOTFS}-${MATRIX_ARCH}.toml /root/.cargo/config
EOF
    exit 0
    ;;
  alpine)
    cat <<EOF >"${dockerfile}"
FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh

COPY scripts/${MATRIX_LANGUAGE}/cargo-config/${MATRIX_ROOTFS}-${MATRIX_ARCH}.toml /root/.cargo/config
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

ARG MIRROR_SITE

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh

COPY scripts/${MATRIX_LANGUAGE}/cargo-config/${MATRIX_ROOTFS}-${MATRIX_ARCH}.toml /root/.cargo/config
EOF
