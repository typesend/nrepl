defmodule NReplTest.Clone do
  use ExUnit.Case
  alias NRepl.Messages.Clone
  alias NRepl.Bencode
  doctest NRepl.Messages.Clone

  test "encodes correctly", _context do
    result =
      NRepl.Message.encode(%Clone{session: "gm7it23uikjknkewz2yg", id: "one"})

    assert result == "d2:id3:one2:op5:clone7:session20:gm7it23uikjknkewz2yge"
  end

  test "encodes custom message id when provided", _context do
    result =
      NRepl.Message.encode(%Clone{session: "gm7it23uikjknkewz2yg", id: "one"})

    assert result == "d2:id3:one2:op5:clone7:session20:gm7it23uikjknkewz2yge"
  end

  test "removes invalid session ids", _context do
    a = %Clone{session: "", id: "wombat"}
    b = %Clone{session: nil, id: "kitten"}
    assert {:error, :invalid} == Bencode.encode(a)
    assert_raise RuntimeError, fn -> NRepl.Message.encode(a) end
    assert {:error, :invalid} == Bencode.encode(b)
    assert_raise RuntimeError, fn -> NRepl.Message.encode(b) end
  end

  test "message id generated", _context do
    message = %Clone{op: "clone", session: "123"}
    result = NRepl.Message.encode(message)
    assert result =~ message.id
  end

  test "required fields" do
    assert Clone.required == [:session]
  end

  test "id defaults to UUID" do
    message = %Clone{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end
end
