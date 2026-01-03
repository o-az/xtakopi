[takopi](https://github.com/banteg/takopi) instance for my self

running locally

1. populate `.env` and add your keys

```sh
cp .env.example .env
```

2. build docker image

```sh
docker buildx build \
    --tag mytakopi \
    --file Dockerfile . \
    --no-cache --progress=plain
```

3. then run the image

```sh
docker run --rm  -it --env-file .env mytakopi
```

deploying to railway

```sh
bun railway login

# create a new project
bun railway init --name='mytakopi'

# add a service to the project
# this is where docker image will run
bun railway add --service='mytakopi'

# add your environment variables to the service
bun railway variables \
    --service='mytakopi' \
    --skip-deploys \
    --set 'TELEGRAM_CHAT_ID=...' \
    --set 'TELEGRAM_BOT_TOKEN=...' \
    --set 'OPENAI_API_KEY=...' \
    --set 'ANTHROPIC_API_KEY=...'
    # ...

# deploy the service
export RAILWAY_DOCKERFILE='./Dockerfile'
bun railway up \
    --service='mytakopi' \
    --environment='production' \
    --detach # optional
```
