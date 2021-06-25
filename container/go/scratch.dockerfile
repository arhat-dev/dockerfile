ARG PLATFORM_ARCH=amd64

FROM --platform=linux/${PLATFORM_ARCH} ghcr.io/arhat-dev/builder-go:debian as builder
FROM --platform=linux/${PLATFORM_ARCH} scratch

ONBUILD ARG TARGET
ONBUILD ARG APP=${TARGET}
ONBUILD COPY --from=builder /app/build/${TARGET} /${APP}
