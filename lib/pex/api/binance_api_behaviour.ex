defmodule Pex.BinanceAPIBehaviour do
  @callback get_price(String.t()) :: {:ok, map()} | {:error, String.t()}

  @callback get_account() :: {:ok, map()} | {:error, String.t()}
  @callback get_open_orders() :: {:ok, [%Binance.Order{}]} | {:error, String.t()}
  @callback get_open_orders(String.t()) :: {:ok, [%Binance.Order{}]} | {:error, String.t()}
  @callback order_market_buy(String.t(), String.t()) ::
              {:ok, %Binance.Order{}} | {:error, String.t()}
  @callback order_limit_sell(String.t(), float, float) ::
              {:ok, %Binance.Order{}} | {:error, String.t()}

  @callback create_oco_order(String.t(), String.t(), float, float, float, float) ::
              {:ok, map} | {:error, any}
end
