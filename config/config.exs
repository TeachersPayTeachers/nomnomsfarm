# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :nomnomsfarm, NomNomsFarm.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "nomnomsfarm",
  username: "root",
  password: "",
  hostname: "localhost"

config :nomnomsfarm,
  ecto_repos: [NomNomsFarm.Repo]

config :nomnomsfarm, NomNomsFarm.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "123123",
  pubsub: [name: NomNomsFarm.PubSub,
           adapter: Phoenix.PubSub.PG2]

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :nomnomsfarm, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:nomnomsfarm, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
    import_config "#{Mix.env}.exs"
