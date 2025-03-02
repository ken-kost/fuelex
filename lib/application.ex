defmodule Fuelex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [Fuelex.Repo, {Fuelex.GenShip, [random_simulations?: true, random_range: 0..1]}]

    opts = [strategy: :one_for_one, name: Fuelex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
