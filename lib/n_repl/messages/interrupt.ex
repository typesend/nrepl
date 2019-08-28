defmodule NRepl.Messages.Interrupt do
  import UUID, only: [uuid4: 0]
  defstruct op: "interrupt", session_id: nil, message_id: nil, id: UUID.uuid4()

  def required(), do: [:session_id, :message_id]
end
