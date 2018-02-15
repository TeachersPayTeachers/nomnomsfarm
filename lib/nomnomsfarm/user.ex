defmodule NomNomsFarm.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias NomNomsFarm.{Repo, User}

  schema "users" do
    field :username, :string
    field :password, :string
    field :name, :string
    field :email, :string
  end

  @spec create(String.t, String.t, String.t, String.t)
    :: {:ok, %User{}} | {:error, Ecto.Changeset.t}
  def create(username, password, name, email) do
    %User{}
    |> changeset(%{username: username, password: password, name: name, email: email})
    |> Repo.insert()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password, :name, :email])
    |> validate_required([:username, :password, :name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: NomNomsFarm.error_message(:email_already_claimed))
  end
end
