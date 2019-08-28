defmodule NRepl.Bencode do
  import Bento

  def encode(message) do
    if NRepl.Message.valid?(message) do
      Map.from_struct(message)
      |> Map.new(fn {k, v} -> {String.replace(Atom.to_string(k), "_", "-"), "#{v}"} end)
      |> Bento.encode()
    else
      {:error, :invalid}
    end
  end

  def decode(string) do
    {:ok, data} = Bento.decode(string)

    data
    |> Map.new(fn {k, v} -> {String.to_atom(String.replace(k, "-", "_")), "#{v}"} end)
  end
end
