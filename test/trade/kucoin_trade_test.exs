defmodule Pex.Trade.KucoinTradeTest do
  use Pex.RepoCase
  alias Pex.KucoinTrade, as: KT
  alias Pex.Data.Trade

  test "get_balance/0" do
    balance = KT.get_balance()
    assert balance == 1748.2
  end

  test "coin_price/1" do
    assert KT.coin_price(%{currencies: "KCS"}) == 15.44945491
  end

  test "coins_list/0" do
    list = KT.coins_list()
    coin = list |> List.first()
    assert %{symbol: _s, free: _f, locked: _l} = coin
    inch = Enum.find(list, &(&1.symbol == "1INCH"))
    inch.locked == 22
  end

  test "coin_has_stop_orders?/3" do
    stop_orders = [
      %{"size" => "100.0", "symbol" => "WOO-USDT"}
    ]

    assert KT.coin_has_stop_orders?("WOO", "100.0", stop_orders)
    refute KT.coin_has_stop_orders?("KCS", "100.0", stop_orders)
    refute KT.coin_has_stop_orders?("WOO", "102.0", stop_orders)
  end

  test "init_risk_management/2 with valid data" do
    assert {:ok,
            %Pex.RiskManagement{
              cost: 174.82,
              distance: 10.0,
              limit: 13.862,
              pair: "KCS-USDT",
              quantity: 11.3156,
              stop_loss: 13.904,
              pair_price: 15.44945491,
              position: 174.82
            }} = KT.init_risk_management("KCS-USDT", 10.0)
  end

  test "init_risk_management/2 with invalid data" do
    assert_raise ArgumentError, fn -> KT.init_risk_management("ERROR-USDT", 10.0) end
  end

  test "create_trade/1 with valid data" do
    param = %{
      symbol: "AION",
      stop_loss_order_id: "122658018",
      take_profit_order_id: "122658019",
      price: 1.0
    }

    assert {:ok, %Trade{} = trade} = KT.create_trade(param)

    assert trade.price == param.price
    assert trade.stop_loss_order_id == param.stop_loss_order_id
    assert trade.take_profit_order_id == param.take_profit_order_id
    assert trade.symbol == param.symbol
    assert trade.quantity == 348.00000000
    assert trade.side == "SELL"
  end

  test "create_trade/1 with invalid data" do
    param = %{
      symbol: "SUSHIUSDT",
      stop_loss_order_id: "122658018",
      take_profit_order_id: "122658019",
      price: 1.0
    }

    assert {:error, "quantities are not the same"} = KT.create_trade(param)
  end

  test "buy_market /4 with invalid data" do
    assert {:error, "price > tp, but market buy have been done"} = KT.buy_market("KCS", 1, 3, 2)
  end

  test "buy_market /4 with valid data" do
    KT.buy_market("KCS", 1, 300, 2)
  end
end
