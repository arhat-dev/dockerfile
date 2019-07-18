FROM arhatdev/builder-go:stretch as builder
FROM scratch

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /app

# set OCI default command
ENTRYPOINT [ "/app/" ]
