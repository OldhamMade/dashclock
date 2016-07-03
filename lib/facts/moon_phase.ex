defmodule Dashclock.Facts.MoonPhase do
  def get(lat: lat, lon: lon) do
    url = url_for(lat, lon)
    response = HTTPotion.get(url)
    {:ok, data} = Poison.decode(response.body)
    parsed = Poison.decode!(data)

    phase = moon_phase(parsed)
    phase
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
