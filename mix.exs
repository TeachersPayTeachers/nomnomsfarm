defmodule NomNomsFarm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nomnomsfarm,
      version: "0.1.0",
      elixir: "~> 1.5",
      compilers: [:phoenix] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NomNomsFarm.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:absinthe_ecto, "~> 0.1.0"},
      {:absinthe_plug, "~> 1.4.0"},
      {:cowboy, "~> 1.0"},
      {:ecto, "~> 2.1"},
      {:mariaex, "~> 0.8.3"},
      {:number, "~> 0.5.1"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_ecto, "~> 3.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
    ]
  end

  defp aliases do
    ["setup": ["ecto.create --quiet", "ecto.migrate", "run priv/ecto/seed.exs"]]
  end
end
