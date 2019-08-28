defmodule NReplTest.Bencode do
  use ExUnit.Case
  alias NRepl.{Bencode, Message}
  doctest NRepl.Bencode

  test "converting underscores to dashes in keys and values to strings" do
    {:ok, encoded_msg} =
      Bencode.encode(%NRepl.Messages.Interrupt{
        interrupt_id: 234_234,
        session: "asdfasdfasdfff4",
        id: "888"
      })

    assert encoded_msg ==
             "d2:id3:88812:interrupt-id6:2342342:op9:interrupt7:session15:asdfasdfasdfff4e"
  end

  test "decoding bencoded data" do
    data =
      Bencode.decode(
        "d2:id3:88812:interrupt-id6:2342342:op9:interrupt7:session15:asdfasdfasdfff4e"
      )

    assert data == %{
             interrupt_id: "234234",
             op: "interrupt",
             session: "asdfasdfasdfff4",
             id: "888"
           }
  end

  test "invalid message structs refuse to encode" do
    assert {:error, :invalid} == Bencode.encode(%NRepl.Messages.Interrupt{})
    assert_raise RuntimeError, fn -> Message.encode(%NRepl.Messages.Interrupt{}) end
  end
end
