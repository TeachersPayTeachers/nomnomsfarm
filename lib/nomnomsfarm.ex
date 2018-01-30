defmodule NomNomsFarm do
  @moduledoc """
  Documentation for NomNomsFarm.
  """
  alias Ecto.Multi
  alias NomNomsFarm.{Farm, Farmer, Repo, User, UsdaFarm}

  @type new_admin_args :: %{
    username: String.t,
    password: String.t,
    name: String.t,
    email: String.t,
    usda_uid: String.t,
    farm_name: String.t,
  }

  @spec register_farm_admin(new_admin_args) :: :ok | {:error, String.t}
  def register_farm_admin(%{usda_uid: usda_uid} = args) do
    with {:ok, usda_farm_id} <- get_usda_farm_id(usda_uid),
         :ok <- farm_is_available(usda_farm_id),
         merged_args = Map.merge(args, %{usda_farm_id: usda_farm_id}),
         {:ok, _} <- create_records_refactored(merged_args)
    do
      :ok
    else
      {:error, _} = e -> e
    end
  end

  @spec get_usda_farm_id(String.t) :: {:ok, integer} | {:error, atom}
  defp get_usda_farm_id(usda_uid) do
    case Repo.get_by(UsdaFarm, usda_uid: usda_uid) do
      %{id: id} -> {:ok, id}
      nil -> {:error, :invalid_usda_uid}
    end
  end

  @spec farm_is_available(integer) :: :ok | {:error, atom}
  defp farm_is_available(usda_farm_id) do
    case Repo.get_by(Farm, usda_farm_id: usda_farm_id) do
      nil -> :ok
      _ -> {:error, :farm_already_claimed}
    end
  end

  defp create_records(%{
    username: username,
    password: password,
    name: name,
    email: email,
    usda_farm_id: usda_farm_id,
    farm_name: farm_name
  }) do
    Repo.transaction(fn ->
      with {:ok, user_id} <- User.create(username, password, name, email),
           {:ok, farm_id} <- Farm.create(farm_name, usda_farm_id),
           {:ok, _} <- Farmer.create(user_id, farm_id, true)
      do
        user_id
      else
        {:error, error} -> Repo.rollback(error)
      end
    end)
  end

  def create_records_refactored(%{
    username: username,
    password: password,
    name: name,
    email: email,
    usda_farm_id: usda_farm_id,
    farm_name: farm_name
  }) do
    Multi.new()
    |> Multi.run(:creating_user, fn(_) -> User.create_refactored(username, password, name, email) end)
    |> Multi.run(:creating_farm, fn(_) -> Farm.create_refactored(farm_name, usda_farm_id) end)
    |> Multi.run(:creating_farmer, fn(multi) ->
         user_id = multi.creating_user.id
         farm_id = multi.creating_farm.id

         Farmer.create_refactored(user_id, farm_id, true)
       end)
    |> Repo.transaction()
    |> case do
         {:ok, _} = result -> result
         {:error, failed_operation, _failed_value, _changes} = e ->
           IO.inspect e
           {:error, failed_operation}
       end
  end

  @spec error_message(atom) :: String.t
  def error_message(:invalid_usda_uid), do: "Invalid USDA uid entered."
  def error_message(:farm_already_claimed), do: "This farm has already been claimed."
  def error_message(:creating_farm), do: "There was an error registering the farm."
  def error_message(:creating_farmer), do: "There was an error registering the user."
  def error_message(:creating_user), do: "There was an error registering the user."
end
