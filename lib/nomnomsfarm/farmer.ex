defmodule NomNomsFarm.Farmer do
  @moduledoc false

  use Ecto.Schema
  alias NomNomsFarm.{Farmer, Repo}

  schema "farmers" do
    field :user_id, :id
    field :farm_id, :id
    field :is_admin, :boolean
  end

  @spec create(integer, integer, boolean) :: {:ok, %Farmer{}} | {:error, Ecto.Changeset.t}
  def create(user_id, farm_id, is_admin) do
    %Farmer{user_id: user_id, farm_id: farm_id, is_admin: is_admin}
    |> Repo.insert()
  end
end
