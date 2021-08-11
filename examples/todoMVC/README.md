# TODOMVC

example from redux TodoMVC

show how to use this nginx image to serve such SPA App.

```sh
docker build --build-arg VERSION=v0.4.0 -t todomvc .
docker run -d -p 8080:80 todomvc
```

visit todo in your browser [http://localhost:8080](http://localhost:8080)
