FROM alpine:latest AS downloader

ARG ARCH=amd64

COPY scripts/download.sh /download
RUN set -ex ;\
    apk add --no-cache unzip ;\
    /download frp ${ARCH} ;

FROM scratch

COPY --from=downloader /frp/frps /frps
COPY --from=downloader /frp/frpc /frpc

ENTRYPOINT [ "/frps" ]
