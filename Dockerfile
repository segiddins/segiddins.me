FROM ruby:2.4.10-alpine

RUN \
  --mount=type=cache,id=dev-apk-cache,sharing=locked,target=/var/cache/apk \
  --mount=type=cache,id=dev-apk-lib,sharing=locked,target=/var/lib/apk \
  apk add \
  ca-certificates \
  build-base \
  bash \
  zstd-libs \
  linux-headers \
  zlib-dev \
  git \
  nodejs \
  tzdata

RUN gem update --system "3.3.26"
ENV BUNDLER_VERSION=2.3.26

RUN mkdir -p /site

WORKDIR /site

# Install application gems
COPY Gemfile* /site/
RUN --mount=type=cache,id=bld-gem-cache,sharing=locked,target=/srv/vendor \
  bundle config set --local without 'development test' && \
  bundle config set --local path /srv/vendor && \
  bundle install --jobs 20 --retry 5 && \
  # bundle exec bootsnap precompile --gemfile && \
  bundle clean && \
  mkdir -p vendor && \
  bundle config set --local path vendor && \
  cp -ar /srv/vendor . && \
  rm -fr /site/vendor/ruby/*/cache


COPY . /site/

RUN rake bootstrap
ENTRYPOINT ["bundle", "exec"]
CMD ["rake", "deploy"]
