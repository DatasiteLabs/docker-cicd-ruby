# docker-cicd-ruby

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/datasitelabs/docker-cicd-ruby/docker-publish.yml?style=flat-square) ![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/datasitelabs/docker-cicd-ruby?sort=semver&style=flat-square)

A specific Ruby container for building ruby on rails projects. You may want to use an official container unless you have similar needs and tool stacks.

## Toolchain

- GitHub CLI
- Ruby
- Node/NPM/Yarn
- Dumb Init
- Mkcert

## Base container / toolchain info

This container is based off of: <https://hub.docker.com/_/ruby/> and also adds node/yarn support for rails. The node/yarn support is a combination of details from <https://hub.docker.com/_/node>.

List of install resources used:

- <https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt>
- <https://github.com/nodesource/distributions>
- <https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable>
- <https://github.com/FiloSottile/mkcert#linux>
- <https://github.com/Yelp/dumb-init#option-3-installing-the-deb-package-manually-debianubuntu>
- <https://www.tutorialspoint.com/sqlite/sqlite_installation.htm>

## Generating the test rails app

`test-app` is a basic generated rails app to validate the container and dependencies.

`gem install rails -v '5.1.4'` # version is specific to a version test for the ruby version. You should be able to run others if the ruby version is supported.

`rails new test-app` generate a test app
`rails scaffold hello` generate a full resource and migrations
`rails db:migrate RAILS_ENV=test` migrate db

```bash
cd test-app
bundle exec rails test
```

## Running the test app

```bash
./run.sh

cd test-app
rails db:migrate RAILS_ENV=development
rails s -b 0.0.0.0
```

Navigate to http://localhost:3000/hellos
