ARG NIX_IMAGE

FROM ${NIX_IMAGE}

ENV PATH="/nixuser/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

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
        stable.git ;\
# nodejs
        # stable.nodejs \ # installed
        # stable.yarn \   # installed
        # stable.nodePackages.npm \ # installed
        stable.nodePackages.pnpm \
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
        # stable.python39 \ # installed in slim-base
        stable.pipenv \
        stable.poetry \
        stable.python39Packages.pip-tools \
# missing stable.python39Packages.hashin
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
# TODO: compare optimse vs non-optimise in container
    nix optimise-store ;\
    nix-store --gc ;\
    nix-store --verify --check-contents
