defmodule NomNomsFarm.Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :nomnomsfarm

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug NomNomsFarm.Web.Router
end
