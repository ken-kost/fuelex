defmodule Fuelex.GenShip do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    if opts[:random_simulations?] do
      Logger.info("Initiating random simulations...")
      Process.send_after(__MODULE__, :run_random, 2000)
    end

    {:ok, %{}}
  end

  def handle_info(:run_random, _state) do
    ships = Fuelex.Repo.all(Fuelex.Ships)
    gravities = Fuelex.Repo.all(Fuelex.Gravities)
    constants = Fuelex.Repo.all(Fuelex.Constants)
    state = %{ships: ships, gravities: gravities, constants: constants}
    state = Map.put(state, :current_ship, Enum.random(state.ships))
    path = generate_random_path(state)
    Logger.info("Calculating required fuel for ship #{state.current_ship.name}...")
    Logger.info("New path is: #{inspect(path)}")
    Process.send_after(__MODULE__, {:calculate_fuel, path}, 5000)
    Process.send_after(__MODULE__, :run_random, 10000)
    {:noreply, state}
  end

  def handle_info({:calculate_fuel, path}, %{current_ship: ship} = state) do
    case path do
      [] ->
        Logger.info("Ship has landed.")

      path ->
        calculate_fuel(ship.mass, path, ship.name)
    end

    {:noreply, state}
  end

  def handle_info({:change_ship, new_ship_name}, state) do
    case Enum.find(state.ships, &(&1.name == new_ship_name)) do
      nil ->
        Logger.info("Ship #{new_ship_name} is not supported.")
        {:noreply, state}

      ship ->
        {:noreply, Map.put(state, :ship, ship)}
    end
  end

  def run_random() do
    Process.send_after(__MODULE__, :run_random, 5000)
  end

  def schedule_fuel_calculation_for_path(path) do
    Process.send_after(__MODULE__, {:calculate_fuel, path}, 100)
  end

  def change_selected_ship(new_ship_name) do
    Process.send_after(__MODULE__, {:change_ship, new_ship_name}, 100)
  end

  defp calculate_fuel(mass, path, ship_name) do
    Logger.info("""
    #{ship_name} [mass: #{mass} kg]
    \t\t    path #{inspect(path)}
    \t\t    required fuel [mass: #{Fuelex.calculate_fuel(mass, path)} kg]
    """)
  end

  defp generate_random_path(%{gravities: gravities, constants: constants}) do
    0..Enum.random(100..300)
    |> Enum.reduce([], fn
      _i, [] ->
        launch = Enum.find(constants, &(&1.type == :launch))
        [{launch.type, Enum.find(gravities, &(&1.planet == "earth")).planet}]

      _i, [{type, random_planet_name} | _] = acc ->
        land = Enum.find(constants, &(&1.type == :land))

        new_random_planet_name =
          gravities
          |> Enum.map(& &1.planet)
          |> then(fn planet_names -> Enum.random(planet_names -- [random_planet_name]) end)

        [{type, new_random_planet_name}, {land.type, new_random_planet_name} | acc]
    end)
    |> Enum.reverse()
    |> List.insert_at(-1, {:land, "earth"})
  end
end
