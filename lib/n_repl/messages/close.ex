defmodule NRepl.Messages.Close do
  import UUID, only: [uuid4: 0]
  defstruct op: "close", session_id: nil, id: UUID.uuid4()

  def required(), do: [:session_id]
end
