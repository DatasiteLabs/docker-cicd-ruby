FROM datasite/test-cicd-ruby:latest-ruby

RUN echo "current user: $(whoami)" && \
    echo "current ruby: $(ruby -v)" && \
    echo "current rails:  $(rails -v)" && \
    echo "current node:  $(node -v)" && \
    echo "current yarn:  $(yarn -v)"


COPY --chown=ruby ./ /usr/src/test-app
WORKDIR /usr/src/test-app

ENTRYPOINT [ "bash", "-c", "bundle install; rails db:migrate RAILS_ENV=test; bundle exec rails test" ]
