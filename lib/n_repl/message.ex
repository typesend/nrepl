defprotocol NRepl.Message do
  @doc "Calls a process with an nREPL message."
  def encode(msg)

  @doc "Returns true if the message is valid."
  def valid?(msg)
end

defimpl NRepl.Message,
  for: [
    NRepl.Messages.Clone,
    NRepl.Messages.Close,
    NRepl.Messages.Describe,
    NRepl.Messages.Eval,
    NRepl.Messages.Interrupt,
    NRepl.Messages.LoadFile,
    NRepl.Messages.LsSessions,
    NRepl.Messages.Stdin
  ] do
  @doc "Returns an encoded nREPL message, assigning a message id if not present."
  def encode(msg), do: NRepl.encode(msg)

  @doc "Returns true if the message is valid."
  def valid?(msg), do: NRepl.validate(msg)
end
