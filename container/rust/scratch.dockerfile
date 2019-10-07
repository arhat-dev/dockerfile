FROM arhatdev/builder-rust:debian as builder
FROM scratch

ONBUILD ARG TARGET
ONBUILD ARG APP=${TARGET}
ONBUILD COPY --from=builder /app/build/${TARGET} /${APP}
