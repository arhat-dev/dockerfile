FROM arhatdev/builder-go:debian-latest as builder
FROM scratch

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /app

ENTRYPOINT [ "/app" ]
