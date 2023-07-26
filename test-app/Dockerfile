ARG DOCKER_REPO
FROM --platform=$BUILDPLATFORM ${DOCKER_REPO}/datasite/test-cicd-ruby:latest-ruby

COPY --chown=ruby ./ /usr/src/test-app
WORKDIR /usr/src/test-app

RUN echo "current user: $(whoami)" && \
    echo "current ruby: $(ruby -v)" && \
    echo "current node:  $(node -v)" && \
    echo "current yarn:  $(yarn -v)"

ENTRYPOINT [ "bash", "-c", "bundle install; rails db:migrate RAILS_ENV=test; bundle exec rails test" ]
