defmodule Dashclock.Weather do
  use GenServer

  @interval 180_000  # 3 minutes

  def start_link do
    GenServer.start_link(__MODULE__, [], name: WeatherServer)
  end

  def get do
    GenServer.call(WeatherServer, :get)
  end

  ## GenServer interface

  def init() do
    ip = Dashclock.Facts.IP.get()
    latlon = Dashclock.Facts.LatLon.get(ip)
    :erlang.send_after(1000, self(), :update)
    {:ok, %{:ip => ip, :latlon => latlon, :weather => %{}}}
  end

  def handle_call(:get, _from, state) do
    {:reply, state[:weather], state}
  end

  def handle_info(:update, state) do
    :erlang.send_after(@interval, self(), :update)
    weather = Dashclock.Facts.Weather.get(state[:latlon])
    {:noreply, %{state | :weather => weather}}
  end

end
