ARG MATRIX_ROOTFS
ARG MATRIX_ARCH
ARG ROOTFS_WITH_VERSION
ARG DOCKERHUB_ARCH

FROM docker.io/${DOCKERHUB_ARCH}/node:14-${ROOTFS_WITH_VERSION} as builder

ARG MATRIX_ROOTFS

COPY nix/renovate/setup.sh /setup.sh
# need to install node-gyp to make re2 work
RUN sh /setup.sh && rm -f /setup.sh

COPY build/renovate /usr/local/renovate
WORKDIR /usr/local/renovate

# configure yarn and npm
# ref: https://github.com/renovatebot/renovate/blob/main/.github/workflows/build.yml
RUN set -ex ;\
    yarn config set version-git-tag false ;\
    npm config set scripts-prepend-node-path true

# ref: https://github.com/renovatebot/renovate/blob/main/.github/workflows/release-npm.yml
RUN set -ex ;\
    # ls-lint is not supported on arm64
    yarn remove "@ls-lint/ls-lint" ;\
    yarn install --dev ;\
    yarn build ;\
    chmod +x dist/*.js ;

FROM ghcr.io/arhat-dev/nix:2.3.14-${MATRIX_ROOTFS}-${MATRIX_ARCH}

# TODO: use /nixuser instead of /app
ENV PATH="/app/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

# add required packages to build re2
RUN set -ex ;\
    nix-env -iA \
        stable.nodejs \
        stable.nodePackages.npm \
        stable.nodePackages.node-gyp \
        stable.python39 \
        stable.gcc \
        stable.gnumake

USER root
ENV USER root

# for testing
COPY --chmod=0775 nix/renovate/entrypoint.sh /usr/local/bin/entrypoint
COPY --from=builder /usr/local/renovate /usr/local/renovate

# re2 is a optional dependency at compile time but required by
# renovate at runtime, so we have to install it manually
#
# re2 requires node-gyp (installed via nix-env) to recompile for arm64
WORKDIR /usr/local/renovate
RUN set -ex ;\
    chown -R nixuser:nixgroup /usr/local/renovate ;\
    npm install re2 --save

RUN ln -s \
    /usr/local/renovate/dist/renovate.js \
    /usr/local/bin/renovate ;\
    ln -s \
    /usr/local/renovate/dist/config-validator.js \
    /usr/local/bin/renovate-config-validator

# RUN set -ex ;\
#     mkdir -p /root/.npm ;\
#     chmod 0755 /root/.npm ;\
#     npm install -g node-gyp ;\
#     npm install -g re2 --save ;\
#     npm uninstall -g node-gyp

USER nixuser
ENV USER nixuser

# test whether renovate is working
# ref: https://github.com/renovatebot/docker-renovate-full/blob/main/Dockerfile#L113
RUN set -ex ;\
    renovate --version ;\
    renovate-config-validator ;\
    node -e "new require('re2')('.*').exec('test')"

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["renovate"]
