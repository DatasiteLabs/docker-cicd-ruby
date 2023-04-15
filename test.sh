#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace
readonly __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOCAL_NAME=datasite/test-cicd-ruby

echo "Running tests against ${LOCAL_NAME}"
# docker run --rm -v "${__dir}/test:/usr/src/test-app" -w /usr/src/test-app --user ruby "${LOCAL_NAME}:latest-ruby" bash -c "ls -la; bundle install; bundle exec rails test"
docker run -it --user ruby test-cicd-ruby-consumer:latest
