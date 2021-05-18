# EasyDropbox

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Dev notes

Temporary docker dev env

```
$ docker run --rm -itv $PWD:/app -p 4000:4000 -w /app elixir:alpine sh
```

Run phoenix application

```
# mix phx.server
```

Run tests

```
# mix test
```

## Prod notes

Build the docker image

```
$ docker build -t easy-dropbox .
```

Docker run script with secret env

```sh
docker run --rm -d \
   -p 4000:4000 \
   -e DROPBOX_APP_KEY=xxxxxxxxxxxxxxx \
   -e DROPBOX_APP_SECRET=yyyyyyyyyyyyyyy \
   -e DROPBOX_REFRESHABLE_TOKEN=xxx_yyyyyyyAAAAAAAAAAxxxxxxxxxxxxxxxxxxxx_yyyyyyyyyyyyyyyyyyyyyy \
   easy-dropbox
```

## Dropbox app settings

To create dropbox application and grub key and secret: `https://www.dropbox.com/developers/apps`

To grub a refreshable token:

`https://www.dropbox.com/oauth2/authorize?client_id=<app-key>&redirect_uri=http://localhost:4000/receive-token&response_type=code&token_access_type=offline`

and than

```
curl https://api.dropbox.com/oauth2/token \
  -d code=<AUTHORIZATION_CODE> \
  -d grant_type=authorization_code \
  -d redirect_uri=http://localhost:4000 \
  -u <APP_KEY>:<APP_SECRET>
```
