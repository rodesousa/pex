defmodule Pex.BinanceTradeTest do
  use Pex.RepoCase
  alias Pex.BinanceTrade, as: BT
  alias Pex.Data.Trade

  test "coins_list/0" do
    coin = BT.coins_list() |> List.first()
    assert %{symbol: _s, free: _f, locked: _l} = coin
  end

  test "coins_list_without_trade/0" do
    assert %{"AIONUSDT" => list} = BT.coins_list_without_trade()
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

  test "save_trade/1 with valid data" do
    param = %{
      symbol: "AION",
      stop_loss_order_id: "122658018",
      take_profit_order_id: "122658019",
      price: 1.0
    }

    assert {:ok, %Trade{} = trade} = BT.save_trade(param)

    assert trade.price == param.price
    assert trade.stop_loss_order_id == param.stop_loss_order_id
    assert trade.take_profit_order_id == param.take_profit_order_id
    assert trade.symbol == param.symbol
    assert trade.quantity == 348.00000000
    assert trade.side == "SELL"
  end

  test "save_trade/1 with invalid data" do
    param = %{
      symbol: "SUSHIUSDT",
      stop_loss_order_id: "122658018",
      take_profit_order_id: "122658019",
      price: 1.0
    }

    assert {:error, "quantities are not the same"} = BT.save_trade(param)
  end

  # test "create_shad/1 with valid data" do
  # param = %{
  # symbol: "AIONUSDT",
  # take_profit_order_id: "122658019",
  # price: 1.0
  # }

  # assert {:ok, %Trade{} = trade} = BT.create_shad(param)
  # assert trade.price == param.price
  # assert trade.stop_loss_order_id == nil
  # assert trade.take_profit_order_id == param.take_profit_order_id
  # assert trade.symbol == param.symbol
  # assert trade.quantity == 348.00000000
  # assert trade.side == "SELL"
  # end

  # test "create_shad/1 with invalid data" do
  # param = %{
  # symbol: "AIONUSDT",
  # take_profit_order_id: "122658022",
  # price: 1.0
  # }

  # assert {:error, "take_profit_order_id not found"} = BT.create_shad(param)
  # end

  # test "trade_buy/4 with valid data" do
  # assert {:ok, %Trade{} = trade} = BT.trade_buy("CRV", "USDT", 300.44, 10.0)

  # assert trade.take_profit > trade.stop_loss
  # assert trade.take_profit == 3.44000000
  # assert trade.stop_loss == 2.79000000
  # assert trade.symbol == "CRVUSDT"
  # assert trade.quantity == 171.0
  # assert trade.side == "SELL"
  # assert trade.platform == "binance"
  # assert trade.stop_loss_order_id == "383059912"
  # assert trade.take_profit_order_id == "383059913"
  # end

  test "trade_buy/4 with valid data" do
    assert :ok = BT.trade_buy("CRV", "USDT", 300.44, 10.0)
  end

  test "trade_buy/4 with invalid data" do
    assert_raise MatchError, fn -> BT.trade_buy("CRV", "SOL", 171, 10.0) end
  end

  # test "trade_buy/4 with shad strategy" do
  # assert {:ok, %Trade{} = trade} = BT.trade_buy("CRV", "USDT", 171, 300.44, nil)

  # assert trade.symbol == "CRVUSDT"
  # assert trade.quantity == 50.0
  # assert trade.side == "SELL"
  # assert trade.platform == "binance"
  # assert trade.take_profit_order_id == "33820595"
  # assert trade.take_profit == 4.0
  # assert is_nil(trade.stop_loss)
  # assert is_nil(trade.stop_loss_order_id)
  # end

  test "get_balance/0" do
    assert BT.get_balance() == 1395.45
  end

  test "exchange_info_filter/1 with valid" do
    assert BT.exchange_info_filter("SPARTABNB") ==
             {:ok,
              %{
                price: %{
                  "filterType" => "PRICE_FILTER",
                  "maxPrice" => "1000.00000000",
                  "minPrice" => "0.00000010",
                  "tickSize" => "0.00000010"
                },
                quantity: %{
                  "filterType" => "LOT_SIZE",
                  "maxQty" => "9000000.00000000",
                  "minQty" => "1.00000000",
                  "stepSize" => "1.00000000"
                }
              }}
  end

  test "exchange_info_filter with invalid data" do
    Pex.BinanceTrade.exchange_info_filter("DOTU")
    {:error, "DOTU not found in exchange info"}
  end

  test "right_quantity? with valid data" do
    {:ok, info} = Pex.BinanceTrade.exchange_info_filter("DOTUSDT")
    assert BT.right_quantity?(10.0, info)
  end

  test "right_quantity? with invalid data" do
    {:ok, info} = Pex.BinanceTrade.exchange_info_filter("DOTUSDT")
    refute BT.right_quantity?(0.002, info)
  end

  test "right_price? with valid data" do
    {:ok, info} = Pex.BinanceTrade.exchange_info_filter("DOTUSDT")
    assert BT.right_price?(10.0, info)
  end

  test "right_price? with invalid data" do
    {:ok, info} = Pex.BinanceTrade.exchange_info_filter("DOTUSDT")
    refute BT.right_price?(0.002, info)
  end

  test "init_risk_management/2 with valid data" do
    assert {:ok,
            %Pex.RiskManagement{
              cost: 139.55,
              distance: 10.0,
              limit: 35.892,
              pair: "SPARTABNB",
              quantity: 3.0,
              stop_loss: 36.0
            }} = BT.init_risk_management("SPARTA", "BNB", 10.0)
  end

  test "init_risk_management/2 with invalid data" do
    assert_raise MatchError, fn -> BT.init_risk_management("SPARTA", "USDT", 10.0) end
  end
end
