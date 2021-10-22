defmodule Pex.Trade.KucoinTradeTest do
  use Pex.RepoCase
  alias Pex.KucoinTrade, as: KT

  test "get_balance/0" do
    balance = KT.get_balance()
    assert balance == 1748.2
  end

  test "coin_price_usdt/1" do
    assert KT.coin_price_usdt(%{currencies: "KCS"}) == 15.44945491
  end

  test "coins_list/0" do
    coin = KT.coins_list() |> List.first()
    assert %{symbol: _s, free: _f, locked: _l} = coin
  end

  test "coins_list_without_exchange_order" do
    assert KT.coins_list_without_exchange_order() == ["CRPT", "ERG", "KCS", "HTR", "NIM"]
  end

  test "coin_has_stop_orders?/3" do
    stop_orders = [
      %{"size" => "100.0", "symbol" => "WOO-USDT"}
    ]

    assert KT.coin_has_stop_orders?("WOO", "100.0", stop_orders)
    refute KT.coin_has_stop_orders?("KCS", "100.0", stop_orders)
    refute KT.coin_has_stop_orders?("WOO", "102.0", stop_orders)
  end

  test "coins_list_without_trade/0" do
    assert %{"1INCH-USDT" => list} = KT.coins_list_without_trade()
    assert is_list(list)

    assert [
             %{
               order_id: _a,
               price: _b,
               quantity: _c,
               symbol: _d
             },
             _list
           ] = list
  end
end
