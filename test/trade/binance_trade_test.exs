defmodule Pex.BinanceTradeTest do
  use ExUnit.Case
  alias Pex.BinanceTrade

  test "get_price/1" do
    Pex.BinanceExchange.creds()
    price = BinanceTrade.get_price("BTCUSDT") |> String.to_float()

    assert is_float(price)
  end
end
