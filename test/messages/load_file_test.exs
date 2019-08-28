defmodule NReplTest.LoadFile do
  use ExUnit.Case
  alias NRepl.Messages.LoadFile
  doctest NRepl.Messages.LoadFile

  test "required fields" do
    assert LoadFile.required == [:file]
  end

  test "id defaults to UUID" do
    message = %LoadFile{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end

end
