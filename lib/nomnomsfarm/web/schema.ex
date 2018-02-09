defmodule NomNomsFarm.Web.Schema do
  @moduledoc "Contains the GraphQL schema for all queries served by the api."

  use Absinthe.Schema

  query do
  end

  mutation do
    @desc "Register a new farm admin."
    field :register_farm_admin, :integer do
      arg :username, non_null(:string)
      arg :password, non_null(:string)
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :usda_uid, non_null(:string)
      resolve &NomNomsFarm.Resolver.register_farm_admin/3
    end
  end
end
