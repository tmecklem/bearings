use Mix.Config

config :bearings, BearingsWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "./assets/node_modules/parcel-bundler/bin/cli.js",
      "watch",
      "./assets/js/app.js",
      "--out-dir",
      "priv/static/js",
      "--public-url",
      "./"
    ]
  ]

config :bearings, BearingsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/bearings_web/views/.*(ex)$},
      ~r{lib/bearings_web/templates/.*(eex)$},
      ~r{lib/bearings_web/live/.*(ex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :oauth2, debug: true

config :phoenix, :stacktrace_depth, 20

config :bearings, Bearings.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "bearings_dev",
  hostname: "localhost",
  pool_size: 10
