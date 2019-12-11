ARG ARCH=amd64

# FROM arhatdev/conftest:${ARCH} AS conftest
FROM arhatdev/kubeval:${ARCH} AS kubeval

FROM alpine:latest AS builder

ARG ARCH=amd64
COPY scripts/download.sh /download
RUN set -ex ;\
    /download helm ${ARCH} ;\
    /download qemu ${ARCH} ;\
    /download kubectl ${ARCH} ;\
    mkdir -p /app/build/ ;\
    mv /helm/helm /app/build/helm-linux-${ARCH}

FROM arhatdev/go:debian-${ARCH}

# COPY --from=conftest /conftest /usr/bin/conftest
COPY --from=kubeval /kubeval /usr/bin/kubeval
COPY --from=builder /kubectl/kubectl /usr/bin/kubectl
COPY --from=builder /qemu* /usr/bin/

RUN apk add --no-cache git ;\
    ln -s /helm /usr/bin/helm ;\
    # helm plugin install https://github.com/instrumenta/helm-conftest ;\
    helm plugin install https://github.com/instrumenta/helm-kubeval ;

ENTRYPOINT [ "/helm" ]
