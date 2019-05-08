.PHONY: build-image
build-image:
	docker build -t sample-python:latest -f alpine-armv7.dockerfile .

.PHONY: run-from-image
run-from-image:
	docker run -it sample-python:latest
