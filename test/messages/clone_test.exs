defmodule NReplTest.Clone do
  use ExUnit.Case
  alias NRepl.Messages.Clone
  doctest NRepl.Messages.Clone

  test "encodes correctly", _context do
    result =
      NRepl.Message.encode(%Clone{op: "clone", session_id: "gm7it23uikjknkewz2yg", id: "one"})

    assert result == "d2:id3:one2:op5:clone10:session-id20:gm7it23uikjknkewz2yge"
  end

  test "encodes custom message id when provided", _context do
    result =
      NRepl.Message.encode(%Clone{op: "clone", session_id: "gm7it23uikjknkewz2yg", id: "one"})

    assert result == "d2:id3:one2:op5:clone10:session-id20:gm7it23uikjknkewz2yge"
  end

  test "removes invalid session_ids", _context do
    a = NRepl.Message.encode(%Clone{op: "clone", session_id: "", id: "wombat"})
    b = NRepl.Message.encode(%Clone{op: "clone", session_id: nil, id: "kitten"})
    assert a == "d2:id6:wombat2:op5:clonee"
    assert b == "d2:id6:kitten2:op5:clonee"
  end

  test "message id generated", _context do
    message = %Clone{op: "clone"}
    result = NRepl.Message.encode(message)
    assert result =~ message.id
  end
end
