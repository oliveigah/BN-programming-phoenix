# 6 - Generators and Relationships

## 6.1 - Generating Web Interfaces

- Phoenix have 2 mix tasks to scaffold traditional CRUD web interfaces `phx.gen.json` to build REST-based JSON apis and `phx.gen.html` that generates HTML pages as well
- Generators are great tools to setup a project quickly
- Generators also help keep the code organaization with standardized names
- When thiking about code organization always think context first
- Phoenix generators have a good set of configuration options to deal with, checkout documentation
- Multipel scopes can be defined on the router to leverage the `pipe_through` macro
- You can rollback migrations using the command `mix ecto.rollback`

## 6.2 - Building Relationships

- To define a relationship on the schema level you must use the `belongs_to` macro
- Fields that are not directly user input do not need to be castable nor required on changesets
- Ecto's associations are explicit, so to fetch an associated field tou must run `Repo.preload/2` before
- The associated data is retrieved as a normal elixir struct that correspond to the associated on schema
- You can retrieve only the associated data with `Ecto.assoc/2`
- To manage new associations you can use `Ecto.Changeset.put_assoc/3`
- Each controller is also a plug, and you can redefine which parameters will be passed to it by overriding the default action function injected by phoenix controller

```elixir
  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
```

## 6.3 - In-context Relationships

- Sometimes you need to create a new context for each new resource, other times, new resources fits in an existing context
- Some resources do not even neeed a full blown HTML CRUD pages and can be implemented only on the context backend
- It's a design art to build context properly, but when in doubt always choose to create a new ne
- When you do not need all the phoenix functionalities to a resource you can use other generators such as `phx.gen.context` , `phx.gen.schema` or `phx.gen.migration`
