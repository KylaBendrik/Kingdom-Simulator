defmodule PeepTest do
  use ExUnit.Case, async: true

  alias Kingdom.PeepList

  test "List of peeps is empty" do
    list = PeepList.new

    assert length(list) == 0

  end
end
