defmodule NomNomsFarm.Farm do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias NomNomsFarm.{Farm, Repo}

  schema "farms" do
    field :name, :string
    field :usda_farm_id, :id
  end

  @spec create(String.t, integer) :: {:ok, %Farm{}} | {:error, Ecto.Changeset.t}
  def create(name, usda_farm_id) do
    %Farm{}
    |> changeset(%{name: name, usda_farm_id: usda_farm_id})
    |> Repo.insert()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :usda_farm_id])
    |> validate_required([:name, :usda_farm_id])
    |> unique_constraint(:usda_farm_id, message: NomNomsFarm.error_message(:farm_already_claimed))
  end
end
