defmodule Dashclock.Facts.LatLon do
  def get(ip) do
    response = HTTPoison.get!(url_for(ip), [timeout: 50_000])
    parsed = Poison.decode!(response.body)
    [lat: parsed["lat"], lon: parsed["lon"]]
  end

  def url_for(ip) do
    Application.get_env(:dashclock, :api_urls)[:location]
    |> String.replace("{ip}", ip)
  end
end
