defmodule NRepl.Worker do
  use Connection
  import Bento
  import UUID

  @default_url "nrepl://127.0.0.1:7700"
  @initial_state %{socket: nil}

  defp nrepl_server_config do
    [host, port] =
      ~r/nrepl:\/\/(?<host>.*):(?<port>.*)/i
      |> Regex.named_captures(System.get_env("NREPL_URL", @default_url))
      |> Map.values()

    {host, String.to_integer(port)}
  end

  def start_link(_) do
    Connection.start_link(__MODULE__, @initial_state)
  end

  def close(nrepl_pid) do
    IO.inspect(nrepl_pid)
    Connection.call(nrepl_pid, :close)
  end

  def send(nrepl_pid, message) do
    Connection.call(nrepl_pid, {:send, Map.merge(%{id: UUID.uuid4()}, message)})
  end

  def eval() do
  end

  def init(state) do
    {:connect, nil, state}
  end

  def connect(_info, state) do
    opts = [:binary]

    case :gen_tcp.connect('127.0.0.1', 7700, opts) do
      {:ok, socket} ->
        IO.puts("Connected")
        IO.inspect(self())
        {:ok, %{state | socket: socket}}

      {:error, reason} ->
        IO.puts("Connect error: #{inspect(reason)}")
        {:backoff, 750, state}
    end
  end

  def disconnect(info, %{socket: socket} = state) do
    :ok = :gen_tcp.close(socket)

    case info do
      {:close, from} ->
        Connection.reply(from, :ok)

      {:error, :closed} ->
        :error_logger.format("Connection closed~n", [])

      {:error, reason} ->
        reason = :inet.format_error(reason)
        :error_logger.format("Connection error: ~s~n", [reason])
    end

    {:connect, :reconnect, %{state | socket: nil}}
  end

  def handle_call(:close, from, state) do
    IO.inspect(self())
    {:disconnect, {:close, from}, state}
  end

  def handle_info({:tcp_closed, port}, state) do
    IO.puts("TCP connection #{inspect(port)} closed by server")
    {:connect, nil, %{state | socket: nil}}
  end

  def handle_call({:send, message}, _from, %{socket: socket} = state) do
    {:ok, encoded_msg} = Bento.encode(message)

    case :gen_tcp.send(socket, encoded_msg) do
      :ok ->
        IO.puts("Sent #{inspect(message)} ::: #{encoded_msg}")
        {:reply, :ok, state}

      {:error, _} = error ->
        {:disconnect, error, error, state}
    end
  end

  def handle_info({:tcp, _port, data}, state) do
    {:ok, decoded_data} = Bento.decode(data)
    IO.puts("Received #{inspect(decoded_data)}")
    {:noreply, state}
  end

  def handle_call({:recv, bytes, timeout}, _, %{socket: socket} = state) do
    case :gen_tcp.recv(socket, bytes, timeout) do
      {:ok, data} ->
        {:ok, decoded_data} = Bento.decode(data)
        {:reply, {:ok, decoded_data}, state}

      {:error, :timeout} = timeout ->
        {:reply, timeout, state}

      {:error, _} = error ->
        {:disconnect, error, error, state}
    end
  end
end
