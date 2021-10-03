defmodule Pex.BinanceTrade do
  @behaviour Pex.ExchangeBehavior

  alias Pex.ExchangeBehavior
  alias Pex.BinanceExchange
  alias Pex.Orders

  @impl ExchangeBehavior
  @doc """
  See behavior doc
  """
  def coins_list() do
    BinanceExchange.coins_list()
  end

  @doc """
  Gets coins list whitout exhange order
  """
  def coins_list_without_exchange_order() do
    coins_list()
    |> Enum.reduce([], fn
      %{symbol: "USDT"}, acc ->
        acc

      coin, acc ->
        case coin.free > 0.0 do
          true -> [coin.symbol | acc]
          false -> acc
        end
    end)
  end

  @doc """
  Gets coins list without local order
  """
  def coins_list_without_local_order do
    local_orders = Orders.list_orders()

    {:ok, binance_orders} = Binance.get_open_orders()

    binance_orders
    |> Enum.reduce([], fn
      %{symbol: "USDT"}, acc -> acc
      coin, acc -> create_list_without_order(acc, local_orders, coin)
    end)
    |> Enum.group_by(&(&1.quantity && &1.symbol))
  end

  defp create_list_without_order(acc, local_orders, coin) do
    case find_orders(local_orders, coin.order_id) do
      nil ->
        [
          %{
            symbol: coin.symbol,
            order_id: coin.order_id,
            quantity: coin.orig_qty,
            price: coin.price
          }
          | acc
        ]

      _ ->
        acc
    end
  end

  defp find_orders(orders, order_id) do
    Enum.find(orders, fn order ->
      order.take_profit_order_id == Integer.to_string(order_id) or
        order.stop_loss_order_id == Integer.to_string(order_id)
    end)
  end

  def create_trade(%{
        stop_loss_order_id: stop_loss_order_id,
        take_profit_order_id: take_profit_order_id,
        price: price,
        symbol: symbol
      }) do
    {:ok, orders} = Binance.get_open_orders(symbol)
    stop_loss = Enum.find(orders, &(&1.order_id == String.to_integer(stop_loss_order_id)))
    take_profit = Enum.find(orders, &(&1.order_id == String.to_integer(take_profit_order_id)))

    case stop_loss.orig_qty == take_profit.orig_qty do
      false ->
        {:error, "quantities are not the same"}

      true ->
        Orders.create_order(%{
          symbol: symbol,
          quantity: stop_loss.orig_qty,
          stop_loss: stop_loss.price,
          stop_loss_order_id: stop_loss_order_id,
          take_profit: take_profit.price,
          take_profit_order_id: take_profit_order_id,
          side: take_profit.side,
          price: price,
          platform: "binance"
        })
    end
  end

  @doc """
  Creates a shad local order
  """
  def create_shad(%{
        take_profit_order_id: take_profit_order_id,
        price: price,
        symbol: symbol
      }) do
    {:ok, orders} = Binance.get_open_orders(symbol)

    case Enum.find(orders, &(&1.order_id == String.to_integer(take_profit_order_id))) do
      nil ->
        {:error, "take_profit_order_id not found"}

      take_profit ->
        Orders.create_order(%{
          symbol: symbol,
          quantity: take_profit.orig_qty,
          take_profit: take_profit.price,
          take_profit_order_id: take_profit_order_id,
          side: take_profit.side,
          price: price,
          type: "shad",
          platform: "binance"
        })
    end
  end

  def add_price(order_id, price), do: Orders.update_order(order_id, %{price: price})

  def add_stop_loss(symbol, stop_loss_order_id, order_id) do
    {:ok, orders} = Binance.get_open_orders(symbol)
    binance_order = Enum.find(orders, &(&1.order_id == stop_loss_order_id))

    order_id
    |> Orders.update_order(%{
      stop_loss_order_id: stop_loss_order_id,
      stop_loss: binance_order.price
    })
  end

  def add_take_profit(symbol, take_profit_order_id, order_id) do
    {:ok, orders} = Binance.get_open_orders(symbol)
    binance_order = Enum.find(orders, &(&1.order_id == take_profit_order_id))

    order_id
    |> Orders.update_order(%{
      take_profit_order_id: take_profit_order_id,
      take_profit: binance_order.price
    })
  end

  @doc """
  Get price ofr a symbol

  ## Examples

      iex> Pex.BinanceTrade.get_price("CHZUSDT")
      "0.25"
  """
  def get_price(symbol) do
    {:ok, %{price: price}} = Binance.get_price(symbol)
    price
  end

  @impl ExchangeBehavior
  @doc """
  See behavior doc
  """
  def synchronize_orders() do
    # {:ok, orders} = Binance.get_open_orders()

    # Enum.each(orders, fn order ->
    # order.order_id
    # |> Integer.to_string()
    # |> Trade.get_order()
    # |> create_order(order)
    # end)
  end

  # defp create_order(nil, order) do
  # Trade.create_order(%{
  # quantity: order.orig_qty,
  # symbol: order.symbol,
  # price: order.price,
  # exchange_order_id: Integer.to_string(order.order_id),
  # side: order.side,
  # state: "open",
  # platform: "binance"
  # })

  # :ok
  # end

  # defp create_order(_a, _order), do: :ok
end
