FROM python:3.8-alpine3.12

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# install build tools
RUN apk --no-cache add ca-certificates wget build-base curl ;\
    pip3 install pipenv ;
