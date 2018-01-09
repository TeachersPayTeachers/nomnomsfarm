defmodule NomNomsFarm.Farm do
  @moduledoc false

  use Ecto.Schema

  schema "farms" do
    field :name, :string
    field :usda_farm_id, :integer
  end

  @spec create(String.t, integer) :: {:ok, integer} | {:error, atom}
  def create(name, usda_farm_id) do
    %NomNomsFarm.Farm{name: name, usda_farm_id: usda_farm_id}
    |> NomNomsFarm.Repo.insert()
    |> case do
         {:ok, %{id: farm_id}} -> {:ok, farm_id}
         {:error, _} -> {:error, :creating_farm}
       end
  end
end
