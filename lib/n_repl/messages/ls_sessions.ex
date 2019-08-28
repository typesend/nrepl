defmodule NRepl.Messages.LsSessions do
  import UUID, only: [uuid4: 0]
  defstruct op: "ls-sessions", id: UUID.uuid4()

  def required(), do: []
end
