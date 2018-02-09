defmodule NomNomsFarm.Web.Router do
  @moduledoc "This module contains route-specific plugs and logic for the api."
  use Phoenix.Router
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: NomNomsFarm.Web.Schema,
      interface: :simple,
      context: %{pubsub: NomNomsFarm.Web.Endpoint}
  end
end
