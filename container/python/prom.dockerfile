FROM python:3.7-alpine3.9

RUN pip install prometheus_client

ENTRYPOINT [ "/usr/local/bin/python3" ]
