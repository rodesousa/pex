defmodule Pex.FtxTradeTest do
  use Pex.RepoCase
  alias Pex.FtxTrade, as: FT
  alias Pex.Data.Trade

  test "get_balance/0" do
    assert 789.8038336830847 == FT.get_balance()
  end

  test "coins_list/0" do
    coin = FT.coins_list() |> List.first()
    assert %{symbol: _s, free: _f, locked: _l} = coin
  end

  test "coins_list_without_exchange_order/0" do
    list = [
      "RAY",
      "FIDA",
      "SOL",
      "BAO",
      "FIDA_LOCKED",
      "TOMO",
      "OXY",
      "MTA",
      "SRM",
      "MEDIA",
      "AAVE",
      "ZRX",
      "ROOK",
      "USD",
      "USDT",
      "YFI",
      "BTC",
      "HXRO"
    ]

    response = FT.coins_list_without_exchange_order()

    response
    |> Enum.map(&assert &1 in list)

    assert length(list) == length(response)
  end

  test "coin_capitalization/1" do
    assert FT.coin_capitalization("SRM") == 7.0842692193546
    assert FT.coin_capitalization("MEDIA") == 0.44782209
  end

  test "coins_list_without_trade/0" do
    assert %{"SOL/USDT" => list} = FT.coins_list_without_trade()

    assert is_list(list)

    assert [
             %{
               order_id: _a,
               price: _b,
               quantity: _c,
               symbol: _d
             } = a
           ] = list
  end

  test "buy_market/4 with valid data" do
    assert {:ok, %Trade{} = trade} = FT.buy_market("CRVUSDT", 171, 300.44, 10.0)

    assert trade.take_profit > trade.stop_loss
    assert trade.take_profit == 3.44000000
    assert trade.stop_loss == 2.79000000
    assert trade.symbol == "CRVUSDT"
    assert trade.quantity == 171.0
    assert trade.side == "SELL"
    assert trade.platform == "binance"
    assert trade.stop_loss_order_id == "383059912"
    assert trade.take_profit_order_id == "383059913"
  end

  test "buy_market/4 with invalid data" do
    assert {:error, "tp < price"} = FT.buy_market("CRVUSDT", 171, 0, 10.0)
    assert {:error, "price < stop"} = FT.buy_market("CRVUSDT", 171, 300, 0.0)
  end

  test "buy_market/4 with shad strategy" do
    assert {:ok, %Trade{} = trade} = FT.buy_market("CRVUSDT", 171, 300.44, nil)

    assert trade.symbol == "CRVUSDT"
    assert trade.quantity == 50.0
    assert trade.side == "SELL"
    assert trade.platform == "binance"
    assert trade.take_profit_order_id == "33820595"
    assert trade.take_profit == 4.0
    assert is_nil(trade.stop_loss)
    assert is_nil(trade.stop_loss_order_id)
  end
end
