FROM 36node/nginx-react:latest

ARG VERSION

ENV APP_VERSION=${VERSION} \
  APP_GREETINGS="Hello World"

## Suppose your app is in the dist directory.
COPY ./dist /app
