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

# go
RUN set -ex ;\
    nix-env -iA stable.go

# docker
RUN set -ex ;\
    nix-env -iA stable.docker-client

# dotnet
RUN set -ex ;\
    nix-env -iA stable.dotnet-sdk_3

# nodejs
RUN set -ex ;\
    nix-env -iA stable.nodejs ;\
    nix-env -iA stable.yarn ;\
    nix-env -iA stable.nodePackages.npm ;\
    nix-env -iA stable.nodePackages.pnpm ;\
    nix-env -iA stable.nodePackages.lerna

# ruby
RUN set -ex ;\
    nix-env -iA stable.ruby_3_0
# cocoapods has no arm64 release for now
# nix-env -iA stable.cocoapods

# erlang
RUN set -ex ;\
    nix-env -iA stable.erlangR22 ;\
    nix-env -iA unstable.elixir

# rust
RUN set -ex ;\
    nix-env -iA stable.cargo ;\
    nix-env -iA stable.rustc

# python
RUN set -ex ;\
    # missing stable.python39Packages.hashin \
    nix-env -iA stable.python39 ;\
    nix-env -iA stable.pipenv ;\
    nix-env -iA stable.poetry ;\
    nix-env -iA stable.python39Packages.pip-tools ;\

# php
RUN set -ex ;\
    nix-env -iA stable.php ;\
    nix-env -iA stable.php74Packages.composer

# java
RUN set -ex ;\
    nix-env -iA stable.jdk11_headless ;\
    nix-env -iA stable.gradle_6

# kubernetes
RUN set -ex ;\
    nix-env -iA unstable.kubernetes-helm

COPY --from=builder /app/dist /usr/local/renovate/dist
COPY --from=builder /app/node_modules /usr/local/renovate/node_modules

RUN ln -s \
    /usr/local/renovate/dist/renovate.js \
    /usr/local/bin/renovate ;\
    ln -s \
    /usr/local/renovate/dist/config-validator.js \
    /usr/local/bin/renovate-config-validator

RUN set -ex ;\
    renovate --version ;\
    renovate-config-validator ;\
    node -e "new require('re2')('.*').exec('test')"

RUN npm install -g node-gyp ;\
    npm i -g re2 --save

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["renovate"]
