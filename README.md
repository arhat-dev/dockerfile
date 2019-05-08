# Dockerfile

[![Build Status](https://travis-ci.com/arhat-dev/dockerfile.svg?branch=master)](https://travis-ci.com/arhat-dev/dockerfile)

Building blocks for [arhat-dev](https://github.com/arhat-dev), suitable for organizations using same project structure.

## Rules

| Language | Toolchain | Built Binary           | App Path | Entrypoint                                                      |
| -------- | --------- | ---------------------- | -------- | --------------------------------------------------------------- |
| `Go`     | `make`    | `/app/build/${TARGET}` | `/app`   | `/app`                                                          |
| `Python` | `pipenv`  | `/app/*`               | `/app/main.py` | [`/usr/local/bin/entrypoint`](./container/python/entrypoint.sh) |

## Usage

__NOTE:__ To use multi-arch build, you may need to run `docker run --rm --privileged multiarch/qemu-user-static:register` first.

- Method 1: build with arbitrary make target

    ```bash
    # set make target and image name
    $ export TARGET="my-app"
    $ export IMAGE_NAME="my-image-name"

    # build in your project root (with `Makefile`)
    $ docker build --build-arg TARGET=$(TARGET) \
        -t $(IMAGE_NAME) \
        -f template/without-target.dockerfile .
    ```

- Method 2: build with predefined make target

    ```bash
    # set image name
    $ export IMAGE_NAME="my-image-name"

    # build in your project root (with `Makefile`)
    $ docker build -t $(IMAGE_NAME) -f template/with-target.dockerfile
    ```
