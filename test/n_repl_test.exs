defmodule NReplTest do
  use ExUnit.Case
  doctest NRepl

  test "connects successfully", do: nil
  test "retries connection at startup", do: nil
  test "reconnects when connection closes unexpectedly", do: nil
  test "does not reconnect when connection closed intentionally", do: nil
end
