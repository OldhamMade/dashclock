defmodule Dashclock.TFL do
  use GenServer

  @interval 60_000  # 1 minute

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: TflServer)
  end

  def get do
    GenServer.call(TflServer, :get)
  end

  ## GenServer interface

  def init(:ok) do
    :erlang.send_after(1000, self(), :update)
    {:ok, %{:data => %{}}}
  end

  def handle_call(:get, _from, state) do
    {:reply, state[:data], state}
  end

  def handle_info(:update, state) do
    :erlang.send_after(@interval, self(), :update)
    {:noreply, %{state | :data => Dashclock.Facts.TFL.get()}}
  end

end
