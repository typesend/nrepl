defmodule NRepl.Messages.Stdin do
  import UUID, only: [uuid4: 0]
  defstruct op: "stdin", stdin: nil, session: nil, id: UUID.uuid4()

  def required(), do: [:stdin]
end
