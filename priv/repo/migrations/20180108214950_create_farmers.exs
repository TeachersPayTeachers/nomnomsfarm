defmodule NomNomsFarm.Repo.Migrations.CreateFarmers do
  use Ecto.Migration

  def change do
    create table(:farmers) do
      add :user_id, references(:users)
      add :farm_id, references(:farms)
      add :is_admin, :boolean
    end
  end
end
