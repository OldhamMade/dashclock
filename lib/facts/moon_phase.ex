defmodule Dashclock.Facts.MoonPhase do
  def get(lat: lat, lon: lon) do
    url = url_for(lat, lon)
    response = HTTPotion.get(url, [timeout: 50_000])
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

  def settings() do
    File.cwd! <> "/settings.yaml"
  end

  def url_for(lat, lon) do
    [ document | _ ] = :yamerl_constr.file(settings)
    
    apikey = :proplists.get_value(
      'forecast.io',
      :proplists.get_value(
        'APIKeys',
        document
      )
    )
    |> to_string
    
    url = :proplists.get_value(
      'Weather',
      :proplists.get_value(
        'APICalls',
        document
      )
    )
    |> to_string

    url
    |> String.replace("{apikey}", apikey)
    |> String.replace("{lat}", to_string(lat))
    |> String.replace("{lon}", to_string(lon))
  end
end
