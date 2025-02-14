import Config
config :fuelex, ash_domains: [Fuelex.Domain], data_layer: AshPostgres.DataLayer

config :fuelex,
  ecto_repos: [Fuelex.Repo]

config :logger, level: :info

import_config "dev.exs"
