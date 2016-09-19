defmodule Dashclock.Facts.TFL do
  def get() do
    response = HTTPotion.get(url, [timeout: 100_000])
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
