defmodule Dashclock.Weather.Fetcher do
  def get(lat: lat, lon: lon) do
    response = HTTPotion.get(url_for(lat, lon), [timeout: 100_000])
    Poison.decode!(response.body)
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
