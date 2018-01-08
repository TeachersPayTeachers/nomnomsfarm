defmodule NomNomsFarm.UsdaFarm do
  @moduledoc false

  use Ecto.Schema

  schema "usda_farms" do
    field :name, :string
    field :address, :string

    # distinct from the mysql id. this one comes from usda.
    field :usda_id, :string
  end
end
