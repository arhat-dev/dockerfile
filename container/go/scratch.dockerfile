FROM arhatdev/builder-go:debian as builder
FROM scratch

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /${TARGET}
ONBUILD ENTRYPOINT [ "/${TARGET}" ]
