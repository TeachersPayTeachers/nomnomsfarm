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
      nil -> {:error, error_message(:invalid_usda_uid)}
      farm -> {:ok, farm}
    end
  end

  @spec create_records(map) :: {:ok, integer} | {:error, String.t}
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
         {:error, _failed_operation, failed_value, _changes}->
           error = inspect(failed_value.errors)
           {:error, error}
       end
  end

  @spec error_message(atom | String.t) :: String.t
  def error_message(:invalid_usda_uid), do: "Invalid USDA uid entered."
  def error_message(:farm_already_claimed), do: "The USDA farm you selected has already been claimed."
  def error_message(:email_already_claimed), do: "This email is already claimed."
end
