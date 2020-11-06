# must have, will be invoked by docker image (`ghcr.io/arhat-dev/builder-go:debian`)
my-app:
	go build -o build/my-app ./

build-image-with-target:
	docker build -f with-target.dockerfile -t sample-go:latest .

build-image-without-target:
	docker build --build-arg TARGET=my-app \
		-f without-target.dockerfile -t sample-go:latest .
