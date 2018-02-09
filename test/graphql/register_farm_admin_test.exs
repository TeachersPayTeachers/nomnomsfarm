defmodule NomNomsFarm.GraphQL.RegisterFarmAdminTest do
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

  test "successfully registers a farm admin" do
    mutation = """
      mutation {
        registerFarmAdmin(
          username: "bart",
          password: "password",
          name: "Bartleby",
          email: "bart@bartlysons.com",
          usdaUid: "00920",
        )
      }
      """
    assert {:ok, result} = Absinthe.run(mutation, NomNomsFarm.Web.Schema)

    assert is_integer(result[:data]["registerFarmAdmin"])
    refute Map.has_key?(result, :errors)
  end

  test "returns a userful error message when request fails" do
    Repo.insert!(%Farm{usda_farm_id: 1, name: "Bartleby & Son's"})

    mutation = """
      mutation {
        registerFarmAdmin(
          username: "bart",
          password: "password",
          name: "Bartleby",
          email: "bart@bartlysons.com",
          usdaUid: "00920",
        )
      }
      """
    assert {:ok, %{errors: [error| _]}} = Absinthe.run(mutation, NomNomsFarm.Web.Schema)
    assert error.message == NomNomsFarm.error_message(:farm_already_claimed)
  end

  test "returns a helpful error message when request fails" do
    Repo.insert!(%User{email: "bart@bartlysons.com"})

    mutation = """
      mutation {
        registerFarmAdmin(
          username: "bart",
          password: "password",
          name: "Bartleby",
          email: "bart@bartlysons.com",
          usdaUid: "00920",
        )
      }
      """
    assert {:ok, %{errors: [error| _]}} = Absinthe.run(mutation, NomNomsFarm.Web.Schema)
    assert String.contains?(error.message, "[email: {\"has already been taken\"")
  end
end
