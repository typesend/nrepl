defmodule NReplTest.LsSessions do
  use ExUnit.Case
  alias NRepl.Messages.LsSessions
  doctest NRepl.Messages.LsSessions

  test "required fields" do
    assert LsSessions.required() == []
  end

  test "id defaults to UUID" do
    message = %LsSessions{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end
end
