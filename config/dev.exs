import Config

config :bearings, BearingsWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "gulp",
      "watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :bearings, BearingsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|scss|sass|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/bearings_web/(live|views)/.*(ex)$",
      ~r"lib/bearings_web/templates/.*(eex)$"
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
