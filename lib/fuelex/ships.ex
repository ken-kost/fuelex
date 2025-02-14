defmodule Fuelex.Ships do
  use Ash.Resource,
    otp_app: :fuelex,
    domain: Fuelex.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAi]

  postgres do
    table("ships")
    repo(Fuelex.Repo)
  end

  ai_agent do
    expose([:create, :update, :read])
  end

  actions do
    defaults([:read, update: :*])

    read :get_by_name do
      get?(true)
      argument(:name, :string)
      filter(name: arg(:name))
    end

    create :create do
      primary?(true)
      accept([:name, :mass])
      set_attribute(:name, arg(:name))
      set_attribute(:mass, arg(:mass))
    end
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:name, :string, public?: true, allow_nil?: false)
    attribute(:mass, :integer, public?: true, allow_nil?: false)
  end
end
