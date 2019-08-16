defmodule NRepl do
  @moduledoc """
  Documentation for NRepl.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NRepl.hello()
      :world

  """
  def eval(code_string) do
    msg = %{
      op: :eval,
      code: code_string
    }
    :poolboy.transaction(
      :worker,
      fn pid -> NRepl.Worker.send(pid, msg) end,
      1000
    )
  end
end


# :poolboy.transaction(
#   :worker,
#   fn pid -> IO.inspect(NRepl.Worker.state(pid)) end,
#   1000
#   )
  
