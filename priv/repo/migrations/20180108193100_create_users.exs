defmodule NomNomsFarm.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :name, :string
      add :email, :string
    end

    create unique_index(:users, [:email])
  end
end
