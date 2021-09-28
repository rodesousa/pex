defmodule Pex.BinanceTrade do
  @behaviour Pex.TradeBehavior

  alias Pex.{Trade, TradeBehavior}
  alias Pex.Trade.Order
  alias Pex.BinanceExchange

  @impl TradeBehavior
  @doc """
  See behavior doc
  """
  def orders do
    BinanceExchange.coins_list()
  end

  @impl TradeBehavior
  @doc """
  See behavior doc
  """
  def synchronize_orders() do
    {:ok, orders} = Binance.get_open_orders()

    Enum.each(orders, fn order ->
      order.order_id
      |> Integer.to_string()
      |> Trade.get_order()
      |> create_order(order)
    end)
  end

  defp create_order(nil, order) do
    Trade.create_order(%{
      quantity: order.orig_qty,
      symbol: order.symbol,
      price: order.price,
      exchange_order_id: Integer.to_string(order.order_id),
      side: order.side,
      state: "open",
      platform: "binance"
    })

    :ok
  end

  defp create_order(_a, _order), do: :ok
end
