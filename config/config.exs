# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# General application configuration
config :bearings, ecto_repos: [Bearings.Repo]

config :bearings, Bearings.Mailer, adapter: Swoosh.Adapters.Local
config :swoosh, :api_client, false

# Configures the endpoint
config :bearings, BearingsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6cbA2wX7JGHPv6PHCXyy81kG3RdNpb/b1k4gXEFyEgma4mMr+jZvNa/KH3GeJSQX",
  render_errors: [view: BearingsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bearings.PubSub,
  live_view: [
    signing_salt: "mk5mb/ayxJPqufC6TcYE1tm+qdUqU4Qo"
  ]

config :esbuild,
  version: "0.12.17",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :bearings, Bearings.OAuth.GitHub,
  client_id: System.get_env("GITHUB_CLIENT_ID") || "",
  client_secret: System.get_env("GITHUB_CLIENT_SECRET") || "",
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI") || "",
  site: "https://api.github.com",
  authorize_url: "https://github.com/login/oauth/authorize",
  token_url: "https://github.com/login/oauth/access_token"

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
