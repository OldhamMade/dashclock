defmodule Dashclock.Facts.MoonPhase do
  def get(lat: lat, lon: lon) do
    url = url_for(lat, lon)
    response = HTTPoison.get!(url, [timeout: 50_000])
    parsed = Poison.decode!(response.body)

    moon_phase(parsed)
  end

  def moon_phase(parsed) do
    parsed
    |> Map.fetch!("daily")
    |> Map.fetch!("data")
    |> List.first
    |> Map.fetch!("moonPhase")
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
