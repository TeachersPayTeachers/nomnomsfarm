defmodule NomNomsFarm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      supervisor(NomNomsFarm.Repo, []),
      # Start the endpoint when the application starts
      supervisor(NomNomsFarm.Web.Endpoint, []),
      # Starts a worker by calling: NomNomsFarm.Worker.start_link(arg)
      # {NomNomsFarm.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NomNomsFarm.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
