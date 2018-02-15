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
        email: "bart@bartlebysons.com",
        usda_uid: "00920",
      }

      assert {:ok, _} = NomNomsFarm.register_farm_admin(args)
    end

    test "fails when usda_uid is not found in db" do
      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlebysons.com",
        usda_uid: "blarg",
      }

      assert {:error, message} = NomNomsFarm.register_farm_admin(args)

      expected_message = NomNomsFarm.error_message(:invalid_usda_uid)
      assert String.contains?(message, expected_message)
    end
  end

  describe "create_records/1" do
    test "successfully persists valid records" do
      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlebysons.com",
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

    test "fails when non-unique user email is entered" do
      Repo.insert!(%User{email: "bart@bartlebysons.com"})

      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlebysons.com",
        usda_farm_id: 1,
        farm_name: "Bartleby & Son's Sunflower Farm",
      }

      assert {:error, message} = NomNomsFarm.create_records(args)

      expected_message = NomNomsFarm.error_message(:email_already_claimed)
      assert String.contains?(message, expected_message)
    end

    test "fails when USDA farm has already been claimed" do
      Repo.insert!(%Farm{usda_farm_id: 1, name: "Bartleby & Son's Sunflower Farm"})

      args = %{
        username: "bart",
        password: "password",
        name: "Bartleby",
        email: "bart@bartlebysons.com",
        usda_farm_id: 1,
        farm_name: "Bartleby & Son's Sunflower Farm",
      }

      assert {:error, message} = NomNomsFarm.create_records(args)

      expected_message = NomNomsFarm.error_message(:farm_already_claimed)
      assert String.contains?(message, expected_message)

      refute Repo.get_by(User, email: "bart@bartlysons")
    end
  end
end
