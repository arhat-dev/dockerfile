#!/bin/sh

set -eux

# requires build-arg MAVEN3_VERSION

install_maven3() {
  dest="${1:-"/usr/local/maven"}"

  base_url="https://downloads.apache.org/maven/maven-3/${MAVEN3_VERSION}/binaries"
  tgz_file="apache-maven-${MAVEN3_VERSION}-bin.tar.gz"
  sha512_file="${tgz_file}.sha512"

  curl --retry 10 -S -L -O "${base_url}/${tgz_file}"
  curl --retry 10 -S -L -O "${base_url}/${sha512_file}"

  ls -alh

  echo "$(cat "${sha512_file}")  ${tgz_file}" | sha512sum -c

  mkdir -p "$(dirname "${dest}")"
  tar xf "${tgz_file}" -C /tmp
  mv "/tmp/apache-maven-${MAVEN3_VERSION}" "${dest}"
  rm -f "${tgz_file}" "${sha512_file}"

  chmod -R +x "${dest}/bin"

  export PATH="${dest}/bin:${PATH}"

  mvn -v

  echo "maven installed to ${dest}"
}

install_maven3 /usr/local/maven3
