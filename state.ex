defmodule Stack do
  use GenServer

  @cmd Path.expand("dht")

  defmodule SensorData do
    @derive [Poison.Encoder]
    defstruct [:humidity_pc, :temp_c, :temp_f]
  end

  def start_link do
    GenServer.start_link __MODULE__, []
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

  def size(pid) do
    GenServer.call pid, :size
  end

  def push(pid, item) do
    GenServer.cast pid, {:push, item}
  end

  def pop(pid) do
    GenServer.call pid, :pop
  end

  ####
  # Genserver implementation

  def handle_cast({:push, item}, stack) do
    {:noreply, [item | stack]}
  end

  def handle_call(:size, _from, stack) do
    {:reply, Enum.count(stack), stack}
  end

  def handle_call(:pop, _from, [item | rest]) do
    {:reply, item, rest}
  end
end
