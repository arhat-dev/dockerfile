ARG BASE_IMAGE

FROM ${BASE_IMAGE}

COPY --chmod=0775 nix/app-entrypoint.sh /usr/local/bin/entrypoint

WORKDIR /nixuser

ARG VERSION
RUN set -ex ;\
    nix-env -iA \
# re2 requires node-gyp to recompile for arm64
# and node-gyp requires
#   python3 (already installed in base image)
#   make and c toolchain
        stable.nodePackages.node-gyp \
        stable.gcc \
        stable.gnumake ;\
    git clone --depth 1 --branch "${VERSION}" \
        https://github.com/renovatebot/renovate.git \
        renovate ;\
    cd /nixuser/renovate ;\
# configure yarn and npm
# ref: https://github.com/renovatebot/renovate/blob/main/.github/workflows/build.yml
    yarn config set version-git-tag false ;\
    npm config set scripts-prepend-node-path true ;\
# build renovate from source
# ref: https://github.com/renovatebot/renovate/blob/main/.github/workflows/release-npm.yml
# ls-lint is not supported on arm64
    yarn remove "@ls-lint/ls-lint" ;\
    yarn install --dev ;\
    yarn build ;\
    yarn cache clean --all ;\
    rm -rf /nixuser/.cache ;\
    chmod +x dist/*.js ;\
# create symlinks for renovate
    mkdir -p /nixuser/bin ;\
    ln -s \
    /nixuser/renovate/dist/renovate.js \
    /nixuser/bin/renovate ;\
    ln -s \
    /nixuser/renovate/dist/config-validator.js \
    /nixuser/bin/renovate-config-validator ;\
# test whether renovate works
# ref: https://github.com/renovatebot/docker-renovate-full/blob/main/Dockerfile#L113
    renovate --version ;\
    renovate-config-validator ;\
    node -e "new require('re2')('.*').exec('test')" ;\
# remove packages only required by renovate build
    nix-env --uninstall \
        stable.nodePackages.node-gyp \
        stable.gcc \
        stable.gnumake ;\
# cleanup
    rm /nix/var/nix/gcroots/auto/* || true ;\
    nix-store --gc ;\
# TODO: compare optimse vs non-optimise in container
    nix optimise-store ;\
    nix-store --gc ;\
    nix-store --verify --check-contents

ENV PATH "/nixuser/bin:${PATH}"

ENTRYPOINT ["/usr/local/bin/entrypoint", "renovate"]

# user uid for kubernetes runAsNonRoot=true check
USER 20000

WORKDIR /nixuser/renovate
