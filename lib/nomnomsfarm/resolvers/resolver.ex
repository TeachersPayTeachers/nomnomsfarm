defmodule NomNomsFarm.Resolver do
  @moduledoc "Graphql resolver"

  def register_farm_admin(_, args, _) do
    NomNomsFarm.register_farm_admin(args)
  end
end
