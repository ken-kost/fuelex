defmodule Fuelex.GenShip do
  use GenServer
  require Logger

  defstruct [:ships, :current_ship, :gravities, :constants, :random_range, :random_allowed?]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    if opts[:random_simulations?] do
      Logger.info("Initiating random simulations...")
      Process.send_after(__MODULE__, :run_random, 2000)
    end

    state =
      struct(__MODULE__, %{
        random_range: opts[:random_range] || 1..10,
        random_allowed?: opts[:random_simulations?]
      })

    {:ok, state}
  end

  def handle_info(:random_off, state) do
    {:noreply, %{state | random_allowed?: false}}
  end

  def handle_info(:random_on, state) do
    Process.send_after(__MODULE__, :run_random, 2000)
    {:noreply, %{state | random_allowed?: true}}
  end

  def handle_info(:run_random, state) do
    ships = Fuelex.Repo.all(Fuelex.Ships)
    gravities = Fuelex.Repo.all(Fuelex.Gravities)
    constants = Fuelex.Repo.all(Fuelex.Constants)
    ship = Enum.random(ships)
    random_range = state.random_range
    state = %{state | ships: ships, gravities: gravities, constants: constants}
    state = Map.merge(state, %{current_ship: ship, random_range: random_range})

    if state.random_allowed? do
      path = generate_random_path(state)
      Logger.info("Calculating required fuel for ship #{state.current_ship.name}...")
      Logger.info("New path is: #{inspect(path)}")
      Process.send_after(__MODULE__, {:calculate_fuel, path}, 5000)
      Process.send_after(__MODULE__, :run_random, 10000)
    end

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
    :ok
  end

  def schedule_fuel_calculation_for_path(path) do
    Process.send_after(__MODULE__, {:calculate_fuel, path}, 100)
    :ok
  end

  def turn_off_random() do
    Process.send_after(__MODULE__, :random_off, 100)
    :ok
  end

  def turn_on_random() do
    Process.send_after(__MODULE__, :random_on, 100)
    :ok
  end

  def change_selected_ship(new_ship_name) do
    Process.send_after(__MODULE__, {:change_ship, new_ship_name}, 100)
    :ok
  end

  defp calculate_fuel(mass, path, ship_name) do
    Logger.info("""
    #{ship_name} [mass: #{mass} kg]
    \t\t    path #{inspect(path)}
    \t\t    required fuel [mass: #{Fuelex.calculate_fuel(mass, path)} kg]
    """)
  end

  defp generate_random_path(%{
         gravities: gravities,
         constants: constants,
         random_range: random_range
       }) do
    0..Enum.random(random_range)
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
