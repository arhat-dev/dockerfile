ARG SLIM_IMAGE
FROM ${SLIM_IMAGE}

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

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["renovate"]
