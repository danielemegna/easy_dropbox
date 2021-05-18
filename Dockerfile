FROM elixir:alpine AS builder

COPY . /app/
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN MIX_ENV=prod mix release

FROM elixir:alpine as runner

COPY --from=builder /app/_build/prod/rel/easy_dropbox /app
WORKDIR /app

CMD ["./bin/easy_dropbox", "start"]
