# nginx-react

A docker base image for a Single Page App (eg. React), within nginx server,
clear url, push state friendly by default.

Use the minimalist Nginx image based on Alpine linux (~6 MB).


## Quick start

There are two ways to kick off:

### 1. Start the default container

Link your app with this volume `-v /your/webapp:/app`.

```sh
docker run -d --name myapp -p 3000:80 -v /your/webapp:/app 36node/nginx-react
```

### 2. Dockfile

**Strongly suggest you follow this way**

```sh
FROM 36node/nginx-react:latest

ENV DEBUG=off \
    ENV_PREFIX=APP_ \
    NODE_ENV=production

## Suppose your app is in the dist directory.
COPY ./dist /app
```

Then just publish your images, and run the container from it.

```sh
docker run -d -p 80:80 your_image
```

Take a look at todoMVC examples for more details.


## Runtime env

This is an useful feature.

Some times we will need to start App with different env, here comes the runtime env.
Just set some environments when you start your container.

Then we can use it via:

```
window?._runtime_?.APP_GREETINGS
```

Try to build the examples/todoMVC image, and run it with some env.

```sh
docker run -e APP_GREETINGS="XXXXXX" -d -p 3000:80 todomvc
```

If you don't want to expose all env, just put ENV_PREFIX=APP, then only environments that start with APP will be injected in.

## Environments

This image has following preset env.

* BUILD: Image build time.
* DEBUG: Debug envrionment.
* ENV_PREFIX: All env start with this prefix will be used for subst. See [Runtime env](#runtime-env) section.
* APP_VERSION: App version.
* APP_WORKDIR: the root direactory of your app running in the docker container,
  usally you do not need to change it.
* APP_BASENAME: some times you would want to put several sites under one
  domain, then sub path prefix is required.
* API_GATEWAY & API_PLACEHOLDER: An api call start with a specific path, then the container
  will proxy the request to API_GATEWAY. 
* CLIENT_BODY_TIMEOUT: body timeout.
* CLIENT_HEADER_TIMEOUT: header timeout.
* CLIENT_MAX_BODY_SIZE: maximum request body size.
* WHITE_LIST: on or off, turn on white_list feature if on, default off.
* WHITE_LIST_IP: ip you wang put through, set it as `(172.17.0.1)|(192.168.0.25)`.

### API_PLACEHOLDER && API_GATEWAY

**note:** we suggest you call api with a full url with domain, make your api
server independently. But we need to take care of cross domain and https issues.

If your app calls api without domain, and not deploy behind a **Well
Structured** haproxy(or other forward proxy), you can turn on this option.

```sh
API_PLACEHOLDER="/api/v1"
API_GATEWAY="http://api.your.domain"
```

Then all url match `/api/v1` will redirect to `http://api.your.domain`. Please
notice that the `/api/v1` will be stripped.

In case you need more gateway, you can use another 5 entries API_GATEWAY_1 ~ API_GATEWAY_5, along with API_PLACEHOLDER_1 ~ API_PLACEHOLDER_5.

### APP_BASENAME

Suppose you have a domain

```sh
www.books.com
```

You have two apps Computer and Math, want put them under the same domain.

```sh
http://www.books.com/computer
http://www.books.com/math
```

For App computer, setting

```sh
APP_BASENAME=/computer
```

You also need to take care about this path prefix in your APP. Like react
router(3.x), it could take a prefix option. We strongly suggest to use the same
envrionment in your source code. So this image will take care of it for you. For
example, in your router.js file:

```js
import useBasename from "history/lib/useBasename";
import { browserHistory } from "react-router";

export const myHistory = useBasename(() => browserHistory)({
  basename: `/${APP_BASENAME}`
});
```

### WHITE_LIST && WHITE_LIST_IP

Turn on white list mode by setting env WHITE_LIST="on", then only allow users from ${WHITE_LIST_IP} list to visit this Web App.


## License

[MIT](LICENSE.txt)
