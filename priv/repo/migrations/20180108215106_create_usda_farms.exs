defmodule NomNomsFarm.Repo.Migrations.CreateUsdaFarms do
  use Ecto.Migration

  def change do
    create table(:usda_farms) do
      add :name, :string
      add :address, :string
      add :usda_uid, :string
    end
  end
end
