FROM python:3.7-alpine3.13

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# install build tools
RUN apk --no-cache add ca-certificates wget build-base curl ;\
    pip3 install pipenv ;
