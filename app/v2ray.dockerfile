FROM alpine:latest AS downloader

ARG ARCH=amd64

COPY scripts/download.sh /download
RUN set -ex ;\
    apk add --no-cache unzip ;\
    /download v2ray ${ARCH} ;

FROM scratch

COPY --from=downloader /v2ray/v2ray /v2ray
COPY --from=downloader /v2ray/v2ctl /v2ctl

ENTRYPOINT [ "/v2ray" ]
