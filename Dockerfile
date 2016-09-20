FROM trenpixster/elixir

ENV VERSION 0.1.0

RUN mkdir /app
WORKDIR /app
# COPY ./rel/dashclock/releases/$VERSION/dashclock.tar.gz /app/dashclock.tar.gz
# RUN tar -zxvf dashclock.tar.gz

# COPY . /app

RUN git clone https://github.com/OldhamMade/dashclock.git .
RUN git pull
RUN mix deps.get deps.compile
RUN MIX_ENV=prod mix release --env=prod

# WORKDIR /app/releases/$VERSION
# ENTRYPOINT ["./dashclock.sh"]

ENTRYPOINT ["/app/rel/dashclock/bin/dashclock"]
CMD ["foreground"]
