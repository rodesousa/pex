defmodule Pex.BinanceAPI do
  @behaviour Pex.BinanceAPIBehaviour

  defp creds() do
    if System.get_env("BINANCE_API_KEY") == "" or System.get_env("BINANCE_SECRET_KEY") == "" do
      {:error, "You have to set BINANCE_API_KEY and BINANCE_SECRET_KEY"}
    else
      Binance.Config.set(:api_key, System.get_env("BINANCE_API_KEY"))
      Binance.Config.set(:secret_key, System.get_env("BINANCE_SECRET_KEY"))
    end
  end

  @impl Pex.BinanceAPIBehaviour
  def get_price(symbol) do
    creds()
    Binance.get_price(symbol)
  end

  @impl Pex.BinanceAPIBehaviour
  def get_account() do
    creds()
    Binance.get_account()
  end

  @impl Pex.BinanceAPIBehaviour
  def get_open_orders() do
    creds()
    Binance.get_open_orders()
  end

  @impl Pex.BinanceAPIBehaviour
  def get_open_orders(symbol) do
    creds()
    Binance.get_open_orders(symbol)
  end

  @impl Pex.BinanceAPIBehaviour
  def order_market_buy(symbol, quantity) do
    creds()
    Binance.order_market_buy(symbol, quantity)
  end

  @impl Pex.BinanceAPIBehaviour
  def order_limit_sell(symbol, quantity, tp) do
    creds()
    Binance.order_limit_sell(symbol, quantity, tp)
  end

  @impl Pex.BinanceAPIBehaviour
  def create_oco_order(symbol, side, quantity, tp, stop, limit) do
    creds()
    Binance.create_oco_order(symbol, side, quantity, tp, stop, limit)
  end
end
