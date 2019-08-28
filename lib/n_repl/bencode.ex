defmodule Bencode do
  import Bento

  def encode(struct) do
    Map.from_struct(struct)
    |> Map.new(fn {k,v} -> {String.replace(Atom.to_string(k), "_", "-"), v} end)
    |> Bento.encode()
  end

  def decode(string) do
    {:ok, data} = Bento.decode(string)
    data
    |> Map.new(fn {k,v} -> {String.to_atom(String.replace(k, "-", "_")), v} end)
  end

end
