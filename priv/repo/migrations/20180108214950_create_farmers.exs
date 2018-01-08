defmodule NomNomsFarm.Repo.Migrations.CreateFarmers do
  use Ecto.Migration

  def change do
    create table(:farmers) do
      add :user_id, :integer
      add :farm_id, :integer
      add :is_admin, :boolean
    end
  end
end
