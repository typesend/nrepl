defmodule NRepl.Messages.Interrupt do
  import UUID, only: [uuid4: 0]
  defstruct op: "interrupt", session: nil, interrupt_id: nil, id: UUID.uuid4()

  def required(), do: [:session]
end
