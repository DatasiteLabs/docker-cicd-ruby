#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace
readonly __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOCKER_REPO=${1:-0.0.0.0:5001}
LOCAL_NAME=${DOCKER_REPO}/datasite/test-cicd-ruby

echo "Building ${LOCAL_NAME}"

docker buildx build --builder=container --platform=linux/amd64,linux/arm64 --push --no-cache --pull -t "${LOCAL_NAME}:latest-ruby" "${__dir}"
docker buildx build --builder=container --platform=linux/amd64,linux/arm64 --push --build-arg=DOCKER_REPO=${DOCKER_REPO} -t "${LOCAL_NAME}:test-cicd-ruby-consumer" "${__dir}/test-app"
