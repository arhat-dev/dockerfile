FROM arhatdev/builder-go:debian as builder
FROM scratch

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /app

ENTRYPOINT [ "/app" ]
