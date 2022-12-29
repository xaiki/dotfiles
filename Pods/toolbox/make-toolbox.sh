#!/bin/sh

set -x
set -e

podman build -t $1-toolbox -f Dockerfile.$1
toolbox create -i localhost/$1-toolbox:latest
