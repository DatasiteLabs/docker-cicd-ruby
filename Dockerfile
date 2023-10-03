FROM --platform=$BUILDPLATFORM ruby:2.7-alpine
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETARCH
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM with $TARGETARCH"
LABEL version="0.0.1" maintainer="Kayla Altepeter"
# ENV GH_CLI_VERSION 2.27.0
ENV NODE_VERSION 18.9.1-r0
ENV PYTHON_VERSION ~3.10

# FROM node:18-alpine3.16 AS node
# COPY --from=node /usr/lib /usr/lib
# COPY --from=node /usr/local/share /usr/local/share
# COPY --from=node /usr/local/lib /usr/local/lib
# COPY --from=node /usr/local/include /usr/local/include
# COPY --from=node /usr/local/bin /usr/local/bin

RUN apk update --no-cache

RUN apk add --update --no-cache \
    # rails deps
    pkgconfig \
    libxslt-dev \
    libxml2-dev \
    libffi \
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
    openssl \
    file \
    imagemagick \
    github-cli

# RUN apk add --no-cache mkcert --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=${TARGETPLATFORM}" \
    && chmod +x mkcert-v*-linux-* \
    && cp mkcert-v*-linux-* /usr/local/bin/mkcert

RUN apk add --update --no-cache nodejs-current=${NODE_VERSION} npm \
    && npm install --global yarn

RUN apk add --update --no-cache python3=${PYTHON_VERSION} && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip

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
