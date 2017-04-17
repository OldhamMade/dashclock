defmodule Dashclock.Facts.Seriesly do
  use Timex

  @window {-5, 1}

  def get() do
    response = HTTPoison.get!(url, [timeout: 100_000])
    Poison.decode!(response.body)
  end

  defp url() do
    seriesly = Application.get_env(:dashclock, :seriesly)

    query = Enum.join([
      from(),
      to(),
      group(seriesly),
      ptr(seriesly),
      filter(seriesly),
    ], "&")

    Application.get_env(:dashclock, :api_urls)[:seriesly] <> "?" <> query
  end

  defp from() do
    offset = @window |> elem(0)

    Timex.shift(Timex.now, minutes: offset)
    |> Timex.format!("from=%Y-%m-%dT%H:%M", :strftime)
  end

  defp to() do
    offset = @window |> elem(1)

    Timex.shift(Timex.now, minutes: offset)
    |> Timex.format!("to=%Y-%m-%dT%H:%M", :strftime)
  end

  defp group(data) do
    "group=" <> data[:group]
  end

  defp ptr(data) do
    data[:collect]
    |> Enum.map(fn({k, v}) -> "ptr=" <> k <> "&reducer=" <> v end)
    |> Enum.join("&")
  end

  defp filter(data) do
    {f, v} = data[:filter]
    "f=" <> f <> "&fv=" <> v
  end
end
