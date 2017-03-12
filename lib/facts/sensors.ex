defmodule Dashclock.Facts.Sensors do
  @cmd Path.expand("dht")

  defmodule SensorData do
    @derive [Poison.Encoder]
    defstruct [:humidity_pc, :temp_c, :temp_f]
  end

  def get_data do
    port = Port.open({:spawn, @cmd}, [
                       :stream,
                       :exit_status,
                       :line,
                       :stderr_to_stdout
                     ])
    {:ok, {port, nil}}
    handle_output(port, %SensorData{})
  end

  def parse_data(line) do
    case Poison.decode(line, as: %SensorData{}) do
      {:ok, data} -> data
      _ -> %SensorData{}
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
            decoded
        end

      {^port, {:exit_status, status}} ->
        status
    end
  end

end
