use Mix.Config

config :bearings, BearingsWeb.Endpoint,
  http: [port: 4001],
  server: true

config :bearings, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bearings, Bearings.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "bearings_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :wallaby, screenshot_on_failure: true
