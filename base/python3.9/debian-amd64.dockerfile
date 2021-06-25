FROM --platform=linux/amd64 python:3.9

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# install build tools
RUN apt-get update ;\
    apt-get install -y wget build-essential curl ;\
    pip3 install pipenv ;
