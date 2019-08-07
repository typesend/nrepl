defmodule NReplTest do
  use ExUnit.Case
  doctest NRepl

  test "greets the world" do
    assert NRepl.hello() == :world
  end
end
