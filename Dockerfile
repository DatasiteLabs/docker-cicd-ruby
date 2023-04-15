FROM ruby:2.7.7-slim-bullseye
LABEL version="0.0.1" maintainer="Kayla Altepeter"
ENV GH_CLI_VERSION 2.27.0
ENV SQLITE_VERSION 3410200

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    # rails deps
    libxslt-dev \
    libxml2-dev \
    build-essential \
    ruby-dev \
    libpq-dev \
    python2 \
    # node deps
    ca-certificates \
    gnupg \
    dirmngr \
    xz-utils \
    libatomic1 \
    # tools
    vim \
    curl \
    wget \
    iputils-ping \
    telnet \
    iproute2 \
    # clean up
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN wget -qO- https://www.sqlite.org/2023/sqlite-autoconf-${SQLITE_VERSION}.tar.gz | tar xvz \
    && cd sqlite-autoconf-${SQLITE_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && cd .. \
    && rm -r sqlite-autoconf-${SQLITE_VERSION}

# Add github cli
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh=${GH_CLI_VERSION} -y

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && npm install --global yarn

RUN addgroup --gid 1000 --system ruby && \
	adduser --uid 1000 --system ruby --ingroup ruby

# Local certs
RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64" && \
  chmod +x mkcert-v*-linux-amd64 && \
  mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert

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

# install dumb-init
# https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod +x /usr/local/bin/dumb-init

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
