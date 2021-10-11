defmodule Pex.BinanceTradeTest do
  use Pex.RepoCase
  alias Pex.BinanceTrade, as: BT
  alias Pex.Data.Trade

  test "coins_list/0" do
    coin = BT.coins_list() |> List.first()
    assert %{symbol: _s, free: _f, locked: _l} = coin
  end

  test "coins_list_without_exchange_order" do
    assert BT.coins_list_without_exchange_order() == ["BNB", "BTC"]
  end

  test "coins_list_without_local_order/0" do
    assert %{"AIONUSDT" => list} = BT.coins_list_without_local_order()
    assert is_list(list)

    assert [
             %{
               order_id: _a,
               price: _b,
               quantity: _c,
               symbol: _d
             } = a,
             _list
           ] = list
  end

  test "create_trade/1 with valid data" do
    param = %{
      symbol: "AION",
      stop_loss_order_id: "122658018",
      take_profit_order_id: "122658019",
      price: 1.0
    }

    assert {:ok, %Trade{} = trade} = BT.create_trade(param)

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

    assert {:error, "quantities are not the same"} = BT.create_trade(param)
  end

  test "create_shad/1 with valid data" do
    param = %{
      symbol: "AIONUSDT",
      take_profit_order_id: "122658019",
      price: 1.0
    }

    assert {:ok, %Trade{} = trade} = BT.create_shad(param)
    assert trade.price == param.price
    assert trade.stop_loss_order_id == nil
    assert trade.take_profit_order_id == param.take_profit_order_id
    assert trade.symbol == param.symbol
    assert trade.quantity == 348.00000000
    assert trade.side == "SELL"
  end

  test "create_shad/1 with invalid data" do
    param = %{
      symbol: "AIONUSDT",
      take_profit_order_id: "122658022",
      price: 1.0
    }

    assert {:error, "take_profit_order_id not found"} = BT.create_shad(param)
  end

  test "buy_market/4 with valid data" do
    assert {:ok, %Trade{} = trade} = BT.buy_market("CRVUSDT", 171, 300.44, 10.0)

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
    assert {:error, "tp < price"} = BT.buy_market("CRVUSDT", 171, 0, 10.0)
    assert {:error, "price < stop"} = BT.buy_market("CRVUSDT", 171, 300, 0.0)
  end

  test "buy_market/4 with shad strategy" do
    assert {:ok, %Trade{} = trade} = BT.buy_market("CRVUSDT", 171, 300.44, nil)

    assert trade.symbol == "CRVUSDT"
    assert trade.quantity == 50.0
    assert trade.side == "SELL"
    assert trade.platform == "binance"
    assert trade.take_profit_order_id == "33820595"
    assert trade.take_profit == 4.0
    assert is_nil(trade.stop_loss)
    assert is_nil(trade.stop_loss_order_id)
  end

  test "determine_oco_orders/1" do
    assert BT.determine_oco_orders([%{"price" => 1}, %{"price" => 2}]) == %{
             tp: %{"price" => 2},
             stop: %{"price" => 1}
           }
  end

  test "coin_capitalization/1" do
    assert BT.coin_capitalization("SOL") == 40.0
    assert BT.coin_capitalization("SPARTA") == 80.0
  end

  test "balance/0" do
    assert BT.get_balance() == 1395.45
  end
end
