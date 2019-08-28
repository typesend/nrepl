defmodule NRepl do
  alias NRepl.Bencode, as: B

  def encode(%{__struct__: mod} = msg) do
    # Remove empty session_ids
    msg =
      case msg do
        %{session_id: ""} -> Map.delete(msg, :session_id)
        %{session_id: nil} -> Map.delete(msg, :session_id)
        _ -> msg
      end

    # Bencode the message
    case B.encode(msg) do
      {:ok, encoded_msg} -> encoded_msg
      {:error, :invalid} -> raise "Invalid message. Required fields: #{Enum.join(mod.required, ", ")}"
    end
  end

  def validate(%{__struct__: mod} = msg) do
    Map.take(msg, mod.required)
    |> Map.values()
    |> Enum.all?(fn v -> v != nil && v != "" end)
  end
end
