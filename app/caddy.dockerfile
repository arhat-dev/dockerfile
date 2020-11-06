ARG ARCH=amd64

FROM ${DOCKER_ARCH}/caddy:2.1.1-builder AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare \
    github.com/caddy-dns/digitalocean \
    github.com/caddy-dns/dnspod \
    github.com/caddy-dns/route53 \
    github.com/caddy-dns/gandi

FROM caddy:2.1.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
