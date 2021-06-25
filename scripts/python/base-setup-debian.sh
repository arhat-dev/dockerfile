#!/bin/sh

set -ex

apt-get update
apt-get install -y wget build-essential curl
pip3 install pipenv
