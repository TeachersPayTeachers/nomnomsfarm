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
          email: "bart@bartlebysons.com",
          usdaUid: "00920",
        )
      }
      """
    assert {:ok, result} = Absinthe.run(mutation, NomNomsFarm.Web.Schema)
    refute Map.has_key?(result, :errors)

    %{data: %{"registerFarmAdmin" => user_id}} = result
    created_user = Repo.get(User, user_id)
    assert created_user.username == "bart"
  end

  test "returns a helpful error message when request fails" do
    Repo.insert!(%User{email: "bart@bartlebysons.com"})

    mutation = """
      mutation {
        registerFarmAdmin(
          username: "bart",
          password: "password",
          name: "Bartleby",
          email: "bart@bartlebysons.com",
          usdaUid: "00920",
        )
      }
      """
    assert {:ok, %{errors: [error| _]}} = Absinthe.run(mutation, NomNomsFarm.Web.Schema)

    expected_message = NomNomsFarm.error_message(:email_already_claimed)
    assert String.contains?(error.message, expected_message)
  end
end
