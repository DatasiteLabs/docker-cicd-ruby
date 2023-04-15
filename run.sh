#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace

LOCAL_NAME=datasite/test-cicd-ruby
echo "Running ${LOCAL_NAME}"

docker run -it --user ruby -v $(pwd):/usr/src -w /usr/src -p 3000:3000 "${LOCAL_NAME}:latest-ruby" bash
