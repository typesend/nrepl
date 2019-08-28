defmodule NReplTest.Bencode do
  use ExUnit.Case
  alias NRepl.{Bencode, Message}
  doctest NRepl.Bencode

  test "converting underscores to dashes in keys and values to strings" do
    {:ok, encoded_msg} =
      Bencode.encode(%NRepl.Messages.Interrupt{message_id: 234_234, session_id: "asdfasdfasdfff4"})

    assert encoded_msg ==
             "d2:id36:a4bf8ecf-2f70-4386-a44c-05a9225716bf10:message-id6:2342342:op9:interrupt10:session-id15:asdfasdfasdfff4e"
  end

  test "decoding bencoded data" do
    data =
      Bencode.decode(
        "d2:id36:a4bf8ecf-2f70-4386-a44c-05a9225716bf10:message-idi234234e2:op9:interrupt10:session-id15:asdfasdfasdfff4e"
      )

    assert data == %{
             id: "a4bf8ecf-2f70-4386-a44c-05a9225716bf",
             op: "interrupt",
             message_id: "234234",
             session_id: "asdfasdfasdfff4"
           }
  end

  test "invalid message structs refuse to encode" do
    assert {:error, :invalid} == Bencode.encode(%NRepl.Messages.Interrupt{})
    assert_raise RuntimeError, fn -> Message.encode(%NRepl.Messages.Interrupt{}) end
  end
end
