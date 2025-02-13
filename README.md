# Fuelex

Run `mix test --trace` for tests.

Run `iex -S mix` to start `GenShip` with random simulations.

```
12:42:18.218 [info] Initiating random simulations...
Interactive Elixir (1.18.1) - press Ctrl+C to exit (type h() ENTER for help)

12:42:20.225 [info] Calculating required fuel for ship Mission...

12:42:20.237 [info] New path is: [launch: "earth", land: "mars", launch: "mars", land: "earth", launch: "earth", land: "earth"]

12:42:25.244 [info] Mission [mass: 14606 kg]
                    path [launch: "earth", land: "mars", launch: "mars", land: "earth", launch: "earth", land: "earth"]
                    required fuel [mass: 105214 kg]


12:42:30.254 [info] Calculating required fuel for ship Passenger...

12:42:30.254 [info] New path is: [launch: "earth", land: "moon", launch: "moon", land: "earth", launch: "earth", land: "moon", launch: "moon", land: "earth"]

12:42:32.361 [info] Passenger [mass: 75432 kg]
                    path [launch: "earth", land: "moon", launch: "moon", land: "earth", launch: "earth", land: "moon", launch: "moon", land: "earth"]
                    required fuel [mass: 530769 kg]
```