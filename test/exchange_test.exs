defmodule Pex.ExchangeTest do
  use ExUnit.Case
  alias Pex.Exchange

  test "save and load" do
    data = %{a: 1, b: %{b: 2}, c: [1, 2, 3], d: "string"}

    assert :ok = Exchange.save_exchange_to_file!("test.json", data)

    assert infos = Exchange.load_exchange_from_file!("test.json")

    assert infos["a"] == data.a
    assert infos["b"] == %{"b" => 2}
    assert infos["c"] == data.c
  end

  test "trunc/2" do
    assert 10.0 == Exchange.trunc(10.05, "0.1")
    assert 10.05 == Exchange.trunc(10.05, "0.001")
    assert 10.0 == Exchange.trunc(10.05, "1.0")
  end
end
