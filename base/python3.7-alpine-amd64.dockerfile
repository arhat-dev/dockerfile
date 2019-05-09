FROM arm32v7/python:3.7-alpine3.9

# install build tools
RUN apk --no-cache add ca-certificates wget build-base curl ;\
    pip3 install pipenv ;
