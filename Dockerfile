FROM --platform=$BUILDPLATFORM ruby:2.7-alpine
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"
LABEL version="0.0.1" maintainer="Kayla Altepeter"
ENV GH_CLI_VERSION 2.27.0
ENV SQLITE_VERSION 3410200

# FROM node:18-alpine3.16 AS node
# COPY --from=node /usr/lib /usr/lib
# COPY --from=node /usr/local/share /usr/local/share
# COPY --from=node /usr/local/lib /usr/local/lib
# COPY --from=node /usr/local/include /usr/local/include
# COPY --from=node /usr/local/bin /usr/local/bin

RUN apk add --update --no-cache mkcert --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk add --update --no-cache github-cli --repository=https://alpine.pkgs.org/3.17/alpine-community-aarch64/

RUN apk add --update --no-cache \
    # rails deps
    pkgconfig \
    libxslt-dev \
    libxml2-dev \
    build-base \
    ruby-dev \
    libpq-dev \
    python3 \
    postgresql-dev \
    tzdata \
    # node deps
    ca-certificates \
    gnupg \
    dirmngr \
    xz \
    g++ \
    gcc \
    libgcc \
    linux-headers \
    make \
    sqlite \
    sqlite-libs \
    sqlite-dev \
    # tools
    git \
    vim \
    curl \
    wget \
    iputils \
    busybox-extras \
    iproute2 \
    zip \
    unzip \
    tar \
    dumb-init \
    bash \
    openrc \
    openssl

RUN apk add --update --no-cache nodejs=18.16.0-r1 --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
    && apk add --update --no-cache npm \
    && npm install --global yarn

RUN addgroup --gid 1000 --system ruby && \
	adduser --uid 1000 --system ruby --ingroup ruby

RUN mkcert -install && \
    mkcert example.com "*.example.com" example.test localhost 127.0.0.1 ::1 && \
    mkdir -p /home/ruby/certs && \
    mv *.pem /home/ruby/certs/ && \
    chown -R ruby:ruby /home/ruby/certs

# a few environment variables to make NPM installs easier
# good colors for most applications
ENV TERM xterm
# avoid million NPM install messages
ENV npm_config_loglevel warn
# allow installing when the main user is root
ENV npm_config_unsafe_perm true

# Node libraries
RUN node -p process.versions

# Show where Node loads required modules from
RUN node -p 'module.paths'

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
    "npm version:     $(npm -v) \n" \
    "yarn version:    $(yarn -v) \n" \
    "ruby version:    $(ruby --version) \n" \
    "sqlite3 version:    $(sqlite3 --version) \n" \
    "debian version:  $(cat /etc/debian_version) \n" \
    "user:            $(whoami) \n"

USER ruby
VOLUME /home/ruby
EXPOSE 3000
ENTRYPOINT ["dumb-init", "--"]
CMD ["ruby --version"]
