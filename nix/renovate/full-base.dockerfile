ARG NIX_IMAGE

FROM ${NIX_IMAGE}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# nodejs
# also used to build renovate
RUN set -ex ;\
    nix-env -iA \
# TODO: keep required packages in sync with slim-base
# required packages to build renovate
        stable.nodejs \
        stable.yarn \
        stable.nodePackages.npm \
        stable.python39 \
        stable.python39Packages.setuptools \
        stable.git \
# nodejs
        # stable.nodejs \ # installed
        # stable.yarn \   # installed
        # stable.nodePackages.npm \ # installed
        unstable.nodePackages.pnpm \
        stable.nodePackages.lerna \
# go
        stable.go \
# docker
        stable.docker-client \
# dotnet
        stable.dotnet-sdk_3 \
# ruby
        stable.ruby_3_0 \
# cocoapods has no arm64 release for now
# nix-env -iA stable.cocoapods
# erlang
        stable.erlangR22 \
        unstable.elixir \
# rust
        stable.cargo \
        stable.rustc \
# python
        # stable.python39 \ # installed
        stable.pipenv \
        stable.poetry \
# missing stable.python39Packages.hashin
        stable.python39Packages.pip-tools \
# php
        stable.php \
        stable.php74Packages.composer \
# java
        stable.jdk11_headless \
        stable.gradle_6 \
# kubernetes
        unstable.kubernetes-helm ;\
# cleanup
    rm /nix/var/nix/gcroots/auto/* || true ;\
    nix-store --gc ;\
# TODO: compare optimise vs non-optimise in container
#       currently disabled due to `Operation not permitted`
    # nix optimise-store ;\
    # nix-store --gc ;\
    nix-store --verify --check-contents
