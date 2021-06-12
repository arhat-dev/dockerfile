ARG ARCH=amd64

FROM ${DOCKER_ARCH}/caddy:2-builder AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare \
    github.com/caddy-dns/digitalocean \
    github.com/caddy-dns/dnspod \
    github.com/caddy-dns/route53 \
    github.com/caddy-dns/gandi

FROM caddy:2

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
