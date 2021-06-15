FROM frolvlad/alpine-glibc:alpine-3.13 AS builder

ARG VERSION="v1.8.3"

ENV GO111MODULE=on

# Install dependencies
RUN apk add libsecret-dev git make grep bash go

ARG GO_VERSION="1.16.5"

ENV GOPATH="/go"
ENV GO_BIN="${GOPATH}/bin/go${GO_VERSION}"

RUN go get "golang.org/dl/go${GO_VERSION}" ;\
    "${GO_BIN}" download ;\
    mv "${GO_BIN}" "$(which go)"

WORKDIR /opt
RUN set -ex ;\
    git clone --branch "${VERSION}" https://github.com/ProtonMail/proton-bridge.git ;\
    BUILD_TAGS='netgo' make -C proton-bridge build-nogui

FROM frolvlad/alpine-glibc:alpine-3.13

LABEL maintainer="Xiaonan Shen <s@sxn.dev>"

# # Install dependencies and protonmail bridge
RUN apk add --no-cache expect socat pass libsecret ca-certificates libnotify coreutils

# Copy proton-bridge
COPY --from=builder /opt/proton-bridge/proton-bridge /usr/local/bin/

# Copy scripts
COPY entrypoint.sh login.exp /usr/local/bin/
COPY gpgparams /opt/
RUN chmod +x /usr/local/bin/login.exp /usr/local/bin/entrypoint.sh

# SMTP STARTTLS
EXPOSE 9587/tcp

# IMAP STARTTLS
EXPOSE 9143/tcp

RUN addgroup -g 1000 proton-bridge ;\
    adduser -h /home/proton -s $(which nologin) -S -D -u 1000 proton-bridge ;\
    mkdir -p /data ;\
    chown -R proton-bridge:proton-bridge /data

USER 1000

VOLUME [ "/data" ]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["start"]
