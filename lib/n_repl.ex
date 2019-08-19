defmodule NRepl do
  @moduledoc """
  Documentation for NRepl.
  """

  defp send(message, timeout \\ 350) do
    :poolboy.transaction(
      :worker,
      fn pid -> NRepl.Worker.send(pid, message) end,
      timeout
    )
  end

  def eval(code_string) do
    %{op: :eval, code: code_string}
    |> send()
  end

  def ls_sessions() do
    %{op: :"ls-sessions"}
    |> send()
  end

  def clone(session_id \\ nil) do
    %{op: :clone}
    |> (fn msg -> if(session_id, do: %{msg | session: session_id}, else: msg) end).()
    |> send()
  end

  def close(session_id \\ nil) do
    %{op: :close}
    |> (fn msg -> if(session_id, do: %{msg | session: session_id}, else: msg) end).()
    |> send()
  end

  def describe(verbose \\ true) do
    %{op: :describe, verbose: verbose}
    |> send()
  end

  def interrupt(session_id, msg_id) do
    %{op: :interrupt, session: session_id, "interrupt-id": msg_id}
    |> send()
  end

  def load_file(contents) do
    %{op: :"load-file", file: contents}
    |> send()
  end

  def stdin(content) do
    %{op: :stdin, stdin: content}
    |> send()
  end
end
