FROM arhatdev/builder-go-stretch:onbuild as builder
FROM scratch

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /app

# set OCI default command
ENTRYPOINT [ "/app/" ]
