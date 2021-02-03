defmodule ProgrammingPhoenixWeb.SessionController do
  use ProgrammingPhoenixWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case ProgrammingPhoenix.Accounts.authenticate_by_usr_and_pwd(username, pass) do
      {:ok, user} ->
        conn
        |> ProgrammingPhoenixWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back #{user.name}")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ProgrammingPhoenixWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
