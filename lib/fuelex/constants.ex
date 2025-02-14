defmodule Fuelex.Constants do
  use Ash.Resource,
    otp_app: :fuelex,
    domain: Fuelex.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("constants")
    repo(Fuelex.Repo)
  end

  actions do
    defaults([:read])

    read :get_by_type do
      get?(true)
      argument(:type, :atom)
      filter(type: arg(:type))
    end

    create :create do
      primary?(true)
      accept([:type, :residual, :constant])
      set_attribute(:type, arg(:atom))
      set_attribute(:residual, arg(:residual))
      set_attribute(:constant, arg(:constant))
    end
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:type, :atom)
    attribute(:residual, :integer, public?: true, allow_nil?: false)
    attribute(:constant, :float, public?: true, allow_nil?: false)
  end
end
