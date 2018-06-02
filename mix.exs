defmodule Bearings.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bearings,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bearings.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/bearings_web/features/pages"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bypass, "~> 0.8", only: :test},
      {:excoveralls, "~> 0.8", only: :test},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.2"},
      {:ex_machina, "~> 2.2", only: [:dev, :test]},
      {:gettext, "~> 0.11"},
      {:oauth2, "~> 0.9.2"},
      {:phoenix, "~> 1.3.2"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:poison, "~> 3.1.0"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.1"},
      {:wallaby, "~> 0.20.0", [runtime: false, only: :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
