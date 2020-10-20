defmodule ProgrammingPhoenixWeb.HelloController do
  use ProgrammingPhoenixWeb, :controller

  def world(conn, %{"name" => name}) do
    render(conn, "world.html", name: name)
  end
end
