defmodule Fuelex.Repo do
  use AshPostgres.Repo,
    otp_app: :fuelex

  def installed_extensions do
    # Add extensions here, and the migration generator will install them.
    ["uuid-ossp", "citext", "ash-functions"]
  end

  def min_pg_version do
    # Adjust this according to your postgres version
    %Version{major: 16, minor: 0, patch: 0}
  end
end
