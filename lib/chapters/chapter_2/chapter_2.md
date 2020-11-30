# 2 - First Steps

- The philosopy behind phoenix is that every web server can be abstracted to a function. The browser sends a function call to a remote server that takes de request and generate some response. Therefore web server is a natural problem to be solved by a functional language.

## 2.1 - Simple Functions

- The elixir's pipe syntax is widely used in phoenix, the benefits of pipes are many, from readability to composibility, pipes helps write elegant and expressive code
- The entry data to the phoenix pipe is a struct called `connection` that is literally all the universe of things you need to generate your response
- Each layer of phoenix makes transformations over this `connection` passing it through the whole pipe, at the end of the pipe the `connection` must contains the server's response to client
- All these premises establishes the basic structure of every phoenix layer, a series of piped functions passing the `connection` over and over
- The basic layers of phoenix are:

```elixir
connection
|> endpoint()   # The first point of contact of phoenix
|> router()     # Redirect the request to the proper controller
|> pipelines()  # Custom series of transformations that can be related to specific connection's properties
|> controller() # Execute the proper business logic
```

- Inside the controller the function that execute the proper business logic is commomly called `action`, so each contoller must execute an `action`
- All related business logic must be encapsulated in modules called `contexts`, so each `action` lives inside a `context`

## 2.2 - Setup

- To run the default phoenix implementation you must have: Erlang, Elixir, PostgreSQL, Node.js, inotiffy(linux only)
- Phoenix can be installed using the mix tool from hex `mix archive.install hex phx_new`
- After all things set, the commom path to init a phoenix app is:
  - `mix phx.new project_name` to create the projects base structure
  - `npm install` inside the assets folder
  - `mix ecto.create` to create the project database
  - `mix phx.server` to run the server

## 2.3 - Building Features

### 2.3.1 - Router

- The match between a route and a cotroller function is done inside the routing layer that is defined by default on `lib/#{project}_web/router.ex`

```elixir
# Routing layer sample
  scope "/", ProgrammingPhoenixWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/hello/:name", HelloController, :world
  end
```

- `scope` defines a base path to match
- `pipe_through` make some housekepping commom to all requests of the same type, in this sample this type is `:browser`
- `get` will handle get requests that matches /hello/:name and forward them to the `:world` action inside `HelloController` controller

### 2.3.2 - Controller

- All controllers in phoenix are inside `lib/#{project}_web/controller`

```elixir
# Controller sample
defmodule ProgrammingPhoenixWeb.HelloController do
  use ProgrammingPhoenixWeb, :controller

  def world(conn, %{"name" => name}) do
    render(conn, "world.html", name: name)
  end
end
```

- Controller usually `use` the `#{project}Web` module passing the `:controller` atom as option, this will inject code inside the module and enable the usage of the phoenix controller API
- Functions inside the controller that are used by the router are called actions

### 2.3.3 - View

- Usually views are inside `lib/#{project}_web/views/#{view_name}.ex`

```elixir
# View sample
defmodule ProgrammingPhoenixWeb.HelloView do
  use ProgrammingPhoenixWeb, :view
end
```

- This sample doesnt do much, but it injects some functions to enable a template rendering
- Here we are relying on the defaults, but we can override them anytime

### 2.3.4 - Template

- Templates are usually defined inside `lib/#{project}_web/templates/#{controller}/#{action}.html.eex`

```html
<h1>From Template: Hello <%= String.capitalize(@name)%></h1>
```

- Templates are htmls that will be converted to a function and phoenix will use to render the page
- Besides the normal html behaviour you can inject elixir code inside it by using `<%= CODE %>` the code will be evaluated and will be replaced inside the html
- The variables that are visible inside the template must be passed by the controller when it calls the function `render`

## 2.4 - Request Pipeline

- Phoenix is all about pipe small functions that transforms the `connection`, using the `Plug` library to achieve it
- These small functions are very explicity in what they do and you can check it by seing its code
- You can even create your's small functions and pipe the `connection` through it making your custom changes, actually this is the standard way to develop with phoenix
- Your's custom functions have the same behaviour than the phoenix ones, takes a `connection` modify and return it

### 2.4.1 - File Structure

- Every phoenix project contains the same structures of a standard mix project
- Beyond the standard mix structure there some others:
  - `/assets` browser files like CSS and JS
  - `/lib/#{project}` core system (supervision trees, processes and bussiness logic)
  - `/lib/#{project}_web` web related code (controllers, views, templates)
- Inside `/config` the file `#{env}.secret.exs` is responsible to load secrets and other values from the env vars that are usually populated by deployment tasks

### 2.4.2 - Endpoints

- An endpoint is the begining of our world that means that is there where the web hands off the request and our application assumes
- The configuration of endpoints is done inside the main config file

```elixir
# Configures the endpoint
config :programming_phoenix, ProgrammingPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lDbQ/NK3POAxMyU1ainArEHFknqfeoQe/P44tK6qY1z3kc1yEzl1gT8ARVDaelgf",
  render_errors: [view: ProgrammingPhoenixWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ProgrammingPhoenix.PubSub,
  live_view: [signing_salt: "wPmMzm1b"]

```

- The code of endpoint's module is inside `/lib/#{project}_web/endpoint.ex`
- The endpoint is basically a pipeline of functions over the `connection` (as always)
- You can check the code there and replace(or add) exactly the function you need by another custom plug
- The last plug in endpoint's code is router
- You can even have multiple endpoints on the same phoenix project, alternatively you can create all of them in separate applications and them unite it under an unbrella project (will see it later)
- Endpoints are responsible for functions that must be executed for every request

### 2.4.3 - Router

- The router is made of two parts:
  - Pipelines: set of functions that must be executed to a specific type of request
  - Route table: select which controller must handle the incoming request
- There are 2 default pipelines inside router `:browser` and `:api`, each one contains a set of functions that makes some common tasks in web application
- Usually the router is the last plug in the endpoint, it's last job is call the controller which will handle the specific bussiness logic for the incoming request

### 2.4.4 - Controllers, Views and Templates

- Controllers are the main module that executes the business logic
- Controllers usaully generates data to be consumed by the view
- View uses the data to fulfill a template
- Templates are HTMLs with injected elixir conde inside it

### 2.4.5 - Other Files

- `/lib/#{project}.ex` defines the top-level interface and documentation for the application
- `/lib/#{project}_web.ex` contains some glue code that defines the base structure of the web-related modules
- `/lib/#{project}_web/channels` will learn later
