defmodule ProgrammingPhoenix.Accounts do
  @moduledoc """
  Account's context
  """

  alias ProgrammingPhoenix.Accounts.User

  def list_users do
    [
      %User{id: "1", name: "Teste 1", username: "test_1"},
      %User{id: "2", name: "Teste 2", username: "test_2"},
      %User{id: "3", name: "Teste 3", username: "test_3"}
    ]
  end

  def get_user(id) do
    Enum.find(list_users(), fn user -> user.id == id end)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn user ->
      Enum.all?(params, fn {key, val} -> Map.get(user, key) == val end)
    end)
  end
end
