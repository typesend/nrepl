defmodule NRepl.Messages.Describe do
  import UUID, only: [uuid4: 0]
  defstruct op: "describe", verbose: true, id: UUID.uuid4()

  def required(), do: []
end
