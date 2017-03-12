defmodule Dashclock.TempController do
  use Dashclock.Web, :controller

  def data(conn, _params) do
    data = Dashclock.Facts.Sensors.get_data
    # data = GenServer.call :sensor_server, :data
    json(conn, data)
  end
end
