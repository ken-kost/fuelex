# Fuelex

Run `MIX_ENV=test mix setup && mix test --trace` for tests.

Run `mix setup && iex -S mix` to start `GenShip` with random simulations.

Setup is necessary to seed initial data.

But with `ash_ai` it is possible to tell the agent to insert it for you.

By doing `AshAi.iex_chat [otp_app: :fuelex]` you will gain access in talking to the agent.

In order for it to work, before starting you need to
`export OPEN_AI_API_KEy="you_open_ai_api_key"`.

In order to exit you enter `exit`

Once in the iex chat empowered by your AI
 you could ask for missing planets from the solar system, or
different ships and their mass that NASA has.

## Random run from GenShip

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