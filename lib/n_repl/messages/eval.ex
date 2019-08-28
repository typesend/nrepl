defmodule NRepl.Messages.Eval do
  import UUID, only: [uuid4: 0]
  defstruct op: "eval", code: nil, session_id: nil, id: UUID.uuid4()

  def required(), do: [:code]
end
