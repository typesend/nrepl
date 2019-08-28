defmodule NReplTest.Stdin do
  use ExUnit.Case
  alias NRepl.Messages.Stdin
  doctest NRepl.Messages.Stdin

  test "required fields" do
    assert Stdin.required == [:stdin]
  end

  test "id defaults to UUID" do
    message = %Stdin{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end

end
