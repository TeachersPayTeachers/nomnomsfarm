defmodule NomNomsFarm.User do
  @moduledoc false

  use Ecto.Schema

  schema "users" do
    field :username, :string
    field :password, :string
    field :name, :string
    field :email, :string
  end

  @spec create(String.t, String.t, String.t, String.t) :: {:ok, integer} | {:error, atom}
  def create(username, password, name, email) do
    %NomNomsFarm.User{username: username, password: password, name: name, email: email}
    |> NomNomsFarm.Repo.insert()
    |> case do
         {:ok, %{id: user_id}} -> {:ok, user_id}
         {:error, _} -> {:error, :creating_user}
       end
  end
end
