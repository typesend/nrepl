defmodule NRepl.Connection do
  use Connection
  alias NRepl.Bencode

  @default_url "nrepl://127.0.0.1:" <> File.read!(".nrepl-port")
  @initial_state %{socket: nil, reply_to: nil}

  defp nrepl_server_config do
    [host, port] =
      ~r/nrepl:\/\/(?<host>.*):(?<port>.*)/i
      |> Regex.named_captures(System.get_env("NREPL_URL", @default_url))
      |> Map.values()

    {to_charlist(host), String.to_integer(port)}
  end

  def start_link(_) do
    Connection.start_link(__MODULE__, @initial_state)
  end

  def init(state) do
    {:connect, nil, state}
  end

  def state(nrepl_pid) do
    Connection.call(nrepl_pid, :state)
  end

  def close(nrepl_pid) do
    Connection.call(nrepl_pid, :close)
  end

  def send(nrepl_pid, encoded_message) when is_binary(encoded_message) do
    Connection.call(nrepl_pid, {:send, encoded_message})
  end

  def connect(_info, state) do
    opts = [:binary]
    {host, port} = nrepl_server_config()

    case :gen_tcp.connect(host, port, opts) do
      {:ok, socket} ->
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
    {:disconnect, {:close, from}, state}
  end

  def handle_call({:send, encoded_msg}, {from, _ref}, %{socket: socket} = state) do
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

  def handle_call({:recv, bytes, timeout}, _, %{socket: socket} = state) do
    case :gen_tcp.recv(socket, bytes, timeout) do
      {:ok, _data} ->
        {:reply, :ok, state}

      {:error, :timeout} = timeout ->
        {:reply, timeout, state}

      {:error, _} = error ->
        {:disconnect, error, error, state}
    end
  end

  def handle_info({:tcp, _port, data}, state) do
    Kernel.send(state[:reply_to], Bencode.decode(data))
    {:noreply, state}
  end

  def handle_info({:tcp_closed, port}, state) do
    IO.puts("TCP connection #{inspect(port)} closed by server")
    {:connect, nil, %{state | socket: nil}}
  end
end
