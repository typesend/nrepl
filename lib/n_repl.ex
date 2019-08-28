defmodule NRepl do
  alias NRepl.Bencode, as: B

  def encode(%{__struct__: mod} = msg) do
    # Bencode the message
    case B.encode(msg) do
      {:error, :invalid} -> raise "Invalid message. Required fields: #{Enum.join(mod.required ++ [:op, :id], ", ")}"
      {:ok, encoded_msg} -> encoded_msg
    end
  end

  def validate(%{__struct__: mod} = msg) do
    Map.take(msg, mod.required)
    |> Map.values()
    |> (fn x -> x ++ [:op, :id] end).()
    |> Enum.all?(fn v -> v != nil && v != "" end)
  end
end
