defmodule Pex.BinanceTradeTest do
  use ExUnit.Case
  doctest Pex.BinanceTrade
  alias Pex.BinanceTrade

  test "create_trade" do
    Pex.BinanceExchange.creds()

    result =
      BinanceTrade.create_trade(%{
        stop_loss_order_id: "770534325",
        take_profit_order_id: "770534326",
        price: 10,
        symbol: "CHZUSDT"
      })

    assert {:ok, _a} = result
  end
end
