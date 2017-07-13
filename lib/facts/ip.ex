defmodule Dashclock.Facts.IP do
  def get() do
    response = HTTPoison.get!(url, [timeout: 1000_000])
    response.body
  end

  defp url() do
    Application.get_env(:dashclock, :api_urls)[:ip]
  end
end
