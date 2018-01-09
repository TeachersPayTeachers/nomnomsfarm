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
        username: "Bob",
        password: "password",
        name: "bob",
        email: "bob@bob.com",
        usda_uid: "00920",
        farm_name: "bob's sunflower farm"
      }

      assert :ok = NomNomsFarm.register_farm_admin(args)
    end
  end
end
