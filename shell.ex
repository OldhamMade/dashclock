defmodule Shell do
  @cmd Path.expand("dht")
  # @cmd "/bin/ls"

  def exec do
    port = Port.open({:spawn, @cmd}, [:stream,
                                      :binary,
                                      :exit_status,
                                      :hide,
                                      :use_stdio,
                                      :stderr_to_stdout])
    handle_output(port)
  end

  def handle_output(port) do
    receive do
      {^port, {:data, data}} ->
        IO.puts(data)
        handle_output(port)
      {^port, {:exit_status, status}} ->
        status
    end
  end
end
