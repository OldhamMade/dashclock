#FROM resin/rpi-raspbian:jessie
FROM thewtex/cross-compiler-linux-armv6

RUN mkdir /code
WORKDIR /code

RUN curl -L http://packages.erlang-solutions.com/debian/erlang_solutions.asc > erlang_solutions.asc
RUN apt-key add erlang_solutions.asc

RUN echo "deb http://packages.erlang-solutions.com/debian jessie contrib" >> /etc/apt/sources.list
RUN apt-get update -y

RUN apt-get install -y erlang-base erlang-dev erlang-crypto erlang-parsetools erlang-ssh erlang-ssl elixir

RUN mix local.hex --force

COPY . /code
