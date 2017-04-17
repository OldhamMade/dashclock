defmodule Dashclock.SerieslyController do
  use Dashclock.Web, :controller
  alias Dashclock.Facts

  def latest(conn, _params) do
    data = Facts.Seriesly.get() |> Enum.max_by(fn({k, _}) -> k end)
    [temp, humidity] = data |> elem(1)
    json(conn, %{temp: temp, humidity: humidity})
  end
end
