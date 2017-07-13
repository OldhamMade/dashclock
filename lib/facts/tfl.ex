defmodule Dashclock.Facts.TFL do
  def get() do
    response = HTTPoison.get!(url, [timeout: 1_000_000])
    Poison.decode!(response.body)
  end

  defp url() do
    apiid = Application.get_env(:dashclock, :api_keys)[:tfl_id]
    apikey = Application.get_env(:dashclock, :api_keys)[:tfl_key]

    Application.get_env(:dashclock, :api_urls)[:tfl]
    |> String.replace("{id}", apiid)
    |> String.replace("{key}", apikey)

  end
end
