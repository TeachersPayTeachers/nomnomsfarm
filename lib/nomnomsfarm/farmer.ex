defmodule NomNomsFarm.Farmer do
  @moduledoc false

  use Ecto.Schema
  alias NomNomsFarm.{Farmer, Repo}

  schema "farmers" do
    field :user_id, :integer
    field :farm_id, :integer
    field :is_admin, :boolean
  end

  @spec create(integer, integer, boolean) :: {:ok, integer} | {:error, atom}
  def create(user_id, farm_id, is_admin) do
    %Farmer{user_id: user_id, farm_id: farm_id, is_admin: is_admin}
    |> Repo.insert()
    |> case do
         {:ok, %{id: farmer_id}} -> {:ok, farmer_id}
         {:error, _} -> {:error, :creating_farmer}
       end
  end

  @spec create_refactored(integer, integer, boolean) :: {:ok, %Farmer{}} | {:error, Ecto.Changeset.t}
  def create_refactored(user_id, farm_id, is_admin) do
    %Farmer{user_id: user_id, farm_id: farm_id, is_admin: is_admin}
    |> Repo.insert()
  end
end
