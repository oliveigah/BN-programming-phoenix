defmodule ProgrammingPhoenixWeb.UserView do
  use ProgrammingPhoenixWeb, :view

  alias ProgrammingPhoenix.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
