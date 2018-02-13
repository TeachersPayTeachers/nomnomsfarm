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
  }

  @spec register_farm_admin(new_admin_args) :: {:ok, integer} | {:error, String.t}
  def register_farm_admin(%{usda_uid: usda_uid} = args) do
    with {:ok, %{id: usda_farm_id, name: farm_name}} <- get_farm_by_usda_uid(usda_uid),
         :ok <- farm_is_available(usda_farm_id),
         merged_args = Map.merge(args, %{usda_farm_id: usda_farm_id, farm_name: farm_name}),
         {:ok, user_id} <- create_records(merged_args)
    do
      {:ok, user_id}
    else
      {:error, _} = e -> e
    end
  end

  @spec get_farm_by_usda_uid(String.t) :: {:ok, %UsdaFarm{}} | {:error, atom}
  defp get_farm_by_usda_uid(usda_uid) do
    case Repo.get_by(UsdaFarm, usda_uid: usda_uid) do
      nil -> {:error, :invalid_usda_uid}
      farm -> {:ok, farm}
    end
  end

  @spec farm_is_available(integer) :: :ok | {:error, atom}
  defp farm_is_available(usda_farm_id) do
    case Repo.get_by(Farm, usda_farm_id: usda_farm_id) do
      nil -> :ok
      _ -> {:error, :farm_already_claimed}
    end
  end

  @spec create_records(map) :: {:ok, integer} | {:error, atom | String.t}
  def create_records(%{
    username: username,
    password: password,
    name: name,
    email: email,
    usda_farm_id: usda_farm_id,
    farm_name: farm_name
  }) do
    Multi.new()
    |> Multi.run(:create_user, fn(_) ->
         User.create(username, password, name, email) 
       end)
    |> Multi.run(:create_farm, fn(_) ->
         Farm.create(farm_name, usda_farm_id)
       end)
    |> Multi.run(:create_farmer, fn(multi) ->
         user_id = multi.create_user.id
         farm_id = multi.create_farm.id

         Farmer.create(user_id, farm_id, true)
       end)
    |> Repo.transaction()
    |> case do
         {:ok, result} ->
           {:ok, result.create_user.id}
         {:error, failed_operation, failed_value, _changes}->
           error =
             case failed_value.errors do
               [] -> failed_operation
               errors -> "#{inspect errors}"
             end
           {:error, error}
       end
  end

  @spec error_message(atom | String.t) :: String.t
  def error_message(:invalid_usda_uid), do: "Invalid USDA uid entered."
  def error_message(:farm_already_claimed), do: "This farm has already been claimed."
  def error_message(:create_farm), do: "There was an error registering the farm."
  def error_message(:create_farmer), do: "There was an error registering the user."
  def error_message(:create_user), do: "There was an error registering the user."
  def error_message(other), do: "Error: #{other}"
end
