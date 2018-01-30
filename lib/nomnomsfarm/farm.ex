defmodule NomNomsFarm.Farm do
  @moduledoc false

  use Ecto.Schema
  alias NomNomsFarm.{Farm, Repo}

  schema "farms" do
    field :name, :string
    field :usda_farm_id, :integer
  end

  @spec create(String.t, integer) :: {:ok, integer} | {:error, atom}
  def create(name, usda_farm_id) do
    %Farm{name: name, usda_farm_id: usda_farm_id}
    |> Repo.insert()
    |> case do
         {:ok, %{id: farm_id}} -> {:ok, farm_id}
         {:error, _} -> {:error, :create_farm}
       end
  end

  @spec create_refactored(String.t, integer) :: {:ok, %Farm{}} | {:error, Ecto.Changeset.t}
  def create_refactored(name, usda_farm_id) do
    %Farm{name: name, usda_farm_id: usda_farm_id}
    |> Repo.insert()
  end
end
