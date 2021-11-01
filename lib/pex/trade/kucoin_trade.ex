defmodule Pex.KucoinTrade do
  @behaviour Pex.Exchange

  alias Pex.Data
  alias Pex.RiskManagement, as: RM

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
  def coin_price_usdt(symbol) when is_binary(symbol), do: coin_price_usdt(%{currencies: symbol})
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
    {:ok, %{"data" => %{"items" => orders}}} = @api.get_stop_order()

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
        {free, _e} = Float.parse(available)
        {locked, _e} = Float.parse(holds)

        case coin_has_stop_orders?(coin, available, orders) do
          false -> [%{symbol: coin, free: free, locked: locked} | acc]
          true -> [%{symbol: coin, free: 0, locked: locked + free} | acc]
        end
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

  @doc """
  Places a order market buy
  """
  def buy_market(coin, quantity, tp, stop, coin_trade \\ "USDT") do
    {:ok, %{"data" => data}} = @api.get_price(coin)

    price = String.to_float(data[coin])
    pair = "#{coin}-#{coin_trade}"

    # {:ok, %{"code" => "200000"}} =
    # @api.new_order(%{
    # "side" => "buy",
    # "symbol" => pair,
    # "type" => "market",
    # "size" => quantity,
    # "clientOid" => UUID.uuid1()
    # })

    with true <- tp > price do
      strategy = market_strategy(price, stop)

      params =
        %{
          price: price,
          pair: pair,
          tp: tp,
          quantity: quantity
        }
        |> Map.merge(strategy)

      market_sell(params)
    else
      _ -> {:error, "price > tp, but market buy have been done"}
    end
  end

  defp market_strategy(price, nil) when is_float(price),
    do: %{
      tp: price * 2,
      stop: nil,
      limit: nil
    }

  defp market_strategy(price, stop)
       when is_float(price)
       when is_float(stop) do
    %{
      stop: stop,
      limit: RM.computes_limit_from_stop(stop)
    }
  end

  defp market_sell(%{
         pair: pair,
         quantity: quantity,
         tp: tp,
         price: price,
         stop: nil,
         limit: nil
       }) do
    "non"
    |> IO.inspect()

    {:ok, %{"code" => "200000", "data" => data}} =
      @api.new_order(%{
        "side" => "sell",
        "symbol" => pair,
        "type" => "limit",
        "size" => quantity / 2.0,
        "price" => tp,
        "clientOid" => UUID.uuid1()
      })

    Data.create_trade(%{
      symbol: pair,
      quantity: quantity / 2.0,
      take_profit: tp,
      take_profit_order_id: data["orderId"],
      side: "sell",
      price: price,
      platform: "kucoin"
    })
  end

  defp market_sell(%{
         price: bought,
         stop: stop_loss,
         tp: tp,
         limit: limit,
         quantity: quantity,
         pair: pair
       }) do
    compare = fn
      _atom, true -> true
      atom, false -> atom
    end

    with true <- compare.(:price, bought > stop_loss),
         true <- compare.(:stop, stop_loss > limit),
         true <- compare.(:tp, tp > bought) do
      "oui"
      |> IO.inspect()

      {:ok, %{"code" => "200000", "data" => %{"orderId" => stop_loss_order_id}}} =
        @api.new_stop_order(%{
          "clientOid" => UUID.uuid1(),
          "side" => "sell",
          "symbol" => pair,
          "type" => "limit",
          "size" => quantity,
          "price" => limit,
          "stopPrice" => stop_loss
        })

      {:ok, %{"code" => "200000", "data" => %{"orderId" => take_profit_order_id}}} =
        @api.new_stop_order(%{
          "clientOid" => UUID.uuid1(),
          "side" => "sell",
          "symbol" => pair,
          "type" => "limit",
          "size" => quantity,
          "price" => RM.computes_limit_from_stop(tp),
          "stopPrice" => tp
        })

      # {:ok, _a} =
      # Data.create_trade(%{
      # symbol: pair,
      # quantity: quantity,
      # stop_loss: stop_loss,
      # stop_loss_order_id: stop_loss_order_id,
      # take_profit: tp,
      # take_profit_order_id: take_profit_order_id,
      # side: "sell",
      # price: bought,
      # platform: "kucoin"
      # })
    else
      :price ->
        {:error, "price < stop"}

      :stop ->
        {:error, "stop < limit"}

      :tp ->
        {:error, "tp < price"}

      _ ->
        nil
    end
  end
end
