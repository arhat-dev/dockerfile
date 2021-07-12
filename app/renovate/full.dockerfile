ARG SLIM_IMAGE
FROM ${SLIM_IMAGE}

ENV PATH="/nixuser/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

# go
RUN set -ex ;\
    nix-env -iA \
        stable.go

# docker
RUN set -ex ;\
    nix-env -iA \
        stable.docker-client

# dotnet
RUN set -ex ;\
    nix-env -iA \
        stable.dotnet-sdk_3

# nodejs
RUN set -ex ;\
    nix-env -iA \
        stable.nodejs \
        stable.yarn \
        stable.nodePackages.npm \
        stable.nodePackages.pnpm \
        stable.nodePackages.lerna

# ruby
RUN set -ex ;\
    nix-env -iA \
        stable.ruby_3_0
# cocoapods has no arm64 release for now
# nix-env -iA stable.cocoapods

# erlang
RUN set -ex ;\
    nix-env -iA \
        stable.erlangR22 \
        unstable.elixir

# rust
RUN set -ex ;\
    nix-env -iA \
        stable.cargo \
        stable.rustc

# python
RUN set -ex ;\
    nix-env -iA \
        stable.python39 \
        stable.pipenv \
        stable.poetry \
        stable.python39Packages.pip-tools
# missing stable.python39Packages.hashin

# php
RUN set -ex ;\
    nix-env -iA \
        stable.php \
        stable.php74Packages.composer

# java
RUN set -ex ;\
    nix-env -iA \
        stable.jdk11_headless \
        stable.gradle_6

# kubernetes
RUN set -ex ;\
    nix-env -iA \
        unstable.kubernetes-helm
