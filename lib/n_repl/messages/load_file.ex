defmodule NRepl.Messages.LoadFile do
  import UUID, only: [uuid4: 0]
  defstruct op: "load-file", file: nil, session_id: nil, id: UUID.uuid4()

  def required(), do: [:file]
end
