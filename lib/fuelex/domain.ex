defmodule Fuelex.Domain do
  use Ash.Domain, otp_app: :fuelex

  resources do
    resource Fuelex.Ships do
      define(:add_ship, action: :create, args: [:name, :mass])
      define(:get_ship, action: :get_by_name, args: [:name])
    end

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
