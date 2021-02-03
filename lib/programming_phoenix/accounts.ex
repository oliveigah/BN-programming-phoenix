defmodule ProgrammingPhoenix.Accounts do
  @moduledoc """
  Account's context
  """
  alias ProgrammingPhoenix.Repo
  alias ProgrammingPhoenix.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by!(User, params)
  end

  def change_user_creation(%User{} = user) do
    User.base_changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.base_changeset(attrs)
    |> Repo.insert()
  end

  def change_user_register(%User{} = user) do
    User.registration_changeset(user, %{})
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_usr_and_pwd(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
