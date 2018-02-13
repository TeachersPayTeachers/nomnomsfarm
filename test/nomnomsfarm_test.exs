defmodule NomNomsFarm.NomNomsFarmTest do
  use ExUnit.Case
  alias Ecto.Adapters.SQL.Sandbox

  alias NomNomsFarm.{Farm, Farmer, Repo, User, UsdaFarm}

  setup do
    :ok = Sandbox.checkout(Repo)
    add_test_data_to_db()
    Sandbox.mode(Repo, {:shared, self()})
  end

  def add_test_data_to_db do
    Repo.insert!(%UsdaFarm{id: 1, name: "Bartleby & Son's", address: "400 Plainfield", usda_uid: "00920"})
  end

  describe "register_farm_admin/1" do
    test "successful registers a farm admin" do
      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_uid: "00920",
      }

      assert {:ok, _} = NomNomsFarm.register_farm_admin(args)
    end

    test "fails when usda_uid is not found in db" do
      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_uid: "blarg",
      }

      assert {:error, :invalid_usda_uid} = NomNomsFarm.register_farm_admin(args)
    end

    test "fails when farm is already claimed" do
      Repo.insert!(%Farm{usda_farm_id: 1, name: "Bartleby & Son's"})

      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_uid: "00920",
      }

      assert {:error, :farm_already_claimed} = NomNomsFarm.register_farm_admin(args)
    end
  end

  describe "create_records/1" do
    test "successfully persists valid records" do
      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_farm_id: 1,
        farm_name: "Bartleby & Son's Sunflower Farm",
      }

      assert {:ok, created_user_id} = NomNomsFarm.create_records(args)

      created_user = Repo.get(User, created_user_id)
      assert created_user.name == args.name
      assert created_user.username == args.username

      created_farm_id =
        Repo.get_by(Farmer, user_id: created_user_id)
        |> Map.get(:farm_id)
      created_farm = Repo.get(Farm, created_farm_id)
      assert created_farm.name == args.farm_name
    end

    test "fails when invalid data is entered" do
      Repo.insert!(%User{email: "bart@bartlysons.com"})

      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlysons.com",
        usda_farm_id: 1,
        farm_name: "Bartleby & Son's Sunflower Farm",
      }

      assert {:error, "[email: {\"has already been taken\", []}]"} = NomNomsFarm.create_records(args)
    end
  end
end
