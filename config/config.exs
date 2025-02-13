import Config
config :fuelex, ash_domains: [Fuelex.Domain], data_layer: AshPostgres.DataLayer

config :fuelex,
  ecto_repos: [Fuelex.Repo]

import_config "dev.exs"
