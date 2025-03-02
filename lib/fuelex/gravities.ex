defmodule Fuelex.Gravities do
  use Ash.Resource,
    otp_app: :fuelex,
    domain: Fuelex.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAi]

  postgres do
    table("gravities")
    repo(Fuelex.Repo)
  end

  ai_agent do
    expose([:create, :update, :read])
  end

  actions do
    defaults([:read, update: :*])

    read :get_by_planet do
      get?(true)
      argument(:planet, :string)
      filter(planet: arg(:planet))
    end

    create :create do
      primary?(true)
      accept([:planet, :constant])
      set_attribute(:planet, arg(:planet))
      set_attribute(:constant, arg(:constant))
    end
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:planet, :string, public?: true, allow_nil?: false)
    attribute(:constant, :float, public?: true, allow_nil?: false)
  end
end
