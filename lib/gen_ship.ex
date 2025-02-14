defmodule Fuelex.GenShip do
  use GenServer
  require Logger

  @ships %{
    "Apollo 11" => 28801,
    "Mission" => 14606,
    "Passenger" => 75432
  }

  @planets ["earth", "moon", "mars"]

  @directives [:launch, :land]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    state = %{ships: @ships, planets: @planets, directives: @directives}
    state = Map.put(state, :selected_ship_name, Enum.random(Map.keys(state.ships)))

    if opts[:random_simulations?] do
      Logger.info("Initiating random simulations...")
      Process.send_after(__MODULE__, :run_random, 2000)
    end

    {:ok, state}
  end

  def handle_info(:run_random, state) do
    {state, path} = generate_random_path(state)
    Logger.info("Calculating required fuel for ship #{state.selected_ship_name}...")
    Logger.info("New path is: #{inspect(path)}")
    Process.send_after(__MODULE__, {:calculate_fuel, path}, 5000)
    Process.send_after(__MODULE__, :run_random, 10000)
    {:noreply, state}
  end

  def handle_info({:calculate_fuel, path}, state) do
    %{selected_ship_name: selected_ship_name, ships: ships} = state

    case path do
      [] ->
        Logger.info("Ship has landed.")

      path ->
        mass = Map.get(ships, selected_ship_name)
        calculate_fuel(mass, path, selected_ship_name)
    end

    {:noreply, state}
  end

  def handle_info({:change_ship, new_ship_name}, state) do
    if Map.has_key?(state.ships, new_ship_name) do
      state = Map.put(state, :selected_ship_name, new_ship_name)
      {:noreply, state}
    else
      Logger.info("Ship #{new_ship_name} is not supported.")
      {:noreply, state}
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

  defp generate_random_path(state) do
    %{ships: ships, planets: planets, directives: directives} = state
    state = Map.put(state, :selected_ship_name, Enum.random(Map.keys(ships)))
    random_path_length = Enum.random(1..3)

    path =
      0..random_path_length
      |> Enum.reduce([], fn
        _i, [] ->
          [launch, _] = directives
          [{launch, "earth"}]

        _i, [{launch, random_planet_1} | _] = acc ->
          [_, land] = directives
          random_planet_2 = Enum.random(planets -- [random_planet_1])
          [{launch, random_planet_2}, {land, random_planet_2} | acc]
      end)
      |> Enum.reverse()
      |> List.insert_at(-1, {:land, "earth"})

    {state, path}
  end
end
