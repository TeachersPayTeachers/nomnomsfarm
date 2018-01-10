defmodule NomNomsFarmTest do
  use ExUnit.Case
  alias Ecto.Adapters.SQL.Sandbox
  doctest NomNomsFarm

  alias NomNomsFarm.{Farm, Farmer, Repo, User, UsdaFarm}

  setup do
    :ok = Sandbox.checkout(Repo)
    Sandbox.mode(Repo, {:shared, self()})
  end

  describe "register_farm_admin/1" do
    test "successful registers a farm admin" do
      Repo.insert!(%UsdaFarm{name: "Bartleby & Son's", address: "400 Plainfield", usda_uid: "00920"})

      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_uid: "00920",
        farm_name: "Bartleby & Son's Sunflower Farm",
      }

      assert :ok = NomNomsFarm.register_farm_admin(args)
    end

    test "fails when usda_uid is not found in db" do
      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_uid: "00920",
        farm_name: "Bartleby & Son's Sunflower Farm",
      }

      assert {:error, :invalid_usda_uid} = NomNomsFarm.register_farm_admin(args)
    end

    test "fails when invalid data is entered" do
      Repo.insert!(%UsdaFarm{name: "Bartleby & Son's", address: "400 Plainfield", usda_uid: "00920"})
      Repo.insert!(%User{email: "bart@bartlysons.com"})

      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_uid: "00920",
        farm_name: "Bartleby & Son's Sunflower Farm",
      }

      assert {:error, :creating_user} = NomNomsFarm.register_farm_admin(args)
    end
  end
end
