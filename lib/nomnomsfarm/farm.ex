defmodule NomNomsFarm.Farm do
  @moduledoc false

  use Ecto.Schema

  schema "farms" do
    field :name, :string
    field :usda_farm_id, :integer
  end
end
