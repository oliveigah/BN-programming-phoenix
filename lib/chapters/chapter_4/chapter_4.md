# 4 - Ecto and Chagesets

## 4.1 - Understanding Ecto

- Ecto is a framework to deal with relational databases in elixir
- It has some abstractions that enable developers to build complex queries with functions that encapsulate SQL
- One of the main features of Ecto is `changesets`
- `changesets` holds all the process of change a database record and apply it on the database it self
- The initial setup of a database can be automatically done by running `mix ecto.create`

## 4.2 - Schema and Migration

### 4.2.1 - Schema

- Ecto's schemas enable you to tie both, system's data representation and database data representation in a single structure
- This is done by the `schema` macro that is built with pure elixir

```elixir
defmodule ProgrammingPhoenix.Accounts.User do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :username, :string
    timestamps()
  end
end
```

- By default the schema generate a primary key `:id` automatically

### 4.2.2 - Migration

- Migrations are files that makes changes to your database
- Migrations can be created using the `mix ecto.gen.migration ${migration_name}` command
- It generates a file with a special timestamp to ensure order among all migrations
- These files can now be executed to commit these changes on the database
- `Ecto.Migration` API has severeal functions to interact with such changes (create, remove, change, etc)
- The benefits of couple and automate code and database versioning are:
  - Less synchronization required
  - Easiers rollbacks
  - Build a fresh development environment is easy
- To run the migrations you use `mix ecto.migrate`

## 4.3 - Using Ecto.Repo

- Ecto runs a supervision tree providing multiple services to interact with a database, so you must start it on your application
- `Ecto.Repo` contains several abstractions out of the box for commom SQL tasks
- These abstractions helps to keep persistance code well defined behind Ecto's API

## 4.4 - Building Forms

- The `Ecto.Changeset` module inject on your context some useful functions to work with forms
- `Changeset` is an Ecto structure capable of manage record changes, casts and validations
- Usually the changeset lives inside the the model, this implies that not every business logic must live insided the context functions, although the context API is the only way to communicate with the bussiness logic, the logic it self may be spread among multiple modules which way is more suitable for the problem at hand

### 4.4.1 - Why Changesets

- Different from others persistance frameworks Ecto do not define constraints and validations directly on the schema (only database validantions)
- The problem with one size fits all validations is there you have a single update mechanism but multiple update policies
- By decouple the upate from the schema that is being updated, Ecto enable you to easily manage this task
- Changesets encapsulates every database change inside it structure

## 4.5 - Resources Routes

```elixir
  scope "/", ProgrammingPhoenixWeb do
    pipe_through :browser

    resources "/users", UserController, only: [:index, :show, :new, :create]
  end
```

- Resources is a macro that automatically implements a commom set of actions (CRUD)
- Resources relly on HTTP versb such as GET, POST, PUT, etc
- Resources are more than a keystroke saver, they also enforce convention by code
- Since with the usage of resources your router do not provide a clear view of all system's routes you can run `mix phx.routes` to see them

## 4.6 - Form Templates

```elixir
<h1> New User </h1>

<%= form_for @changeset, Routes.user_path(@conn, :create), fn f -> %>
  <div>
    <%= text_input f, :name, placeholder: "Name" %>
  </div>
  <div>
    <%= text_input f, :username, placeholder: "Username" %>
  </div>
<%= submit "Create User" %>

<% end %>
```

- `form_for` macro is a helper function that enable build templates with forms
- It expects to receive 3 arguments:
  1 - A module that implements the `Phoenix.HTML.FormData` protocol
  2 - A path to the submit action
  3 - An anonymous functions that receives the form data it self as parameter
- The anonymous function is responsible for the render it self
- Beyond the less type convenience, the `form_for` macro provides other useful features such as security (\_csrf_token)

- Forms can read data from the first parameter to update the user each time:

```elixir
<h1> New User </h1>

<%= if @changeset.action do%>
  <div class="alert alert-danger">
    <p> Oops, something went wrong! Please check de errors below. </p>
  </div>
<% end %>

<%= form_for @changeset, Routes.user_path(@conn, :create), fn f -> %>
  <div>
    <%= text_input f, :name, placeholder: "Name" %>
    <%= error_tag f, :name %>
  </div>
  <div>
    <%= text_input f, :username, placeholder: "Username" %>
     <%= error_tag f, :username %>
  </div>
<%= submit "Create User" %>

<% end %>
```
