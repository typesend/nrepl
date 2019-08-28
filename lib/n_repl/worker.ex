defmodule NRepl.Worker do
  use Connection
  alias Bento, as: B
  import UUID, only: [uuid4: 0]

  @default_url "nrepl://127.0.0.1:7700"
  @initial_state %{socket: nil, responses: [], reply_to: nil}

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

  def state(nrepl_pid) do
    Connection.call(nrepl_pid, :state)
  end

  def init(state) do
    {:connect, nil, state}
  end

  def connect(_info, state) do
    opts = [:binary]

    case :gen_tcp.connect('127.0.0.1', 7700, opts) do
      {:ok, socket} ->
        # IO.puts("Connected")
        # IO.inspect(self())
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
    # IO.inspect(self())
    {:disconnect, {:close, from}, state}
  end

  def handle_info({:tcp_closed, port}, state) do
    # IO.puts("TCP connection #{inspect(port)} closed by server")
    {:connect, nil, %{state | socket: nil}}
  end

  def handle_call({:send, message}, {from, _ref}, %{socket: socket} = state) do
    {:ok, encoded_msg} = B.encode(message)

    case :gen_tcp.send(socket, encoded_msg) do
      :ok ->
        {:reply, :ok, %{state | reply_to: from}}

      {:error, _} = error ->
        {:disconnect, error, error, state}
    end
  end

  def handle_call(:state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_info({:tcp, _port, data}, state) do
    decoded_data =
      case B.decode(data) do
        {:ok, result} ->
          result

        {:error, {:invalid, raw}} ->
          IO.puts("INVALID RESPONSE DATA: #{raw}")
          {:invalid, raw}
      end

    new_state = %{state | responses: state[:responses] ++ [decoded_data]}

    case decoded_data do
      %{"status" => ["done"]} ->
        Kernel.send(state[:reply_to], new_state[:responses])
        new_state = %{state | responses: nil, reply_to: nil}

      _ ->
        :continue
    end

    {:noreply, new_state}
  end

  def handle_call({:recv, bytes, timeout}, _, %{socket: socket} = state) do
    case :gen_tcp.recv(socket, bytes, timeout) do
      {:ok, data} ->
        {:ok, decoded_data} = B.decode(data)
        {:reply, {:ok, decoded_data}, state}

      {:error, :timeout} = timeout ->
        {:reply, timeout, state}

      {:error, _} = error ->
        {:disconnect, error, error, state}
    end
  end
end
