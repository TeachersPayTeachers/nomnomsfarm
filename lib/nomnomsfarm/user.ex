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

  @spec create(String.t, String.t, String.t, String.t) :: {:ok, integer} | {:error, atom}
  def create(username, password, name, email) do
    %User{}
    |> changeset(%{username: username, password: password, name: name, email: email})
    |> Repo.insert()
    |> case do
         {:ok, %{id: user_id}} -> {:ok, user_id}
         {:error, _} -> {:error, :create_user}
       end
  end

  @spec create_refactored(String.t, String.t, String.t, String.t)
    :: {:ok, %User{}} | {:error, Ecto.Changeset.t}
  def create_refactored(username, password, name, email) do
    %User{}
    |> changeset(%{username: username, password: password, name: name, email: email})
    |> Repo.insert()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password, :name, :email])
    |> validate_required([:username, :password, :name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
