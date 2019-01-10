FROM elixir:1.6.5-alpine

ENV PACKAGES="\
build-base \
ca-certificates \
inotify-tools \
jemalloc \
nodejs \
tini \
"

RUN apk update && \
    apk upgrade && \
    apk add --no-cache $PACKAGES || \
      (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --no-cache $PACKAGES) && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

ADD . /app

WORKDIR /app

ENV MIX_ENV=prod

RUN npm install && \
    brunch build --production

RUN rm -Rf _build && \
    mix deps.get --only prod && \
    mix compile && \
    mix phx.digest && \
    mix release
