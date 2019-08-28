defmodule NReplTest.Describe do
  use ExUnit.Case
  alias NRepl.Messages.Describe
  doctest NRepl.Messages.Describe

  test "required fields" do
    assert Describe.required() == []
  end

  test "id defaults to UUID" do
    message = %Describe{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end
end
