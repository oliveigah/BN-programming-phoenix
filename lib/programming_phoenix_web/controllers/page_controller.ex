defmodule ProgrammingPhoenixWeb.PageController do
  use ProgrammingPhoenixWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
