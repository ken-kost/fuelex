defmodule FuelexTest do
  use ExUnit.Case

  test "For invalid planet returns error" do
    assert {:error, error} = Fuelex.calculate_fuel(1, [{:launch, "pluto"}])
    assert error =~ "Gravity unknown for planet: pluto."
  end

  test "Apollo 11: landing on Earth" do
    mass = 28801
    path = [{:land, "earth"}]

    assert 13447 == Fuelex.calculate_fuel(mass, path)
  end

  test "Apollo 11: launching from Earth" do
    mass = 28801
    path = [{:launch, "earth"}]

    assert 19772 == Fuelex.calculate_fuel(mass, path)
  end

  test "Apollo 11: launching from Earth, landing on Moon, launching from Moon, landing on Earth" do
    mass = 28801
    path = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]

    assert 51898 == Fuelex.calculate_fuel(mass, path)
  end

  test "Mission: launching from Earth, landing on Mars, launching from Mars, landing on Earth" do
    mass = 14606
    path = [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]

    assert 33388 == Fuelex.calculate_fuel(mass, path)
  end

  test "Passenger: launching from Earth, landing on Moon, launching from Moon, landing on Mars, launching from Mars, landing on Earth" do
    mass = 75432

    path = [
      {:launch, "earth"},
      {:land, "moon"},
      {:launch, "moon"},
      {:land, "mars"},
      {:launch, "mars"},
      {:land, "earth"}
    ]

    assert 212_161 == Fuelex.calculate_fuel(mass, path)
  end
end
