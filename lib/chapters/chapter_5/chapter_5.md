# 5 - Authentication

## 5.1 - Managing Changesets

```elixir
defmodule ProgrammingPhoenix.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  def base_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end

  def registration_changeset(user, attrs) do
    user
    |> base_changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
```

- You can use the option `virtual: true` on the schema to indentify a field that will be present on the struct only, not in the databasee
- Changesets are highly composable, in this sense they are similar as plugs, multiple functions that modify the changeset
- Since changesets implements the `form_for` protocol they are useful for both, manage forms and manage database
- The changes inside the changeset are commited only when `Repo.Insert` is called, usually inside the context

## 5.2 - Anatomy of Plug

- There are 2 kinds of plugs: Modules and functions
- In both cases, at the end of the day they are just functions that modify the `Plug.Conn`, the module plug is useful to provide a set of initial configurations to the plug, and reuse it on multiple modules
- Module plugs must implement 2 functions `init/1` and `call/2`
- The main work happens on `call` and the configuration stuff on `init` the result of `init` is forward to `call` as its second parameter, and may moodify the plug behaviour
- `init` is called at runtime while in development mode, on production it is called only once during compile time, this is why it is the perfect place to do the heavy lifting stuff without slow every request
- Plugs are just elixir macros, for instance something like this:

```elixir
plug :one
plug Two
plug :three, some: :option
```

after expansion will be:

```elixir
case one(conn, []) do
  %Plug.Conn{halted: true} = conn -> conn
  conn ->
    case Two.call(conn, Two.init([])) do
      %Plug.Conn{halted: true} = conn -> conn
      conn ->
        case three(conn, some: :option) do
          %Plug.Conn{halted: true} = conn -> conn
          conn -> conn
        end
    end
end
```

### 5.2.1 - Conn Fields

- `Conn` has a great online documentation where you can find every field in very detailed manner
- `Conn` contains all the web-related data that web application need to produce a proper response
- There are some types of fields that live inside the `Conn`
- Request fields contains information about the incoming request such as host, method, path, headers. These fields are gathered and parsed by `Cowboy` webserver which is a lib used by phoenix
- Fetchable fields are a bit more expensive to get so they are empty until explicity requested, some examaples are cookies, params
- Process fields, are fields that are used to process the web request and keep some information about it. Some examples are assigns, halted
- Response fields must contain all the data needed for deliver the proper responser to the client such as resp_body, resp_cookies, resp_headers, status
- Private fields contains data about adapaters and used frameworks, this is useful if you want to change the default behaviour of phoenix
- `Conn` starts almost blank and is filled out along the plug pipeline
- `Conn` contains several useful functions that abstract this complex work to deal with these fields, such as manage cookies or send files

## 5.3 - Custom Plug

```elixir
defmodule ProgrammingPhoenixWeb.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && ProgrammingPhoenix.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end
end
```

- You can write custom plugs that modify any of the conn fields and attach them to any of the pipelines
- Usually if you want to add a custom data to conn you use the `assigns` field
- Data inside `conn.assigns` is visible by controllers and views, since both have access to the conn
- Like endpoints and routers, controllers also have their own plug pipeline, so you can plug directly on them

```elixir
  plug :authenticate when action in [:index, :show]
  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
```
