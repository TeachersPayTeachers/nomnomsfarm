use Mix.Config

config :nomnomsfarm, NomNomsFarm.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "nomnomsfarm_test",
  username: "root",
  password: "",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
