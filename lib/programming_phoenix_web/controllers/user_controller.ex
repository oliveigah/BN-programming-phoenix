defmodule ProgrammingPhoenixWeb.UserController do
  use ProgrammingPhoenixWeb, :controller
  alias ProgrammingPhoenix.Accounts
  alias ProgrammingPhoenix.Accounts.User

  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    IO.inspect(user)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user_register(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def register(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> ProgrammingPhoenixWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} registered!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
