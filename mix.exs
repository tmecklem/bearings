defmodule Bearings.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bearings,
      version: "0.0.1",
      elixir: "~> 1.13",
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
      {:bypass, "~> 2.1", only: :test},
      {:excoveralls, "~> 0.14", only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.4"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:ecto_sql, "~> 3.7"},
      {:ex_machina, "~> 2.7", only: [:dev, :test]},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.2.2"},
      {:oauth2, "~> 2.0"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.1"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 0.17"},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.5.2"},
      {:postgrex, "~> 0.15"},
      {:swoosh, "~> 1.3"},
      {:timex, "~> 3.7"},
      {:wallaby, "~> 0.29", runtime: false, only: :test}
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
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
