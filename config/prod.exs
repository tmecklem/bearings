import Config

config :logger, level: :info

config(:bearings, BearingsWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]]
)
