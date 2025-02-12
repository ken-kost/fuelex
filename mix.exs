defmodule Fuelex.MixProject do
  use Mix.Project

  def project do
    [
      app: :fuelex,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ash_ai, github: "ash-project/ash_ai"},
      {:ash_json_api, "~> 1.4", override: true},
      {:igniter, "~> 0.5.23"}
    ]
  end
end
