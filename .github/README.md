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
bun railway init
bun railway deploy
```
