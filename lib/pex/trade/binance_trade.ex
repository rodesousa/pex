defmodule Pex.BinanceTrade do
  @behaviour Pex.Exchange
  alias Pex.Data
  alias Pex.RiskManagement, as: RM

  @api Application.get_env(:pex, :binance_api)

  @impl Pex.Exchange
  @doc """
  Sets binance creds
  """
  def creds() do
    if System.get_env("BINANCE_API_KEY") == "" or System.get_env("BINANCE_SECRET_KEY") == "" do
      {:error, "You have to set BINANCE_API_KEY and BINANCE_SECRET_KEY"}
    else
      Binance.Config.set(:api_key, System.get_env("BINANCE_API_KEY"))
      Binance.Config.set(:secret_key, System.get_env("BINANCE_SECRET_KEY"))
    end
  end

  @doc """
  Returns account balance total in USDT
  """
  def get_balance() do
    {:ok, %{balances: balances}} = @api.get_account()

    capitalization = fn
      0.0, _symbol -> 0.0
      value, symbol -> coin_capitalization(symbol) * value
    end

    balances
    |> Enum.reduce(0, fn
      %{"asset" => asset, "free" => free, "locked" => locked}, acc ->
        capitalization.(String.to_float(free) + String.to_float(locked), asset) + acc
    end)
    |> Float.ceil(2)
  end

  @doc """
  List of coins in our portfolio
  """
  @spec coins_list() :: [map]
  def coins_list() do
    {:ok, %{balances: balances}} = @api.get_account()

    balances
    |> Enum.filter(
      &(String.to_float(&1["free"]) > 0.0001 or String.to_float(&1["locked"]) > 0.0001)
    )
    |> Enum.map(
      &%{
        symbol: &1["asset"],
        free: String.to_float(&1["free"]) |> Float.ceil(4),
        locked: String.to_float(&1["locked"]) |> Float.ceil(4)
      }
    )
  end

  @doc """
  List of coins whitout exchange order

  # Examples

      iex> coins_list_without_exchange_order
      ["BNB"]
  """
  def coins_list_without_exchange_order() do
    coins_list()
    |> Enum.reduce([], fn
      %{symbol: "USDT"}, acc ->
        acc

      coin, acc ->
        case coin_capitalization(coin.symbol) * coin.free > 0.001 do
          true -> [coin.symbol | acc]
          false -> acc
        end
    end)
  end

  @doc """
  Returns the coin capitalisation on USDT

  # Examples

      iex> coin_capitalization("SOL")
      1.0
  """
  def coin_capitalization("USDT"), do: 1

  def coin_capitalization(symbol) do
    with {:ok, %{price: price}} <- @api.get_price(symbol <> "USDT") do
      String.to_float(price)
    else
      _ ->
        {:ok, %{price: btc_price}} = @api.get_price(symbol <> "BTC")
        {:ok, %{price: usdt_price}} = @api.get_price("BTCUSDT")
        String.to_float(usdt_price) * String.to_float(btc_price)
    end
  end

  @doc """
  Gets coins list without local order
  """
  def coins_list_without_local_order do
    local_orders = Data.list_trades()

    {:ok, binance_orders} = @api.get_open_orders()

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

  @doc """
  Creates a trade

  Get stop_loss_order_id and take_profit_order_id
  Checks if the quantity is the same

  # Examples

     iex> create_trade(
       %{
        stop_loss_order_id: "1",
        take_profit_order_id: "1",
        price: 1.0,
        symbol: "SOLUSDT",
        })
      {:ok, %Trade{}}
  """
  def create_trade(%{
        stop_loss_order_id: stop_loss_order_id,
        take_profit_order_id: take_profit_order_id,
        price: price,
        symbol: symbol
      }) do
    {:ok, orders} = @api.get_open_orders(symbol)

    stop_loss = Enum.find(orders, &(&1.order_id == String.to_integer(stop_loss_order_id)))
    take_profit = Enum.find(orders, &(&1.order_id == String.to_integer(take_profit_order_id)))

    case stop_loss.orig_qty == take_profit.orig_qty do
      false ->
        {:error, "quantities are not the same"}

      true ->
        Data.create_trade(%{
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
  Creates a shad trade

  # Examples

      iex> create_shad(
        %{
          symbol: "AIONUSDT",
          take_profit_order_id: "122658019",
          price: 1.0
        })
      {:ok, %Trade{}}
  """
  def create_shad(%{
        take_profit_order_id: take_profit_order_id,
        price: price,
        symbol: symbol
      }) do
    {:ok, orders} = @api.get_open_orders(symbol)

    case Enum.find(orders, &(&1.order_id == String.to_integer(take_profit_order_id))) do
      nil ->
        {:error, "take_profit_order_id not found"}

      take_profit ->
        Data.create_trade(%{
          symbol: symbol,
          quantity: take_profit.orig_qty,
          take_profit: take_profit.price,
          take_profit_order_id: take_profit_order_id,
          side: take_profit.side,
          price: price,
          platform: "binance"
        })
    end
  end

  # def add_stop_loss(symbol, stop_loss_order_id, order_id) do
  #  {:ok, orders} = @api.get_open_orders(symbol)
  #  binance_order = Enum.find(orders, &(&1.order_id == stop_loss_order_id))

  #  order_id
  #  |> Create.update_order(%{
  #    stop_loss_order_id: stop_loss_order_id,
  #    stop_loss: binance_order.price
  #  })
  # end

  # def add_take_profit(symbol, take_profit_order_id, order_id) do
  # {:ok, orders} = @api.get_open_orders(symbol)
  # binance_order = Enum.find(orders, &(&1.order_id == take_profit_order_id))

  # order_id
  # |> Orders.update_order(%{
  # take_profit_order_id: take_profit_order_id,
  # take_profit: binance_order.price
  # })
  # end

  @doc """
  Places a order market buy
  """
  def buy_market(symbol, quantity, tp, distance) do
    {:ok, %{price: price}} = @api.get_price(symbol)
    price = String.to_float(price)

    {:ok, _coin} = @api.order_market_buy(symbol, quantity)
    strategy = strategy_for_buy_market(price, distance)

    params =
      %{
        price: price,
        symbol: symbol,
        tp: tp,
        quantity: quantity
      }
      |> Map.merge(strategy)

    place_trade_for_buy_market(params)
  end

  defp strategy_for_buy_market(price, nil) when is_float(price),
    do: %{tp: price * 2, stop: nil, limit: nil}

  defp strategy_for_buy_market(price, distance)
       when is_float(price)
       when is_float(distance) do
    stop = RM.computes_stop_loss(price, distance)
    limit = RM.computes_limit_from_stop(stop)
    %{stop: stop, limit: limit}
  end

  defp place_trade_for_buy_market(%{
         symbol: symbol,
         quantity: quantity,
         tp: tp,
         stop: nil,
         limit: nil
       }) do
    {:ok, order} = @api.order_limit_sell(symbol, quantity, tp)

    %{
      take_profit_order_id: "#{order.order_id}",
      price: tp,
      symbol: symbol
    }
    |> create_shad()
  end

  defp place_trade_for_buy_market(%{
         price: price,
         stop: stop,
         tp: tp,
         limit: limit,
         quantity: quantity,
         symbol: symbol
       }) do
    compare = fn
      _atom, true -> true
      atom, false -> atom
    end

    with true <- compare.(:price, price > stop),
         true <- compare.(:stop, stop > limit),
         true <- compare.(:tp, tp > price) do
      {:ok, %{"orderReports" => order_reports}} =
        @api.create_oco_order(symbol, "SELL", quantity, tp, stop, limit)

      create_trade_from_oco(symbol, price, order_reports)
    else
      :price -> {:error, "price < stop"}
      :stop -> {:error, "stop < limit"}
      :tp -> {:error, "tp < price"}
    end
  end

  @doc """
  Creates a trade if oco has been made outside of livebook
  """
  def create_trade_from_oco(symbol, price_bought, order_reports) do
    orders = determine_oco_orders(order_reports)

    create_trade(%{
      price: price_bought,
      symbol: symbol,
      stop_loss_order_id: "#{orders.stop["orderId"]}",
      take_profit_order_id: "#{orders.tp["orderId"]}"
    })
  end

  @doc """
  Get take_profit order and stop_loss order from oco response
  """
  def determine_oco_orders([order1, order2]) do
    case order1["price"] > order2["price"] do
      true -> %{tp: order1, stop: order2}
      false -> %{tp: order2, stop: order1}
    end
  end
end
