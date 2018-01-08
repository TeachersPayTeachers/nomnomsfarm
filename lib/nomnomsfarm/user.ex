defmodule NomNomsFarm.User do
  @moduledoc false

  use Ecto.Schema

  schema "users" do
    field :username, :string
    field :password, :string
    field :name, :string
    field :email, :string
  end
end
