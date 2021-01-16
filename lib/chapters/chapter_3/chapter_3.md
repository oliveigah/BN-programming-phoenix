# 3 - Controllers

## 3.1 - Contexts

- Contexts are modules that handle the business logic and use cases of our system
- A specific context handle a bunch of functions with a shared purpose (e.g. Account CRUD on Account's context)
- This make contexts very useful to your application as a whole, providing code reuse, easy testing, separation of concerns, etc
- The controller purpose is to call context functions to execute tasks on the system
- The controller handle web related stuffs such as, routing, protocols, headers, status, etc. On the other hand contexts handle business logic
- Controllers do not know about contexts and vice versa

## 3.2 - Views

- Views are modules that handle "rendering", formating the response in a client understandable way, which for instance could be something like HTML,JSON
- This transformation can be something like transform a complex struct such as `User` into something simpler as `first_name`
- Functions inside the view module are no different from any other elixir function

## 3.3 - Templates

- Template is a special kind of function that lives inside the `view`, this function is compiled from a file containing markup language and elixir code (`file_name.html.eex`)
- There are 2 ways to inject elixir code inside the template `<%= %>` and `<% %>`, the former injects the result on the template, and the later don't (useful for side effects, use only when needed)
- You can leverage loops and many other elixir stuffs inside templates

```elixir
<h1> Listing Users </h1>

<table>
    <%= for user <- @users do%>
        <tr>
            <td>
            <%= render "user.html", user: user %>
            </td>
            <td>
            <%= link "View", to: Routes.user_path(@conn, :show, user.id)%>
            </td>
        </tr>
    <% end %>
</table>
```

- Templates are fast because after compilation they are just functions to be called by the code, and no large string copy is needed
- Templates can be nested and reused as independently components using the function `render/2`
- This `render/2` functions is very important, the first argument is always a template and the second a list of parameters to be given to the template
- The tuple pattern containing `:safe` is the common way to generate HTML from elixir code, and the text is provided as IO list for performance

## 3.4 - Helpers

- Helpers are conveniance functions write using pure elixir code
- There is a bunch of predefined helpers in phoenix
- These helper functions are defined inside the `#{project_name}_web` module, and are injected on view using `use`
- If you want to write your own helpers, write it elsewhere and teherefore `import` it to the `{project_name}_web` module inside the proper function. It is because the code will be macro-expanded to each and every correlated modules

## 3.5 - Naming Conventions

- Note that anywhere inside the `controller` you need to inform the location of `templates` neither `views` and the render function works just fine
- This happens because phoenix use naming conventions to automatically link `controllers` , `views` and `templates`
- If your controller have the name `{module_name}Controller` phoenix will automatically import views from `{module_name}View` and search for templates on `templates/{module_name}`

## 3.6 - Layouts

- Layouts are special kind of views that are rendered before the view it self
- When you call the `render/2` function, before render the specified view it renders the layout view to provide a consistent markup across all pages without any duplication
