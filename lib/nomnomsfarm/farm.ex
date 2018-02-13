defmodule NomNomsFarm.Farm do
  @moduledoc false

  use Ecto.Schema
  alias NomNomsFarm.{Farm, Repo}

  schema "farms" do
    field :name, :string
    field :usda_farm_id, :id
  end

  @spec create(String.t, integer) :: {:ok, %Farm{}} | {:error, Ecto.Changeset.t}
  def create(name, usda_farm_id) do
    %Farm{name: name, usda_farm_id: usda_farm_id}
    |> Repo.insert()
  end
end
