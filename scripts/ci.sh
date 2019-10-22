#!/bin/bash

install_docker() {
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update
  apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce

  printf '{\n  "experimental": true\n}\n' | sudo tee /etc/docker/daemon.json

  service docker restart || journalctl -xe

  # prepare for multi-arch build with qemu (register archs using qemu)
  docker run --rm --privileged multiarch/qemu-user-static:register
  docker version
}

"$@"
