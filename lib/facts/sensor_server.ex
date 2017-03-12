defmodule Dashclock.Facts.SensorServer do
  use GenServer

  @cmd Path.expand("dht")

  defmodule Data do
    @derive [Poison.Encoder]
    defstruct [:humidity_pc, :temp_c, :temp_f]
  end

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts, [name: :sensor_server])
    pid
  end

  def init(_opts) do
    # Process.register(self, :sensors)
    # Process.flag(:trap_exit, true)
    port = Port.open({:spawn, @cmd}, [
                       :stream,
                       :exit_status,
                       :line,
                       :stderr_to_stdout
                     ])
    {:ok, {port, nil}}
    handle_output(port, %Data{})
  end

  def get_data do
    IO.puts("Sensor data call")
    GenServer.call(__MODULE__, :get_data)
  end

  def parse_data(line) do
    case Poison.decode(line, as: %Data{}) do
      {:ok, data} -> data
      _ -> %Data{}
    end
  end

  def handle_output(port, state) do
    receive do
      {^port, {:data, data}} ->
        {:eol, line} = data
        decoded = parse_data(line)

        case decoded.temp_c do
          nil ->
            IO.puts("Sensor output: nil, state: #{state.temp_c}")
            handle_output(port, state)
          _ ->
            IO.puts("Sensor output: #{decoded.temp_c}")
            handle_output(port, decoded)
        end

      {^port, {:exit_status, status}} ->
        status
    end
  end

  def handle_call(:get_data, _from, state) do
    IO.puts("Handling call for :data")
    {:reply, state, state}
  end

end
