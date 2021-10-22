defmodule Pex.KucoinTrade do
  @behaviour Pex.Exchange

  alias Pex.Data

  @api Application.get_env(:pex, :kucoin_api)

  @impl Pex.Exchange
  def get_balance() do
    {:ok, %{"data" => data}} = @api.get_account

    price = fn
      0.0, _symbol ->
        0.0

      value, coin ->
        value * coin_price_usdt(%{currencies: coin})
    end

    data
    |> Enum.reduce(0, fn
      %{
        "balance" => balance,
        "currency" => coin
      },
      acc ->
        {balance, _e} = Float.parse(balance)
        price.(balance, coin) + acc
    end)
    |> Float.ceil(2)
  end

  @doc """
  Gets coin price in USDT

  # Examples

      iex> coin_price_usdt("SOL")
      1.0
  """
  def coin_price_usdt(%{currencies: "USDT"}), do: 1

  def coin_price_usdt(params) do
    {:ok, %{"data" => data}} = @api.get_price(params)

    [price] = Enum.map(data, fn {_symbol, price} -> price end)

    String.to_float(price)
  end

  @doc """
  List of coins in Kucoin portfolio

  # Examples

      iex> coins_list()
      [%{symbol: "SOL", free: 0.0, locked: 1.0}, ...}
  """
  @impl Pex.Exchange
  def coins_list() do
    {:ok, %{"data" => data}} = @api.get_account

    data
    |> Enum.reduce([], fn
      %{"available" => "0"}, acc ->
        acc

      %{
        "currency" => coin,
        "holds" => holds,
        "available" => available
      },
      acc ->
        {free, _e} = Integer.parse(available)
        {locked, _e} = Integer.parse(holds)
        [%{symbol: coin, free: free, locked: locked} | acc]
    end)
  end

  @doc """
  List of coins whitout Kucoin order

  # Examples

      iex> coins_list_without_exchange_order
      ["BNB"]
  """
  @impl Pex.Exchange
  def coins_list_without_exchange_order() do
    {:ok, %{"data" => data}} = @api.get_account
    {:ok, %{"data" => %{"items" => orders}}} = @api.get_stop_order()

    data
    |> Enum.reduce([], fn
      %{"currency" => "USDT"}, acc ->
        acc

      %{"available" => "0"}, acc ->
        acc

      %{"available" => available, "currency" => coin}, acc ->
        case coin_has_stop_orders?(coin, available, orders) do
          false -> [coin | acc]
          true -> acc
        end
    end)
  end

  @doc false
  def coin_has_stop_orders?(coin, quantity, stop_orders) do
    Enum.filter(stop_orders, fn
      %{"size" => size, "symbol" => symbol} ->
        symbol = symbol |> String.split("-") |> List.first()
        {quantity, _e} = Float.parse(quantity)
        {size, _e} = Float.parse(size)

        coin == symbol and flexible_equality(quantity, size)
    end)
    |> Enum.empty?()
    |> Kernel.not()
  end

  defp flexible_equality(a, b) do
    if a > b do
      (a - b) / a < 0.01
    else
      (b - a) / b < 0.01
    end
  end

  @doc """
  Gets coins list without trade

  # Examples

      iex> coins_list_without_trade()
      %{"AIONUSDT" => %{order_id: 1, price: 10.0, quantity: 5.5, symbol: "BNB/USDT"}, ...}
  """
  @impl Pex.Exchange
  def coins_list_without_trade do
    trades = Data.list_trades() |> Enum.filter(&(&1.platform == "kucoin"))
    {:ok, %{"data" => %{"items" => orders}}} = @api.get_stop_order()

    orders
    |> Enum.reduce([], fn order, acc ->
      create_list_without_order(acc, trades, order)
    end)
    |> Enum.group_by(&(&1.quantity && &1.symbol))
  end

  defp create_list_without_order(acc, trades, order) do
    case find_orders(trades, order["id"]) do
      nil ->
        [
          %{
            symbol: order["symbol"],
            order_id: order["id"],
            quantity: order["size"],
            price: order["stopPrice"]
          }
          | acc
        ]

      _ ->
        acc
    end
  end

  defp find_orders(orders, order_id) do
    Enum.find(orders, fn order ->
      order.take_profit_order_id == order_id or
        order.stop_loss_order_id == order_id
    end)
  end
end
