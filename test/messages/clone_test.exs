defmodule NReplCloneTest do
  use ExUnit.Case
  alias NRepl.Messages.Clone
  doctest NRepl

  # setup do
  #   one = %Clone{op: "clone", session_id: "gm7it23uikjknkewz2yg", id: "one"}
  #   two = %Clone{op: "clone", session_id: "v932em1zf6z9b33r9m9p", id: "two"}
  #   three =
  #   {:ok, one: one, two: two, three: three}
  # end

  # test "encodes correctly", %{one: one} do
  #   result = NRepl.Message.encode one
  #   assert result == "d2:id3:one2:op5:clone10:session_id20:gm7it23uikjknkewz2yge"
  # end
  #
  # xtest "encodes custom message id when provided", _context do
  #   result = NRepl.Message.encode(%Clone{op: "clone", session_id: "gm7it23uikjknkewz2yg", id: "one"})
  #   assert result == "d2:id3:one2:op5:clone10:session_id20:gm7it23uikjknkewz2yge"
  # end
  #
  # xtest "message id generated", _context do
  #   message = %Clone{op: "clone"}
  #   result = NRepl.Message.encode message
  #   assert result =~ message.id
  # end

end
