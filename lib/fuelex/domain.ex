defmodule Fuelex.Domain do
  use Ash.Domain, otp_app: :fuelex, extensions: [AshAi]

  ai_agent do
    expose([:add_gravity, :get_gravity])
  end

  resources do
    resource Fuelex.Gravities do
      define(:add_gravity, action: :create, args: [:planet, :constant])
      define(:get_gravity, action: :get_by_planet, args: [:planet])
    end

    resource Fuelex.Constants do
      define(:add_constant, action: :create, args: [:type, :constant, :residual])
      define(:get_constant, action: :get_by_type, args: [:type])
    end
  end
end
