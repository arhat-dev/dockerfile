FROM arhatdev/builder-go:onbuild as builder
FROM alpine:3.9

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /app

# set OCI default command
ENTRYPOINT [ "/app" ]
