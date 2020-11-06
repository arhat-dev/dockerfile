# Dockerfile

[![go](https://github.com/arhat-dev/dockerfile/workflows/go/badge.svg)](https://github.com/arhat-dev/dockerfile/actions?workflow=go)
[![rust](https://github.com/arhat-dev/dockerfile/workflows/rust/badge.svg)](https://github.com/arhat-dev/dockerfile/actions?workflow=rust)
[![python3.6](https://github.com/arhat-dev/dockerfile/workflows/python3.6/badge.svg)](https://github.com/arhat-dev/dockerfile/actions?workflow=python3.6)
[![python3.7](https://github.com/arhat-dev/dockerfile/workflows/python3.7/badge.svg)](https://github.com/arhat-dev/dockerfile/actions?workflow=python3.7)
[![python3.8](https://github.com/arhat-dev/dockerfile/workflows/python3.8/badge.svg)](https://github.com/arhat-dev/dockerfile/actions?workflow=python3.8)
[![python3.9](https://github.com/arhat-dev/dockerfile/workflows/python3.9/badge.svg)](https://github.com/arhat-dev/dockerfile/actions?workflow=python3.9)
[![app](https://github.com/arhat-dev/dockerfile/workflows/app/badge.svg)](https://github.com/arhat-dev/dockerfile/actions?workflow=app)

Building blocks for [arhat-dev](https://github.com/arhat-dev), suitable for organizations using same project structure.

## Rules

| Language | Toolchain | Built Binary           | App Path       | Entrypoint                                                    |
| -------- | --------- | ---------------------- | -------------- | ------------------------------------------------------------- |
| `Go`     | `make`    | `/app/build/${TARGET}` | `/${APP}`      | none                                                          |
| `Rust`   | `make`    | `/app/build/${TARGET}` | `/${APP}`      | none                                                          |
| `Python` | `pipenv`  | `/app/*`               | `/app/main.py` | [`/usr/local/bin/entrypoint`](./scripts/python/entrypoint.sh) |

__Note:__ Both `${TARGET}` and `${APP}` are docker build-args

## Usage

__NOTE:__ To use multi-arch build, you may need to run `docker run --rm --privileged multiarch/qemu-user-static:register` first.

- Method 1: build with arbitrary make target

    ```bash
    # set make target and image name
    $ export TARGET="my-app"
    $ export IMAGE_NAME="my-image-name"

    # build in your project root
    $ docker build --build-arg TARGET=${TARGET} \
        -t ${IMAGE_NAME} \
        -f template/without-target.dockerfile .
    ```

- Method 2: build with predefined make target

    ```bash
    # set image name
    $ export IMAGE_NAME="my-image-name"

    # build in your project root
    $ docker build -t ${IMAGE_NAME} -f template/with-target.dockerfile
    ```

## Conventions

### Variables

- `{language}` is the programming language
  - languages without strong backward compatibilities will be versioned (e.g. `python3.6`, `python3.7`)
- `{rootfs}` will appear in image tagname and makefile targets
  - values can be in one of following formats:
    - `{distro}-{arch}` means the image supports certain platform only
    - `{distro}` means this image supports linux/{amd64,arm64,armv6,armv7}

### Image Types

- Base images (`ghcr.io/arhat-dev/base-{language}:{rootfs}`)
  - contians necessary build tools and environment for cross platform build
- Builder images (`ghcr.io/arhat-dev/builder-{language}:{rootfs}`)
  - based on base images (`ghcr.io/arhat-dev/base-{language}:{rootfs}`) but with build triggers to build project automatically
- Contianer images `ghcr.io/{language}:{rootfs}`
  - copy built application from builders and setup environment for contianer running

### Makefile Targets

- Makefile image target name can be one of the following:
  - `base-{language}:{rootfs}` for base images
  - `builder-{language}:{rootfs}` for builder images
  - `{language}:{rootfs}` for container images
