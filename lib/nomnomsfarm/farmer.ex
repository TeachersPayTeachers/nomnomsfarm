defmodule NomNomsFarm.Farmer do
  @moduledoc false

  use Ecto.Schema

  schema "farmers" do
    field :user_id, :integer
    field :farm_id, :integer
    field :is_admin, :boolean
  end
end
