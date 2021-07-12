ARG MATRIX_ROOTFS
ARG MATRIX_ARCH
ARG ROOTFS_WITH_VERSION
ARG DOCKERHUB_ARCH

FROM docker.io/${DOCKERHUB_ARCH}/node:14-${ROOTFS_WITH_VERSION} as builder

RUN apk add --no-cache build-base make python3 ;\
    npm install -g node-gyp ;\
    npm i re2 --save

COPY build/renovate /app
WORKDIR /app

# ref: https://github.com/renovatebot/renovate/blob/main/.github/workflows/release-npm.yml
RUN set -ex ;\
    # ls-lint is not supported on arm64
    yarn remove "@ls-lint/ls-lint" "npm-run-all" ;\
    # need run-s from npm-run-all
    yarn add "npm-run-all" ;\
    yarn install --dev ;\
    yarn build ;\
    chmod +x dist/*.js ;

FROM ghcr.io/arhat-dev/nix:2.3.14-${MATRIX_ROOTFS}-${MATRIX_ARCH}

ENV PATH="/app/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

# add required packages to build re2
RUN set -ex ;\
    nix-env -iA \
        stable.nodejs \
        stable.nodePackages.npm \
        stable.python39 \
        stable.gnumake \
        stable.gcc

USER root
ENV USER root

# for testing
COPY --from=builder /app/package.json /usr/local/renovate/package.json
COPY --from=builder /app/dist /usr/local/renovate/dist
COPY --from=builder /app/node_modules /usr/local/renovate/node_modules

RUN ln -s \
    /usr/local/renovate/dist/renovate.js \
    /usr/local/bin/renovate ;\
    ln -s \
    /usr/local/renovate/dist/config-validator.js \
    /usr/local/bin/renovate-config-validator

USER nixuser
ENV USER nixuser

RUN npm install -g node-gyp ;\
    npm i -g re2 --save ;\
    npm uninstall -g node-gyp ;\

# test if renovate is working
RUN set -ex ;\
    renovate --version ;\
    renovate-config-validator ;\
    node -e "new require('re2')('.*').exec('test')"
