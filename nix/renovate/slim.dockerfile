ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/nix:2.3.14-${MATRIX_ROOTFS}-${MATRIX_ARCH}

ENV PATH="/nixuser/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

# add required packages to build re2
RUN set -ex ;\
    nix-env -iA \
        stable.nodejs \
        stable.yarn \
        stable.nodePackages.npm \
        stable.nodePackages.node-gyp \
        stable.python39 \
        stable.python39Packages.setuptools \
        stable.gcc \
        stable.gnumake \
        stable.git

COPY --chmod=0775 nix/app-entrypoint.sh /usr/local/bin/entrypoint

ARG VERSION
RUN set -ex ;\
    git clone --depth 1 --branch "${VERSION}" \
        https://github.com/renovatebot/renovate.git \
        renovate

WORKDIR /nixuser/renovate

# configure yarn and npm
# ref: https://github.com/renovatebot/renovate/blob/main/.github/workflows/build.yml
RUN set -ex ;\
    yarn config set version-git-tag false ;\
    npm config set scripts-prepend-node-path true

# re2 requires node-gyp (installed via nix-env) to be recompiled for arm64
# ref: https://github.com/renovatebot/renovate/blob/main/.github/workflows/release-npm.yml
RUN set -ex ;\
    # ls-lint is not supported on arm64
    yarn remove "@ls-lint/ls-lint" ;\
    yarn install --dev ;\
    yarn build ;\
    yarn cache clean --all ;\
    rm -rf /nixuser/.cache ;\
    chmod +x dist/*.js

ENV PATH "/nixuser/bin:${PATH}"
RUN set -ex ;\
    mkdir -p /nixuser/bin ;\
    ln -s \
    /nixuser/renovate/dist/renovate.js \
    /nixuser/bin/renovate ;\
    ln -s \
    /nixuser/renovate/dist/config-validator.js \
    /nixuser/bin/renovate-config-validator

# test whether renovate is working
# ref: https://github.com/renovatebot/docker-renovate-full/blob/main/Dockerfile#L113
RUN set -ex ;\
    renovate --version ;\
    renovate-config-validator ;\
    node -e "new require('re2')('.*').exec('test')"

ENTRYPOINT ["/usr/local/bin/entrypoint", "renovate"]

# user uid for kubernetes runAsNonRoot=false check
USER 20000
