defmodule Fuelex do
  @moduledoc """
  Documentation for `Fuelex`.
  """

  @gravities %{
    "earth" => 9.807,
    "moon" => 1.620,
    "mars" => 3.711
  }

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
