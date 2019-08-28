defmodule NReplTest.Eval do
  use ExUnit.Case
  alias NRepl.Messages.Eval
  doctest NRepl.Messages.Eval

  test "encodes correctly", _context do
    result =
      NRepl.Message.encode(%Eval{code: "(+ 1 1)", session_id: "gm7it23uikjknkewz2yg", id: "11111"})

    assert result == "d4:code7:(+ 1 1)2:id5:111112:op4:eval10:session-id20:gm7it23uikjknkewz2yge"
  end

  test "message id generated", _context do
    message = %Eval{code: "(* 2 5)"}
    result = NRepl.Message.encode(message)
    assert result =~ message.id
  end

  test "required fields" do
    assert Eval.required == [:code]
  end

  test "id defaults to UUID" do
    message = %Eval{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end


end
