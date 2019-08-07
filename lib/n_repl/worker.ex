defmodule NRepl.Worker do
  use GenServer

  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def call(message) do
    GenServer.call(__MODULE__, message, 500)
  end

  def init(options) do
    %{host: host, port: port} = options
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary])
  end

  def handle_call(message, _from, socket) do
    {:ok, encoded_message} = Bento.encode(message)
    case :gen_tcp.send(socket, encoded_message) do
      :ok -> IO.puts "SENT #{encoded_message}"
      {:error, reason} -> IO.puts "ERROR: #{reason}"
    end
    {:noreply, socket}
  end
end
