defmodule Pex.BinanceAPI do
  @behaviour Pex.BinanceAPIBehaviour

  @impl Pex.BinanceAPIBehaviour
  def get_price(symbol), do: Binance.get_price(symbol)

  @impl Pex.BinanceAPIBehaviour
  def get_account(), do: Binance.get_account()

  @impl Pex.BinanceAPIBehaviour
  def get_open_orders(), do: Binance.get_open_orders()

  @impl Pex.BinanceAPIBehaviour
  def get_open_orders(symbol), do: Binance.get_open_orders(symbol)

  @impl Pex.BinanceAPIBehaviour
  def order_market_buy(symbol, quantity), do: Binance.order_market_buy(symbol, quantity)

  @impl Pex.BinanceAPIBehaviour
  def order_limit_sell(symbol, quantity, tp), do: Binance.order_limit_sell(symbol, quantity, tp)

  @impl Pex.BinanceAPIBehaviour
  def create_oco_order(symbol, side, quantity, tp, stop, limit),
    do: Binance.create_oco_order(symbol, side, quantity, tp, stop, limit)
end
