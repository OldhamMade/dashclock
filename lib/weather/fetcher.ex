defmodule Dashclock.Weather.Fetcher do
  require Logger

  def get(lat: lat, lon: lon) do
    response = HTTPotion.get(url_for(lat, lon), [timeout: 100_000])
    Poison.decode!(response.body)
  end

  def url_for(lat, lon) do
    apikey = Application.get_env(:dashclock, :api_keys)[:forecastio_id]
    url = Application.get_env(:dashclock, :api_urls)[:weather]

    url
    |> String.replace("{apikey}", apikey)
    |> String.replace("{lat}", to_string(lat))
    |> String.replace("{lon}", to_string(lon))
  end
end
