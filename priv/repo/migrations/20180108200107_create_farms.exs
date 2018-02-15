defmodule NomNomsFarm.Repo.Migrations.CreateFarms do
  use Ecto.Migration

  def change do
    create table(:farms) do
      add :name, :string
      add :usda_farm_id, references(:usda_farms)
    end

    create unique_index(:farms, [:usda_farm_id])
  end
end
