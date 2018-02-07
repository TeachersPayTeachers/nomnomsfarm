defmodule NomNomsFarm.Resolver do
  @moduledoc "Graphql resolver"

  def register_farm_admin(_, args, _) do
    case NomNomsFarm.register_farm_admin(args) do
      {:ok, _} = result ->
        result
      {:error, error} ->
        {:error, NomNomsFarm.error_message(error)}
    end
  end
end
