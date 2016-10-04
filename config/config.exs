# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :dashclock, Dashclock.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iBHbUb44ELgBWmJHUHiiTV9DwK1HAnPJ9yz5SUXsgtZnKwEvKXd3zPqDrtSVtc2r",
  render_errors: [view: Dashclock.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Dashclock.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# custom settings

config :dashclock, :api_keys,
  forecastio_id: "23441ba59d9294a1fabbab88c90b6dcc",
  tfl_id: "1f7d6c98",
  tfl_key: "4460186a9dabfafa9b1a839072c50325"

config :dashclock, :api_urls,
  ip: "https://api.ipify.org",
  location: "http://ip-api.com/json/{ip}",
  weather: "https://api.forecast.io/forecast/{apikey}/{lat},{lon}?units=si",
  tfl: "https://api.tfl.gov.uk/line/mode/tube,dlr/status?app_id={id}&app_key={key}"

# import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
