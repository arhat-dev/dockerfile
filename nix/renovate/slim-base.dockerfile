ARG NIX_IMAGE

FROM ${NIX_IMAGE}

ENV PATH="/nixuser/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

RUN set -ex ;\
    nix-env -iA \
# TODO: keep required packages in sync with full-base
# required packages to build renovate
        stable.nodejs \
        stable.yarn \
        stable.nodePackages.npm \
        stable.python39 \
        stable.python39Packages.setuptools \
        stable.git ;\
# cleanup
    rm /nix/var/nix/gcroots/auto/* || true ;\
    nix-store --gc ;\
# TODO: compare optimise vs non-optimise in container
#       currently disabled due to `Operation not permitted`
    # nix optimise-store ;\
    # nix-store --gc ;\
    nix-store --verify --check-contents
