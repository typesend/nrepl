defmodule NReplTest.Close do
  use ExUnit.Case
  alias NRepl.Messages.Close
  doctest NRepl.Messages.Close

  test "required fields" do
    assert Close.required == [:session_id]
  end

  test "id defaults to UUID" do
    message = %Close{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end

end
