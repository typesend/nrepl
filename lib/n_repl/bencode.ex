defmodule Bencode do
  import Bento

  def encode(struct) do
    Map.from_struct(struct)
    |> Map.new(fn {k,v} -> {String.replace(Atom.to_string(k), "_", "-"), v} end)
    |> Bento.encode()
  end

end
