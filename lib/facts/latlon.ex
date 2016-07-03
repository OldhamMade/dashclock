defmodule Dashclock.Facts.LatLon do
  def get(ip) do
    response = HTTPotion.get(url_for(ip))
    parsed = Poison.decode!(response.body)
    [lat: parsed["lat"], lon: parsed["lon"]]
  end

  def settings() do
    File.cwd! <> "/settings.yaml"
  end

  def url_for(ip) do
    [ document | _ ] = :yamerl_constr.file(settings)
    url = :proplists.get_value(
      'Location',
      :proplists.get_value(
        'APICalls',
        document
      )
    )

    url
    |> to_string
    |> String.replace("{ip}", ip)
  end
end
