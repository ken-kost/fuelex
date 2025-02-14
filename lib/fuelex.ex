defmodule Fuelex do
  @moduledoc """
  Documentation for `Fuelex`.
  """

  #  """
  # Calculates ammount of fuel for a given mass of ship it's path.

  # ## Examples

  #     iex> Fuelex.calculate_fuel(28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}])
  #     51898

  # """
  @spec calculate_fuel(integer(), [{atom(), String.t()}]) :: integer()
  def calculate_fuel(mass, path) do
    with :ok <- validate_path(path) do
      Enum.reduce(Enum.reverse(path), 0, &(calculate(&1, &2 + mass) + &2))
    end
  end

  defp calculate({directive, planet}, mass) do
    %{constant: constant, residual: residual} = Fuelex.Domain.get_constant!(directive)
    gravity = Fuelex.Domain.get_gravity!(planet)
    calculate_recursive(mass, gravity.constant, constant, residual, 0)
  end

  defp calculate_recursive(mass, gravity_constant, constant, residual, fuel_acc) do
    case floor(mass * gravity_constant * constant - residual) do
      fuel when fuel <= 0 ->
        fuel_acc

      fuel ->
        calculate_recursive(fuel, gravity_constant, constant, residual, fuel_acc + fuel)
    end
  end

  defp validate_path(path) do
    planets = Enum.map(Ash.read!(Fuelex.Gravities), & &1.planet)

    Enum.reduce_while(path, :ok, fn {_, planet}, acc ->
      if planet in planets, do: {:cont, acc}, else: {:halt, {:error, error(planet, planets)}}
    end)
  end

  defp error(planet, planets) do
    "Gravity unknown for planet: #{planet}. Supported planets are #{planets}"
  end
end
