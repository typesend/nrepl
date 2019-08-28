defmodule NReplTest.Interrupt do
  use ExUnit.Case
  alias NRepl.Messages.Interrupt
  doctest NRepl.Messages.Interrupt

  test "required fields" do
    assert Interrupt.required == [:session]
  end

  test "id defaults to UUID" do
    message = %Interrupt{}
    {:ok, info} = UUID.info(message.id)
    assert 4 == info[:version]
  end

end
