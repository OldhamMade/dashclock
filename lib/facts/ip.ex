defmodule Dashclock.Facts.IP do
  def get() do
    response = HTTPotion.get(url, [timeout: 50_000])
    response.body
  end

  defp url() do
    Application.get_env(:dashclock, :api_urls)[:ip]
  end
end
