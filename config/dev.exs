use Mix.Config

config :nomnomsfarm, NomNomsFarm.Web.Endpoint,
  http: [port: 4000],
  url: [host: "localhost"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []
