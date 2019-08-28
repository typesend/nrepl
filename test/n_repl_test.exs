defmodule NReplTest do
  use ExUnit.Case
  import Bencode
  doctest NRepl

  test "converting underscores to dashes in keys" do
    {:ok, encoded_msg} = Bencode.encode(%NRepl.Messages.Interrupt{})

    assert encoded_msg ==
             "d2:id36:a4bf8ecf-2f70-4386-a44c-05a9225716bf10:message-id4:null2:op9:interrupt10:session-id4:nulle"
  end

  test "decoding bencoded data" do
    data =
      Bencode.decode(
        "d2:id36:a4bf8ecf-2f70-4386-a44c-05a9225716bf10:message-id4:null2:op9:interrupt10:session-id4:nulle"
      )

    assert data == %{
             id: "a4bf8ecf-2f70-4386-a44c-05a9225716bf",
             message_id: "null",
             op: "interrupt",
             session_id: "null"
           }
  end
end
