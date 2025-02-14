import Config

# Configure your database
config :fuelex, Fuelex.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "fuelex_dev",
  port: 5433,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
