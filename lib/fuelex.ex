defmodule Fuelex do
  @moduledoc """
  Documentation for `Fuelex`.
  """

  @gravities %{
    "earth" => 9.807,
    "moon" => 1.620,
    "mars" => 3.711
  }

  @constants %{
    :launch => {0.042, 33},
    :land => {0.033, 42}
  }

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
    {constant, residual} = Map.get(@constants, directive)
    gravity = Map.get(@gravities, planet)
    calculate_recursive(mass, gravity, constant, residual, 0)
  end

  defp calculate_recursive(mass, gravity, constant, residual, fuel_acc) do
    case floor(mass * gravity * constant - residual) do
      fuel when fuel <= 0 ->
        fuel_acc

      fuel ->
        calculate_recursive(fuel, gravity, constant, residual, fuel_acc + fuel)
    end
  end

  defp validate_path(path) do
    planets = Map.keys(@gravities)

    Enum.reduce_while(path, :ok, fn {_, planet}, acc ->
      if planet in planets, do: {:cont, acc}, else: {:halt, {:error, error(planet, planets)}}
    end)
  end

  defp error(planet, planets) do
    "Gravity unknown for planet: #{planet}. Supported planets are #{planets}"
  end
end
